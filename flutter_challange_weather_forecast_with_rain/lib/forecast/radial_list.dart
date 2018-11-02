import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_challange_weather_forecast_with_rain/genericWidgets/radial_position.dart';

//Column -> MainAxisSize

class SlidingRadialList extends StatelessWidget {
  final RadialListViewModel radialList;
  final SlidingRadialListController controller;

  SlidingRadialList({
    this.radialList,
    this.controller,
  });

  Widget _radiaListItem(RadialListItemViewModel viewModel, double angle) {
    return Transform(
      transform: Matrix4.translationValues(40.0, 334.0, 0.0),
      child: RadialPosition(
        radius: 140.0 + 75.0,
        angle: angle,
        child: RadialListItem(
          listItem: viewModel,
        ),
      ),
    );
  }

  List<Widget> _radialListItems() {
    final double firstItemAngle = -pi / 3;
    final double lastItemAngle = pi / 3;
    final double angleDiffPerItem =
        (lastItemAngle - firstItemAngle) / (radialList.items.length - 1);

    double currAngle = firstItemAngle;

    return radialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _radiaListItem(viewModel, currAngle);
      currAngle += angleDiffPerItem;
      return listItem;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: _radialListItems(),
      ),
    );
  }
}

class RadialListItem extends StatelessWidget {
  final RadialListItemViewModel listItem;

  RadialListItem({this.listItem});

  @override
  Widget build(BuildContext context) {
    final circleDecoration = listItem.isSelected
        ? BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ));
    return Transform(
      transform: Matrix4.translationValues(-30.0, -30.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Image(
                image: listItem.icon,
                color: listItem.isSelected
                    ? const Color(0xFF6688CC)
                    : Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  listItem.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  listItem.subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SlidingRadialListController extends ChangeNotifier {
  final double firstItemAngle = -pi / 3;
  final double lastItemAngle = -pi / 3;
  final double startSlidingAngle = 3 * pi / 4;

  final int itemCount;
  final AnimationController _slideController;
  final AnimationController _fadeController;

  RadialListState _state;
  Completer onOpenedCompleter;
  Completed onClosedCompleter;

  List<Animation<double>> _slidePositions;

  SlidingRadialListController({this.itemCount, vsync})
      : _slideController = AnimationController(
            duration: const Duration(milliseconds: 1500), vsync: vsync),
        _fadeController = AnimationController(
            duration: const Duration(milliseconds: 150), vsync: vsync) {
    _slideController
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = RadialListState.SLIDING_OPEN;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.OPEN;
            notifyListeners();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
          default:
        }
      });
    _fadeController
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = RadialListState.FADING_OUT;
            _slideController.value = 0.0;
            _fadeController.value = 0.0;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.CLOSED;
            notifyListeners();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
          default:
        }
      });

    //Add logic later
    final delayInterval = 0.1;
    final slideInterval = 0.5;

    final angleDeltaPerItem =
        (lastItemAngle - firstItemAngle) / (itemCount - 1);

    for (var i = 0; i < itemCount; ++i) {
      final start = delayInterval * i;
      final end = start + slideInterval;

      final endSlideAngle = firstItemAngle + (angleDeltaPerItem * i);

      _slidePositions.add(
        Tween(begin: startSlidingAngle, end: endSlideAngle).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Interval(
              start,
              end,
              curve: Curves.easeInOut,
            ),
          ),
        ),
      );
    }
  }

  double getItemAngle(int index) {
    return _slidePositions[index].value;
  }

  double getItemOpacity(int index) {
    switch (_state) {
      case RadialListState.CLOSED:
        return 0.0;
      case RadialListState.SLIDING_OPEN:
      case RadialListState.OPEN:
        return 1.0;
      case RadialListState.FADING_OUT:
        return (1.0 - _fadeController.value);
      default:
        return 1.0;
    }
  }

  Future<Null> open() {
    if (_state == RadialListState.CLOSED) {
      _slideController.forward();
      
    }
    return null;
  }

  Future<Null> close() {
    if (_state == RadialListState.OPEN) {
      _fadeController.forward();
      //return Future
    }
    return null;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}

enum RadialListState { CLOSED, SLIDING_OPEN, OPEN, FADING_OUT }

class RadialListViewModel {
  final List<RadialListItemViewModel> items;

  RadialListViewModel({
    this.items = const [],
  });
}

class RadialListItemViewModel {
  final ImageProvider icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  RadialListItemViewModel({
    this.icon,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
  });
}
