import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part2_hidden_drawer/screen.dart';
import 'package:just_flutteringgggg/part2_hidden_drawer/menu_screen.dart';

class ZoomedScaffold extends StatefulWidget {
  final MenuScreen menuScreen;
  final Screen activeScreen;

  ZoomedScaffold({this.activeScreen, this.menuScreen});
  _ZoomedScaffoldState createState() => _ZoomedScaffoldState();
}

class _ZoomedScaffoldState extends State<ZoomedScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;

  Curve scaleDownCurve = Interval(0.0, 0.3,
      curve: Curves
          .easeOut); // We want the entire animation to happen in first 30%
  Curve scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    menuController = MenuController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.menuScreen,
        _createContentFromScreens(),
      ],
    );
  }

  _createContentFromScreens() {
    return zoomAndSlideContent(
      Container(
        decoration: BoxDecoration(image: widget.activeScreen.decorationImage),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                menuController.toggle();
              },
            ),
            title: Text(widget.activeScreen.title),
          ),
          body: widget.activeScreen.contentBuilder(context),
        ),
      ),
    );
  }

  zoomAndSlideContent(Widget content) {
    final percentOpen = menuController.percentOpen;
    var slidePerent, scalePercent;
    //print('percentOpen = $percentOpen');
    switch (menuController.state) {
      case MenuState.CLOSED:
        slidePerent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.OPEN:
        slidePerent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.OPENING:
        //print('MenuState.opening');
        slidePerent = slideOutCurve.transform(percentOpen);
        scalePercent = scaleDownCurve.transform(percentOpen);
        // print('slidePercent = $slidePerent');
        // print('scalePercent = $scalePercent');
        // print('\n\n');
        break;
      case MenuState.CLOSING:
        slidePerent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePerent;
    final contentScale = 1 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * percentOpen;
    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(
          contentScale,
          contentScale,
        ),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0x44FF0000),
                offset: const Offset(0.0, 5.0),
                spreadRadius: 10.0,
                blurRadius: 20.0),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius),
          child: content,
        ),
      ),
    );
  }
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController controller;
  MenuState state = MenuState.CLOSED;

  MenuController({@required this.vsync})
      : controller = AnimationController(vsync: vsync) {
    controller
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward: /* started from zero */
            state = MenuState.OPENING;
            break;
          case AnimationStatus.reverse: /* started from 1 */
            state = MenuState.CLOSING;
            break;
          case AnimationStatus.completed: /* reached 1 */
            state = MenuState.OPEN;
            break;
          case AnimationStatus.dismissed: /* done reversing, reached 0 */
            state = MenuState.CLOSED;
            break;
        }
        notifyListeners();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  get percentOpen {
    return controller.value;
  }

  open() {
    controller.forward();
    notifyListeners();
  }

  close() {
    controller.reverse();
    notifyListeners();
  }

  toggle() {
    if (state == MenuState.OPEN) {
      close();
    } else if (state == MenuState.CLOSED) {
      open();
    }
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({this.builder});

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  MenuController menuController;
  @override
  void initState() {
    super.initState();
    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  MenuController getMenuController(BuildContext context) {
    /// Somewhere above the widgetTree is the [_ZoomedScaffoldState]
    /// (the one that contains `MenuController`)
    /// Because the actual MenuScreen is lower that this state. So it can look for it's ancestor
    final _ZoomedScaffoldState scaffoldState =
        context.ancestorStateOfType(TypeMatcher<_ZoomedScaffoldState>())
            as _ZoomedScaffoldState;
    return scaffoldState.menuController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.builder(context, getMenuController(context)),
    );
  }
}

// We would like our menu system to provide one of these functions
// so that we can give our Menu, a menu controller
// coz the question is, how do we get to our Menu.
typedef Widget ZoomScaffoldBuilder(
  BuildContext context,
  MenuController controller,
);

enum MenuState { CLOSED, OPEN, OPENING, CLOSING }
