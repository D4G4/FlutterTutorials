import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part2_hidden_drawer/screen.dart';

final otherScreen = Screen(
  title: 'OTHER SCREEN',
  decorationImage: DecorationImage(
    image: AssetImage('assets/other_screen_bk.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
      const Color(0xCC000000),
      BlendMode.multiply,
    ),
  ),
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
                  child: Center(
                    child: Text(
                      'This is another screen!',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'mermaid',
                          fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  },
);
