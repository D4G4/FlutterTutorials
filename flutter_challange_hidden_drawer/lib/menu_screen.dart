import 'package:flutter/material.dart';
import 'package:flutter_challange_hidden_drawer/zoom_scaffold.dart';

final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final String selectedMenuItemId;

  final Function(String) onMenuItemSelected;

  MenuScreen({this.menu, this.onMenuItemSelected, this.selectedMenuItemId})
      : super(key: menuScreenKey);

  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;

  double selectorYTop;
  double selectorYBottom;

  RenderBox _selectedRenderBox;

  selectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    // if (newRenderBox != _selectedRenderBox)
    //   setState(() {
    //     _selectedRenderBox = newRenderBox;
    //   });
    if (newYTop != selectorYTop) {
      setState(() {
        selectorYBottom = newYBottom;
        selectorYTop = newYTop;
      });
    }

    print('YTop =  $newYTop');
    print('\n');
  }

  @override
  initState() {
    super.initState();
    titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  Widget createMenuTitle(MenuController controller) {
    switch (controller.state) {
      case MenuState.OPEN:
      case MenuState.OPENING:
        titleAnimationController.forward();
        break;
      case MenuState.CLOSED:
      case MenuState.CLOSING:
        titleAnimationController.reverse();
        break;
      default:
    }

    Widget title() => Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Menu',
            style: TextStyle(
                color: Color(0x88444444),
                fontSize: 240.0,
                fontFamily: 'mermaid'),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        );

    return AnimatedBuilder(
      animation: titleAnimationController,
      child: title(),
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            250 * (1 - titleAnimationController.value) - 100.0,
            0.0,
            0.0,
          ),
          child: OverflowBox(
            //Allows you to render beyond the screen
            maxWidth: double.infinity,
            alignment: Alignment.topLeft,
            child: child,
          ),
        );
      },
    );
  }

  Widget createMenuItems(MenuController menuController) {
    final List<AnimatedMenuListItem> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay =
        menuController.state == MenuState.OPENING ? 0.15 : 0.0;

    for (var i = 0; i < widget.menu.items.length; ++i) {
      MenuItem menuItem = widget.menu.items[i];
      bool isSelected = widget.selectedMenuItemId == menuItem.id;
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd =
          animationIntervalStart + animationIntervalDuration;
      listItems.add(
        AnimatedMenuListItem(
          menuListItem: _MenuListItem(
            title: menuItem.title,
            isSelected: isSelected,
            onTap: () {
              menuController.close();
              widget.onMenuItemSelected(menuItem.id);
            },
          ),
          menuState: menuController.state,
          duration: const Duration(milliseconds: 600),
          curve: Interval(
            animationIntervalStart,
            animationIntervalEnd,
            curve: Curves.easeOut,
          ),
          isSelected: isSelected,
        ),
      );
    }
    return Transform(
      transform: Matrix4.translationValues(0.0, 255.0, 0.0),
      child: ListView(children: listItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZoomedScaffoldMenuController(
      zoomedScaffoldBuilder: (context, MenuController controller) {
        var shouldRenderSelector = true;
        var actualSelectorYTop = selectorYTop;
        var actualSelectoYBottom = selectorYBottom;
        var selectorOpacity = 1.0;

        if (controller.state == MenuState.CLOSED ||
            controller.state == MenuState.CLOSING ||
            selectorYTop == null) {
          final RenderBox menuScreenRenderBox =
              context.findRenderObject() as RenderBox;

          if (menuScreenRenderBox != null) {
            final menuScreenHeight = menuScreenRenderBox.size.height;

            actualSelectorYTop = menuScreenHeight - 50.0;
            actualSelectoYBottom = menuScreenHeight;
            selectorOpacity = 0.0;
            shouldRenderSelector = true;
          } else {
            // actualSelectorYTop = 0;
            // actualSelectoYBottom = 0.0;
            // selectorOpacity = 0.0;
            shouldRenderSelector = false;
          }
        }

        print('menu_screen.dart');
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/dark_grunge_bk.jpg'),
                fit: BoxFit.cover),
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                createMenuTitle(controller),
                createMenuItems(controller),
                shouldRenderSelector
                    ? ItemSelector(
                        bottomY: actualSelectoYBottom,
                        topY: actualSelectorYTop,
                        maxOpacity: selectorOpacity,
                      )
                    : null
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function onTap;

  _MenuListItem({
    this.isSelected,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        splashColor: const Color(0x44000000),
        onTap: isSelected ? null : onTap,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.white,
                fontSize: 25.0,
                fontFamily: 'bebas-neue',
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      );
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double topY, bottomY, maxOpacity;

  ItemSelector({this.topY, this.bottomY, this.maxOpacity})
      : super(duration: const Duration(milliseconds: 300));

  @override
  _ItemSelectorState createState() => _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    _topY = visitor(_topY, widget.topY, (dynamic value) {
      return Tween<double>(begin: value);
    });
    _bottomY = visitor(_bottomY, widget.bottomY,
        (dynamic value) => Tween<double>(begin: value));
    _opacity = visitor(_opacity, widget.maxOpacity,
        (dynamic value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //Is intented to go in a Stack
      top: _topY.evaluate(animation),
      child: Opacity(
        opacity: _opacity.evaluate(animation),
        child: Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}

//IN flutter catalog app, when you switch the theme from light to dark,
//it animates the switing part, the light colors fade to dark and vice-versa
//
// It says, "Something about me is animatable"
class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final Duration duration;
  final bool isSelected;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.duration,
    this.isSelected,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0; //down
  final double openSlidePositon = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  updateSelectedRenderBox() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null) {
      print('My renderBox size: ${renderBox.size}');
      print(
          'My renderBox size: ${renderBox.localToGlobal(const Offset(0.0, 0.0))}'); //0.0,0.0 -> TopLeft
      if (widget.isSelected)
        (menuScreenKey.currentState as _MenuScreenState)
            .selectedRenderBox(renderBox);

      ///     It's not a good thing to do because this ListItem knows it's parent
      ///     and we are very closely coupling these two things.
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.CLOSED:
      case MenuState.CLOSING:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.OPEN:
      case MenuState.OPENING:
        slide = openSlidePositon;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();
    // TODO: implement build
    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translation.evaluate(animation),
          0.0,
        ),
        child: widget.menuListItem,
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  Menu({this.items});
}

class MenuItem {
  final String id;
  final String title;

  MenuItem({this.title, this.id});
}
