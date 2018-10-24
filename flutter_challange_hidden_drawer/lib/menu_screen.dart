import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Widget createMenuTitle() => Transform(
      transform: Matrix4.translationValues(-100.0, 0.0, 0.0),
      child: OverflowBox(
        //Allows you to render beyond the screen
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
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
        ),
      ));

  Widget createMenuItems() {
    return Transform(
      transform: Matrix4.translationValues(0.0, 255.0, 0.0),
      child: ListView(
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
            title: 'HELP US GRROW',
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/dark_grunge_bk.jpg'), fit: BoxFit.cover),
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
}

class _MenuListItem extends StatelessWidget {
  final bool isSelected;
  final String title;

  _MenuListItem({this.isSelected, this.title});

  @override
  Widget build(BuildContext context) => InkWell(
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
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      );
}
