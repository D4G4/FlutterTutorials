import 'package:flutter/material.dart';
import 'package:flutter_challange_hidden_drawer/zoom_scaffold.dart';

final otherScreen = Screen(
  title: 'OTHER SCREEN',
  background: DecorationImage(
      image: AssetImage('assets/other_screen_bk.jpg'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(const Color(0xCC000000), BlendMode.multiply)),
  contentBuilder: (BuildContext context) {
    return Center(
      child: Container(
        height: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Card(
            child: Column(
              children: <Widget>[
                Image.asset('assets/other_screen_card_photo.jpg'),
                Expanded(
                  child: Text('This is another screen'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  },
);
