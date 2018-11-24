import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/zoomed_scaffold.dart';

class MenuScreen extends StatefulWidget {
  final MenuList menuList;
  final Function(String) onMenuItemSelected;
  final String selectedMenuItemId;

  MenuScreen({this.menuList, this.onMenuItemSelected, this.selectedMenuItemId});
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;

  void initState() {
    super.initState();
    titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )..addStatusListener((status) {
        print('status = $status');
      });
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomScaffoldMenuController(
      builder: (context, MenuController menuController) {
        // print('inside menuController');
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/dark_grunge_bk.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                createMenuTitle(menuController.state),
                createMenuItems(menuController),
              ],
            ),
          ),
        );
      },
    );
  }

  createMenuTitle(MenuState state) {
    // print('createMenuTitle $state');
    switch (state) {
      case MenuState.OPEN:
      case MenuState.OPENING:
        titleAnimationController.forward();
        break;
      case MenuState.CLOSED:
      case MenuState.CLOSING:
        titleAnimationController.reverse();
        break;
    }

    return AnimatedBuilder(
      animation: titleAnimationController,
      child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Menu',
            style: TextStyle(
              color: const Color(0x88444444),
              fontSize: 240.0,
              fontFamily: 'mermaid',
            ),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.translationValues(
            250 * (1.0 - titleAnimationController.value) - 100,
            0.0,
            0.0,
          ),
          child: child,
        );
      },
    );
  }

  createMenuItems(MenuController controller) {
    // print('State ${controller.state}');
    var selectedIndex = 0;
    List<AnimatedMenuItem> itemsList = [];

    var animationIntervalDuration = 0.5;

    // Only make the item delay to zero when we are closing
    var perItemDelay = (controller.state != MenuState.CLOSING) ? 0.15 : 0.0;
    //var perItemDelay = (controller.state == MenuState.OPENING) ? 0.15 : 0.0;

    for (var i = 0; i < widget.menuList.items.length; i++) {
      MenuItem menuItem = widget.menuList.items[i];
      var startAnimation = i * perItemDelay;
      var endAnimation = animationIntervalDuration + perItemDelay;
      // print('startAnimation $startAnimation');
      // print('endAnimation $endAnimation');
      // print('\n\n');
      itemsList.add(
        AnimatedMenuItem(
          curve: Interval(startAnimation, endAnimation, curve: Curves.easeOut),
          duration: const Duration(
              milliseconds:
                  600 /*Make it 4600 and see the difference after you'll close the drawer */),
          menuState: controller.state,
          menuListItem: _MenuListItem(
              title: menuItem.title,
              isSelected: widget.selectedMenuItemId == menuItem.id,
              onTap: () {
                widget.onMenuItemSelected(menuItem.id);
                controller.close();
              }),
        ),
      );
    }
    return Transform(
      transform: Matrix4.translationValues(0.0, 225.0, 0.0),
      child: Column(
        children: itemsList,
      ),
    );
  }
}

/// `----------------------------------------------------------------------------------------`
/// RealCase: when you change the theme from light to dark, the whole app doens't flip a switch,
/// instead the entire theme animates.
/// it says `"Something about me is animatable"`
class AnimatedMenuItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final Duration duration;
  final MenuState menuState;
  AnimatedMenuItem({this.menuListItem, this.menuState, this.duration, curve})
      : super(duration: duration, curve: curve);
  _AnimatedMenuItemState createState() => _AnimatedMenuItemState();
}

/// This class calls [build] each frame that the animation tickets
/// It gives us some sort of "machinery" that allows us to automatically calculate + apply those values.
/// [ImplicitlyAnimatedWidgetState], a superclass (which makes you call setState())
class _AnimatedMenuItemState extends AnimatedWidgetBaseState<AnimatedMenuItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translationTween;
  Tween<double> _opacityTween;

  @override
  void forEachTween(TweenVisitor tweenVisitor /* It's a type def */) {
    var opacity, slidePosition;

    switch (widget.menuState) {
      case MenuState.CLOSED:
      case MenuState.CLOSING:
        slidePosition = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.OPEN:
      case MenuState.OPENING:
        slidePosition = openSlidePosition;
        opacity = 1.0;
        break;
    }
    _translationTween = tweenVisitor(
      _translationTween,
      slidePosition,
      (dynamic value) => Tween<double>(begin: value),
    );

    _opacityTween = tweenVisitor(
      _opacityTween,
      opacity,
      (dynamic value) {
        print('value = $value');
        return Tween<double>(begin: value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build() -> ${_translationTween.evaluate(animation)}');
    print('\n');
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        _translationTween
            .evaluate(animation) /* `animation` is from superClass */,
        0.0,
      ),
      child: Opacity(
          opacity: _opacityTween.evaluate(animation),
          child: widget.menuListItem),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;

  _MenuListItem({this.title = 'n/a', this.isSelected = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }
}

class MenuList {
  final List<MenuItem> items;
  final int selectedIndex;

  MenuList({this.items, this.selectedIndex});
}

class MenuItem {
  final String id;
  final String title;

  MenuItem({this.id, this.title});
}
