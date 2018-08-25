import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 199, 0),
        accentColor: const Color.fromARGB(255, 222, 233, 226),
        brightness: Brightness.dark,
        canvasColor: Colors.black,
      ),
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  Animation<int> _characterCount;

  int _stringIndex;
  static const List<String> _kStrings = const <String>[
    'Call trans opt: received. 2-19-98 13:24:18 REC:Log>',
    'Trace program running.',
    '[312]555-0690',
  ];
  String get _currentString => _kStrings[_stringIndex % _kStrings.length];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.textTheme.title.copyWith(
      fontFamily: 'Courier New',
      color: theme.primaryColor,
    );
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.navigate_next),
        onPressed: () async {
          AnimationController controller = new AnimationController(
            duration: const Duration(milliseconds: 4000),
            vsync: this,
          );
          setState(() {
            _stringIndex = _stringIndex == null ? 0 : _stringIndex + 1;
            _characterCount = new StepTween(begin: 0, end: _currentString.length)
                .animate(new CurvedAnimation(parent: controller, curve: Curves.easeIn));
          });
          await controller.forward();
          controller.dispose();
        },
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
        child: _characterCount == null ? null : new AnimatedBuilder(
          animation: _characterCount,
          builder: (BuildContext context, Widget child) {
            String text = _currentString.substring(0, _characterCount.value);
            return new Text(text, style: textStyle);
          },
        ),
      ),
    );
  }
}