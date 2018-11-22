import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
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
            createMenuTitle(),
            createMenuItems(),
          ],
        ),
      ),
    );
  }

  createMenuTitle() {
    return Transform(
      transform: Matrix4.translationValues(-100.0, 0.0, 0.0),
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
    );
  }

  createMenuItems() {
    return Transform(
      transform: Matrix4.translationValues(00.0, 225.0, 0.0),
      child: Column(
        children: <Widget>[
          _MenuListItem(
            title: 'THE PADDOCK',
            isSelected: true,
          ),
          _MenuListItem(
            title: 'THE HERO',
            isSelected: false,
          ),
          _MenuListItem(
            title: 'HELP US GROW',
            isSelected: false,
          ),
          _MenuListItem(
            title: 'SETTINGS',
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  _MenuListItem({this.title = 'n/a', this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : () {},
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
  final List<_MenuListItem> menuList;
  final int selectedIndex;

  MenuList({this.menuList, this.selectedIndex});
}
