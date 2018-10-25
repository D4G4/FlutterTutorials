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
    final slideAmount = 275.0 * menuController.percentOpen;
    final contentScale = 1.0 - (0.2 * menuController.percentOpen);
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
class ZoomedScaffoldMenuController extends StatelessWidget {
  final ZoomedScaffoldBuilder zoomedScaffoldBuilder;

  ZoomedScaffoldMenuController({this.zoomedScaffoldBuilder});

  getMenuController(BuildContext context) {
    //whoever calls this method says somewhere above them in a widget tree
    // there is a _ZoomedScaffoldState, the one that contains MenuController
    final _ZoomedScaffoldState scaffoldState =
        context.ancestorStateOfType(TypeMatcher<_ZoomedScaffoldState>())
            as _ZoomedScaffoldState;
    return scaffoldState.menuController;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return zoomedScaffoldBuilder(context, getMenuController(context));
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

  MenuController({this.vsync})
      : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
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

  MenuState state = MenuState.CLOSED;

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
