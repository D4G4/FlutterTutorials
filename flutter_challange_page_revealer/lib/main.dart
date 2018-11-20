import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_challange_page_revealer/page.dart';

import 'package:flutter_challange_page_revealer/page_reveal.dart';
import 'package:flutter_challange_page_revealer/pager_indicator.dart';
import 'package:flutter_challange_page_revealer/page_dragger.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Page Reveal',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  _HomeState() : slideUpdateStream = StreamController<SlideUpdate>();

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.NONE;
  double slidePercent = 0.0;

  void initState() {
    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.DRAGGING) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
          if (slideDirection == SlideDirection.LEFT_TO_RIGHT) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.RIGHT_TO_LEFT) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
          print(
              'DRAGGING nextPageIndex $nextPageIndex activePageIndex $activeIndex');
          // nextPageIndex = slideDirection == SlideDirection.leftToRight
          //     ? activeIndex + 1
          //     : activeIndex - 1;
        } else if (event.updateType == UpdateType.DONE_DRAGGING) {
          animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: (slidePercent > 0.5)
                  ? TransitionGoal.OPEN
                  : TransitionGoal.CLOSE,
              vsync: this,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream);
          animatedPageDragger.run();
          if (slidePercent <= 0.5) nextPageIndex = activeIndex;
          print(
              'DONE_DRAGGING nextPageIndex $nextPageIndex activePageIndex $activeIndex');
        } else if (event.updateType == UpdateType.ANIMATING) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.DONE_ANIMATING) {
          // activeIndex = slideDirection == SlideDirection.LEFT_TO_RIGHT
          //     ? activeIndex - 1
          //     : activeIndex + 1;
          activeIndex = nextPageIndex;
          //reset
          slideDirection = SlideDirection.NONE;
          slidePercent = 0.0;
          animatedPageDragger.dispose();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0,
          ),
          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          PageIndicator(
            viewModel: PageIndicatorViewModel(
                pages: pages,
                activeIndex: activeIndex,
                slideDirection: slideDirection,
                slidePercent: slidePercent),
          ),
          PageDragger(
            slideUpdateStream: slideUpdateStream,
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
          ),
        ],
      ),
    );
  }
}
