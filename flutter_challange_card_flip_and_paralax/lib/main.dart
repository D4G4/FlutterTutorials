import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:flutter_challange_card_flip_and_paralax/card_data.dart';
import 'dart:math';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double scrollPercent = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Room for status bar
          Container(
            width: double.infinity,
            height: 20.0,
          ),

          //Cards
          Expanded(
            child: CardFlipper(
                cards: demoCards,
                onScroll: (double scrollPercent) {
                  setState(() {
                    this.scrollPercent = scrollPercent;
                  });
                }),
          ),

          //BottomBar
          BottomBar(cardCount: demoCards.length, scrollPercent: scrollPercent)
        ],
      ),
    );
  }
}

class CardFlipper extends StatefulWidget {
  final List<CardViewModel> cards;
  final Function(double) onScroll;

  CardFlipper({this.cards, this.onScroll});

  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with TickerProviderStateMixin {
  double scrollPercent = 0.0;

  Offset startDrag;
  double startDragPercentScroll;
  double
      finishScrollStart; //Percentage of scroll when user stops dragging, at what percentage user let go of the card.
  double finishScrollEnd;

  AnimationController finishScrollController;

  int numCards;

  @override
  void initState() {
    super.initState();
    numCards = widget.cards.length;

    finishScrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(
              finishScrollStart, finishScrollEnd, finishScrollController.value);
          //print("addListener() $scrollPercent");
          if (null != widget.onScroll) widget.onScroll(scrollPercent);
        });
      });
  }

  @override
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      // -ve bcz of graph
      //0.0 is correct for left but if we'll mark it as 100%, it will take us to the last card. so (1.0 - (1/ totalNoOfCards))
      scrollPercent =
          (startDragPercentScroll + (-singleCardDragPercent / numCards))
              .clamp(0.0, 1.0 - (1 / numCards));
      //print('scrollPercent $scrollPercent');

      if (null != widget.onScroll) widget.onScroll(scrollPercent);
    });
  }

  /// Find the scrollPercentage when user stopped dragging
  /// Then figure out the endPercentage of scroll, i.e. whether we should go backwards or forward
  /// We achieved this by .round()
  /// Then simply use animationController values to perform the scrolling animation
  void _onHorizontalDragEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent; //where user ended their scrolling
    // Figuring out where do we want to animate to! What's the nearest card to snap to (so we used .round())
    // By dividing by numberOfCards we get percentage from 0 -> 1
    finishScrollEnd = (scrollPercent * numCards).round() / numCards;
    finishScrollController.forward(
        from: 0.0); //from: 0.0 says run the full animation

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.cards.map((CardViewModel viewModel) {
      ++index;
      return _buildCard(viewModel, index, numCards, scrollPercent);
    }).toList();
  }

// ScrollPercent: ScrollPercentage of the cards
  Widget _buildCard(CardViewModel viewModel, int cardIndex, int cardCount,
      double totalScrollPercentage) {
    //How many cards we have scrolled to the left
    //Scroll Percentage of all the cards / fraction of individual card
    final cardScrollPercent = totalScrollPercentage / (1 / cardCount);

    /// if we are 3rd card out of 5, our essential scroll position is 3/5th
    /// Of the whole 100% scrolling, our beginning is 3/5th i.e. 60%
    ///
    /// So we wanna know, how far to the left have we scrolled our current card.
    final parallax = scrollPercent - (cardIndex / cardCount);

    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Transform(
          transform: _buildCardProjection(cardScrollPercent - cardIndex),
          child: Card(
            viewModel: viewModel,
            parallaxPercent: parallax,
          ),
        ),
      ),
    );
  }

  _buildCardProjection(double scrollPercent) {
    /// Pre-multiplied matrix of a projection matrix and a view matrix;
    ///
    /// Projection matrix is a simplified perspective matrix
    /// (http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf)
    /// in the form of
    /// [
    ///   [1.0, 0.0, 0.0, 0.0],
    ///   [0.0, 1.0, 0.0, 0.0],
    ///   [0.0, 0.0, 1.0, 0.0],
    ///   [0.0, 0.0, -perspective, 1.0]
    /// ]
    ///
    /// View matrix is simplified camera view matrix.
    /// Basically re-scales to keep object at original size at angle = 0 at
    /// any radius in the form of
    /// [
    ///   [1.0, 0.0, 0.0, 0.0],
    ///   [0.0, 1.0, 0.0, 0.0],
    ///   [0.0, 0.0, 1.0, -radius],
    ///   [0.0, 0.0, 0.0, 1.0]
    /// ]

    final perspective = 0.007;
    final radius = 1.0; //Actual size
    final angle = scrollPercent * pi / 8;
    final horizontalTranslation = 0.0;

    Matrix4 projection = new Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1.0);

    // Model matrix by first
    // translating the object from the origin of the world by radius in the z axis
    // and then rotating against the world.
    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
    print('Angle: $angle');
    projection *= Matrix4.translationValues(
            horizontalTranslation + (rotationPointMultiplier * 300.0),
            0.0,
            0.0) *
        Matrix4.rotationY(angle) *
        Matrix4.translationValues(0.0, 0.0, radius) *
        Matrix4.translationValues(-rotationPointMultiplier * 300.0, 0.0, 0.0);
    return projection;
  }

  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Stack(
          children: _buildCards(),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final CardViewModel viewModel;
  final double parallaxPercent;

  Card({this.viewModel, this.parallaxPercent});
  @override
  Widget build(BuildContext context) {
    return Stack(
      //By default, stack allow the content within them to be smaller
      //than the available space if they want to, so:
      fit: StackFit.expand,
      children: <Widget>[
        //Background
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FractionalTranslation(
            translation: Offset(parallaxPercent * 2.0,
                0.0), //2.0 is just arbitrary, to move it more than usual
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Image.asset(
                viewModel.backdropAssetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        //Content
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Text(
                viewModel.address.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'patita',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${viewModel.minHeightInFeet} - ${viewModel.maxHeightInFeet}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
                    fontFamily: 'petita',
                    letterSpacing: -5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                  child: Text(
                    'FT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'petita',
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${viewModel.tempInDegrees}°',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        viewModel.weatherType,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${viewModel.windSpeedInMph}mph ${viewModel.cardinalDirection}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  BottomBar({this.cardCount, this.scrollPercent});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 5.0,
              child: ScrollIndicator(
                cardCount: cardCount,
                scrollPercent: scrollPercent,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({this.cardCount, this.scrollPercent});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
        cardCount: cardCount,
        scrollPercent: scrollPercent,
      ),
      child: Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int cardCount;
  final double scrollPercent;

  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({this.cardCount, this.scrollPercent})
      : trackPaint = Paint()
          ..color = const Color(0xFF444444)
          ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    //Draw the tarck
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: Radius.circular(3.0),
          topRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0),
        ),
        trackPaint);

    //Draw the thumb
    final thumbWith = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(thumbLeft, 0.0, thumbWith, size.height),
          topLeft: Radius.circular(3.0),
          topRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0),
        ),
        thumbPaint);
  }

  @override
  bool shouldRepaint(ScrollIndicatorPainter oldPainter) {
    return true;
  }
}

//Superscrip isnt' available in flutter at this moment

// RichText(
//   text: TextSpan(
//     children: [
//       TextSpan(
//         text: 'Tap here',
//         style: TextStyle(fontSize: 50.0),
//         recognizer: TapGestureRecognizer()
//           ..onTap = () => Scaffold.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Ok'),
//                   duration: const Duration(milliseconds: 500),
//                 ),
//               ),
//       ),
//       TextSpan(
//         text: 'FT',
//         style: TextStyle(fontSize: 10.0),
//       )
//     ],
//   ),
// ),
