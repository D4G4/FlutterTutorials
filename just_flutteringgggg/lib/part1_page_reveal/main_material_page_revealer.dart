import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part1_page_reveal/page.dart';
import 'package:just_flutteringgggg/part1_page_reveal/page_reveal.dart';
import 'package:just_flutteringgggg/part1_page_reveal/pager_indicator.dart';
import 'package:just_flutteringgggg/part1_page_reveal/page_dragger.dart';
import 'dart:async';

class MaterialPageRevealer extends StatefulWidget {
  _MaterialPageRevealerState createState() => _MaterialPageRevealerState();
}

class _MaterialPageRevealerState extends State<MaterialPageRevealer>
    with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger dragger;

  int activeIndex = 0;
  SlideDirection slideDirection = SlideDirection.NONE;
  double slidePercent = 0.0;
  int nextPageIndex = 0;

  _MaterialPageRevealerState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.DRAGGING) {
          slideDirection = event.direction;
          slidePercent = event.slidePercentage;

          if (slideDirection == SlideDirection.LEFT_TO_RIGHT) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.RIGHT_TO_LEFT) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.DONE_DRAGGING) {
          // Start animation
          dragger = AnimatedPageDragger(
            slideDirection: slideDirection,
            slidePercent: slidePercent,
            slideUpdateStream: slideUpdateStream,
            transitionGoal: (slidePercent > 0.5)
                ? TransitionGoal.OPEN
                : TransitionGoal.CLOSE,
            vsync: this,
          )..run();
          if (slidePercent > 0.5) nextPageIndex = activeIndex;
        } else if (event.updateType == UpdateType.ANIMATING) {
          print('animating');
          slideDirection = event.direction;
          slidePercent = event.slidePercentage;
        } else if (event.updateType == UpdateType.DONE_ANIMATING) {
          print('done animating');
          // if (slidePercent > 0.5) {
          //   activeIndex = slideDirection == SlideDirection.LEFT_TO_RIGHT
          //       ? activeIndex - 1
          //       : activeIndex + 1;
          // }
          // nextPageIndex = activeIndex;

          activeIndex = nextPageIndex;
          slideDirection = SlideDirection.NONE;
          slidePercent = 0.0;
          dragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            viewModel: hardcodedPages[activeIndex],
            percentVisible: 1.0,
          ),

          // Page where clip-animation will occur
          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              viewModel: hardcodedPages[nextPageIndex],
              percentVisible: slidePercent,
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
                    activeIndex: activeIndex,
                    slideDirection: slideDirection,
                    slidePercent: slidePercent),
              ),
            ],
          ),
          PageDragger(
            slideUpdateStream: slideUpdateStream,
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < hardcodedPages.length - 1,
          ),
        ],
      ),
    );
  }
}
