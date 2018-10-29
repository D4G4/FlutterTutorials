import 'package:flutter/material.dart';

class SlidingDrawer extends StatelessWidget {
  final Widget drawer;
  final OpenableController openableController;

  SlidingDrawer({@required this.drawer, @required this.openableController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: openableController.isOpen() ? openableController.close : null,
        ),
        FractionalTranslation(
          translation: Offset(
            1.0 - openableController.percentOpen,
            0.0,
          ), //Doesn't work on pixels but percentages
          child: Align(alignment: Alignment.centerRight, child: drawer),
        )
      ],
    );
  }
}

class OpenableController extends ChangeNotifier {
  OpenableState _state = OpenableState.CLOSED;

  AnimationController _opening;

  OpenableController({
    @required TickerProvider vsync,
    @required Duration duration,
  }) : _opening = AnimationController(vsync: vsync, duration: duration) {
    _opening
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = OpenableState.OPENING;
            break;
          case AnimationStatus.completed:
            _state = OpenableState.OPEN;
            break;
          case AnimationStatus.reverse:
            _state = OpenableState.CLOSING;
            break;
          case AnimationStatus.dismissed:
            _state = OpenableState.CLOSED;
            break;
          default:
        }
        notifyListeners();
      });
  }

  get state => _state;

  get percentOpen => _opening.value; //TOOD

  bool isOpen() => _state == OpenableState.OPEN;

  bool isOpening() => _state == OpenableState.OPENING;

  bool isClosed() => _state == OpenableState.CLOSED;

  bool isClosing() => _state == OpenableState.CLOSING;

  void open() {
    _opening.forward();
  }

  void close() {
    _opening.reverse();
  }

  void toggle() {
    isClosed() ? open() : close();
  }
}

enum OpenableState {
  CLOSED,
  OPENING,
  OPEN,
  CLOSING,
}
