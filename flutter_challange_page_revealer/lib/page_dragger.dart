import 'package:flutter/material.dart';
import 'package:flutter_challange_page_revealer/pager_indicator.dart';
import 'dart:async';
import 'dart:ui';

class PageDragger extends StatefulWidget {
  final StreamController<SlideUpdate> slideUpdateStream;

  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  PageDragger(
      {@required this.slideUpdateStream,
      this.canDragLeftToRight = false,
      this.canDragRightToLeft = false});

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;

      final dx = dragStart.dx - newPosition.dx;

      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.RIGHT_TO_LEFT;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.LEFT_TO_RIGHT;
      } else {
        slideDirection = SlideDirection.NONE;
      }

      if (slideDirection != SlideDirection.NONE)
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      else
        slidePercent = 0.0;

      widget.slideUpdateStream.add(SlideUpdate(
        slidePercent: slidePercent,
        direction: slideDirection,
        updateType: UpdateType.DRAGGING,
      ));

      //print('Dragging $slideDirection at $slidePercent%');
    }
  }

  onDragEnd(DragEndDetails details) {
    dragStart = null;
    widget.slideUpdateStream.add(SlideUpdate(
      slidePercent: 0.0,
      direction: SlideDirection.NONE,
      updateType: UpdateType.DONE_DRAGGING,
    ));
  }

  @override
  Widget build(context) => GestureDetector(
        onHorizontalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
      );
}

enum TransitionGoal { OPEN, CLOSE }

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    @required this.slideDirection,
    @required this.transitionGoal,
    @required TickerProvider vsync,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
  }) {
    var endSlidePercent;
    var duration;

    final startSlidePercent = slidePercent;

    if (transitionGoal == TransitionGoal.OPEN) {
      endSlidePercent = 1.0;
      final slideRemainig = 1 - slidePercent;
      duration = Duration(
        milliseconds: (slideRemainig / PERCENT_PER_MILLISECOND).round(),
      );
    } else {
      endSlidePercent = 0.0;
      duration = Duration(
          milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    completionAnimationController = AnimationController(
      vsync: vsync,
      duration: duration,
    )
      ..addListener(() {
        slidePercent = lerpDouble(
          startSlidePercent,
          endSlidePercent,
          completionAnimationController.value,
        );
        slideUpdateStream.add(SlideUpdate(
            updateType: UpdateType.ANIMATING,
            direction: slideDirection,
            slidePercent: slidePercent));
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(SlideUpdate(
            updateType: UpdateType.DONE_ANIMATING,
            direction: slideDirection,
            slidePercent: endSlidePercent,
          ));
        }
      });
  }
  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}

enum UpdateType { DRAGGING, DONE_DRAGGING, ANIMATING, DONE_ANIMATING }

class SlideUpdate {
  final direction;
  final slidePercent;
  final updateType;

  SlideUpdate({
    @required this.direction,
    @required this.slidePercent,
    @required this.updateType,
  });
}
