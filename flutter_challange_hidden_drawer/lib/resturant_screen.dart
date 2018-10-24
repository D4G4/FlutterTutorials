import 'package:flutter/material.dart';
import 'package:flutter_challange_hidden_drawer/zoom_scaffold.dart';

final Screen restaurantScreen = Screen(
    title: 'THE PALEO PADDOCK',
    background: DecorationImage(
      image: AssetImage('assets/wood_bk.jpg'),
      fit: BoxFit.cover,
    ),
    contentBuilder: (BuildContext context) {
      return ListView(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        children: <Widget>[
          _RestaurantCard(
            imageAssetSrc: 'assets/eggs_in_skillet.jpg',
            heartCount: 82,
            icon: Icons.local_dining,
            iconBackgroundColor: Colors.orange,
            title: 'il domacca',
            subTitle: '78 5th AVENUE, NEW YORK',
          ),
          _RestaurantCard(
            imageAssetSrc: 'assets/steak_on_cooktop.jpg',
            heartCount: 102,
            icon: Icons.fastfood,
            iconBackgroundColor: Colors.red,
            title: 'MC Grady',
            subTitle: '79 5th AVENUE, NEW YORK',
          ),
          _RestaurantCard(
            imageAssetSrc: 'assets/spoons_of_spices.jpg',
            heartCount: 2,
            icon: Icons.local_drink,
            iconBackgroundColor: Colors.purpleAccent,
            title: 'Just random stuff',
            subTitle: 'PAKISTAN',
          ),
        ],
      );
    });

class _RestaurantCard extends StatelessWidget {
  final String imageAssetSrc;
  final String title;
  final String subTitle;
  final int heartCount;
  final IconData icon;
  final Color iconBackgroundColor;

  _RestaurantCard({
    this.imageAssetSrc,
    this.title,
    this.subTitle,
    this.heartCount,
    this.icon,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 10.0,
      child: Column(
        children: <Widget>[
          Image.asset(
            imageAssetSrc,
            width: double.infinity,
            height: 150.0,
            fit: BoxFit.cover,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'mermaid',
                    ),
                  ),
                  subtitle: Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'bebas-neue',
                      letterSpacing: 1.0,
                      color: const Color(0xFFAAAAAA),
                    ),
                  ),
                ),
              ),
              Container(
                width: 2.0,
                height: 70.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white,
                    const Color(0xFFAAAAAA),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      heartCount > 0 ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    Text(heartCount.toString())
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
