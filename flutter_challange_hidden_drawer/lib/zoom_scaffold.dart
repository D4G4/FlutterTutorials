import 'package:flutter/material.dart';

class ZoomedScaffold extends StatefulWidget {
  final Screen activeScreen;
  final Widget menuScreen;

  ZoomedScaffold({this.activeScreen, this.menuScreen});
  _ZoomedScaffoldState createState() => _ZoomedScaffoldState();
}

class _ZoomedScaffoldState extends State<ZoomedScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;

  //That another way to use Curve
  Curve screenScaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve screenScaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  Curve screenSlideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve screenSlideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

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

  Widget createContentDisplay() => zoomAndSlideContent(Container(
        decoration: BoxDecoration(image: widget.activeScreen.background),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(widget.activeScreen.title,
                  style: TextStyle(
                    fontFamily: 'bebas-neue',
                    fontSize: 25.0,
                  )),
              centerTitle: true,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  menuController.toggle();
                },
              ),
            ),
            body: widget.activeScreen.contentBuilder(context)),
      ));

  Widget zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (menuController.state) {
      case MenuState.CLOSED:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.OPEN:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.OPENING:
        slidePercent =
            screenSlideOutCurve.transform(menuController.percentOpen);
        scalePercent =
            screenScaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.CLOSING:
        slidePercent = screenSlideInCurve.transform(menuController.percentOpen);
        scalePercent = screenScaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * menuController.percentOpen;

    return Transform(
        transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
          ..scale(contentScale, contentScale),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: const Color(0x4400F0F0),
              offset: Offset(0.0, 5.0),
              spreadRadius: 10.0,
              blurRadius: 20.0,
            )
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius),
            child: content,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        widget.menuScreen,
        createContentDisplay(),
      ],
    );
  }
}

/// This widget finds an anscestor of `_ZoomedScaffoldState` and gets `MenuController`
/// out of it and passes it to it's `builder() (typeDef)`
/// and whatever builder function returns,
/// that's what it is going to render.
class ZoomedScaffoldMenuController extends StatefulWidget {
  final ZoomedScaffoldBuilder zoomedScaffoldBuilder;

  ZoomedScaffoldMenuController({this.zoomedScaffoldBuilder});

  _ZoomedScaffoldMenuControllerState createState() =>
      _ZoomedScaffoldMenuControllerState();
}

class _ZoomedScaffoldMenuControllerState
    extends State<ZoomedScaffoldMenuController> {
  //whosoever calls this method says somewhere above them in a widget tree
  // there is a _ZoomedScaffoldState, the one that contains MenuController
  getMenuController(BuildContext context) {
    print('getMenuController');
    final _ZoomedScaffoldState scaffoldState =
        context.ancestorStateOfType(TypeMatcher<_ZoomedScaffoldState>())
            as _ZoomedScaffoldState;
    return scaffoldState.menuController;
  }

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

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('zoomed_scaffold.dart build()');
    //A menthod named zoomedScaffoldBuilder will be called and returned
    //Definition of which will be described inside the Calling widget.
    return widget.zoomedScaffoldBuilder(context, menuController);
  }
}

typedef Widget ZoomedScaffoldBuilder(
  BuildContext context,
  MenuController menuController,
);

class Screen {
  final String title;
  final DecorationImage background;
  final WidgetBuilder contentBuilder;

  Screen({
    this.title,
    this.background,
    this.contentBuilder,
  });
}

///[ChangeNotifier] allows us to accumulate listeners and to notifiy the changes
class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.CLOSED;

  MenuController({this.vsync})
      : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 300)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.OPENING;
            break;
          case AnimationStatus.reverse:
            state = MenuState.CLOSING;
            break;
          case AnimationStatus.completed: // reached 1 (forward)
            state = MenuState.OPEN;
            break;
          case AnimationStatus.dismissed: //just reached 0 from reverse
            state = MenuState.CLOSED;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.OPEN)
      close();
    else if (state == MenuState.CLOSED) open();
  }
}

enum MenuState { CLOSED, OPEN, OPENING, CLOSING }
