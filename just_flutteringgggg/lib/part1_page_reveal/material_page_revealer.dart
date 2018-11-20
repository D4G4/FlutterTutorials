import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part1_page_reveal/page.dart';
import 'package:just_flutteringgggg/part1_page_reveal/page_reveal.dart';
import 'package:just_flutteringgggg/part1_page_reveal/pager_indicator.dart';

class MaterialPageRevealer extends StatefulWidget {
  _MaterialPageRevealerState createState() => _MaterialPageRevealerState();
}

class _MaterialPageRevealerState extends State<MaterialPageRevealer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            viewModel: hardcodedPages[0],
            percentVisible: 1.0,
          ),
          PageReveal(
            revealPercent: 1.0,
            child: Page(
              viewModel: hardcodedPages[1],
              percentVisible: 0.9,
            ),
          ),

          //BottomIndicator
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              PagerIndicator(
                pagerIndicatorViewModel: PagerIndicatorViewModel(
                    pages: hardcodedPages,
                    activeIndex: 1,
                    slideDirection: SlideDirection.RIGHT_TO_LEFT,
                    slidePercent: 0.5),
              ),
            ],
          )
        ],
      ),
    );
  }
}
