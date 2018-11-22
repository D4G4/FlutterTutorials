import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_flutteringgggg/part1_page_reveal/pager_indicator.dart';
import 'dart:ui';

class PageDragger extends StatefulWidget {
  final StreamController<SlideUpdate> slideUpdateStream;
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  PageDragger({
    @required this.slideUpdateStream,
    this.canDragLeftToRight,
    this.canDragRightToLeft,
  });

  @override
  PageDraggerState createState() {
    return new PageDraggerState();
  }
}

class PageDraggerState extends State<PageDragger> {
  // How far do we need to drag to constitute full drag
  static const FULL_TRANSITION_PX = 300;
  Offset dragStart;

  SlideDirection slideDirection;

  double slidePercent = 0.0;
  _onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    //print('dragStart ${dragStart.dx}');
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      // Get difference between start and where we are currently touching the screen
      final newPosition = details.globalPosition;

      final horizontalDelta = dragStart.dx - newPosition.dx;
      // print('horizontalDelta $horizontalDelta');
      // print('dx ${newPosition.dx}');

      if (horizontalDelta > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.RIGHT_TO_LEFT;
      } else if (horizontalDelta < 0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.LEFT_TO_RIGHT;
      } else {
        slideDirection = SlideDirection.NONE;
      }

      if (slideDirection != SlideDirection.NONE) {
        slidePercent =
            (horizontalDelta / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }
    }

    widget.slideUpdateStream.add(SlideUpdate(
      direction: slideDirection,
      updateType: UpdateType.DRAGGING,
      slidePercentage: slidePercent,
    ));
  }

  _onDragEnd(DragEndDetails details) {
    dragStart = null;
    widget.slideUpdateStream.add(SlideUpdate(
      direction: SlideDirection.NONE,
      updateType: UpdateType.DONE_DRAGGING,
      slidePercentage: 0.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
      ),
    );
  }
}

enum UpdateType { DRAGGING, DONE_DRAGGING, ANIMATING, DONE_ANIMATING }

// A class which simply fires streamUpdate with it's each iteration
class AnimatedPageDragger {
  // How quickly we want to expand or contract
  // You can also do that on the basis of dragVelocity, but it's complicated and here goes our : TODO
  // We can decice whether to expand or contract by a certain percent every millisecond
  static const PERCENT_PER_MILLISECOND = 0.005; //Based on experimentation

  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    var startSlidPercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.OPEN) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;

      duration = Duration(
          milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round());
    } else if (transitionGoal == TransitionGoal.CLOSE) {
      endSlidePercent = 0.0;
      // Jitna slide kiya tha tha, utna hi vaapis
      duration = Duration(
          milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }
    completionAnimationController =
        AnimationController(vsync: vsync, duration: duration)
          ..addListener(() {
            slideUpdateStream.add(
              SlideUpdate(
                  direction: slideDirection,
                  slidePercentage: lerpDouble(startSlidPercent, endSlidePercent,
                      completionAnimationController.value),
                  updateType: UpdateType.ANIMATING),
            );
          })
          ..addStatusListener((AnimationStatus status) {
            print('status $status');
            if (status == AnimationStatus.completed) {
              print('firing ocmpleted');
              slideUpdateStream.add(SlideUpdate(
                  direction: slideDirection,
                  slidePercentage: endSlidePercent,
                  updateType: UpdateType.DONE_ANIMATING));
            }
          });
  }

  void run() {
    completionAnimationController.forward();
  }

  void dispose() {
    completionAnimationController.dispose();
  }
} //end of class

enum TransitionGoal {
  OPEN,
  CLOSE,
}

class SlideUpdate {
  final SlideDirection direction;
  final UpdateType updateType;
  final double slidePercentage;

  SlideUpdate({
    this.direction = SlideDirection.NONE,
    this.updateType = UpdateType.DONE_DRAGGING,
    this.slidePercentage = 0.0,
  });
}
