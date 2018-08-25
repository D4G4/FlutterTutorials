import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

final ThemeData iOSTheme = ThemeData(
    primarySwatch: Colors.red,
    primaryColor: Colors.grey[400],
    primaryColorBrightness: Brightness.dark);

final ThemeData androidTheme =
    ThemeData(primarySwatch: Colors.red, accentColor: Colors.deepOrangeAccent);

const String defaultUserName = "John Doe";

void main() => runApp(new ChatApp());

class ChatApp extends StatelessWidget {
  @override
  build(_) => MaterialApp(
        title: "Chat Application",
        theme: foundation.defaultTargetPlatform == TargetPlatform.iOS
            ? iOSTheme
            : androidTheme,
        home: Chat(),
      );
}

class Chat extends StatefulWidget {
  @override
  createState() => ChatWindow();
}

//TickerProvider will allow the screen to scroll like a ticker every single time a user inputs a new message.
class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];

  /// Will control what's happneing with our input box
  final TextEditingController _textController = TextEditingController();

  bool _isWriting = false;

  @override
  build(_) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Chat App"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
              reverse: true,
              padding: const EdgeInsets.all(6.0),
            ),
          ),
          Container(
            child: _buildInputLayout(),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputLayout() {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor, size: 10.0),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 9.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isWriting = text.isNotEmpty;
                      });
                    },
                    textCapitalization: TextCapitalization.sentences,
                    maxLengthEnforced: false,
                    maxLength: 20,
                    onSubmitted: _submitMessage,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    ///[Change here]  This will remove the bottom line of TextField
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter some text to send a message"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMessage(_textController.text)
                              : null)
                      : IconButton(
                          icon: Icon(
                            Icons.message,
                          ),
                          onPressed: _isWriting
                              ? () => _submitMessage(_textController.text)
                              : null,
                        ),
                )
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.brown),
                    ),
                  )
                : BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Theme.of(context).accentColor),
                    ),
                  )));
  }

  _submitMessage(String text) {
    _textController.clear();

    setState(() {
      _isWriting = false;
    });

    Msg msg = Msg(
      txt: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1800),
      ),
    );

    setState(() {
      //_isWriting = false;
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  //  Dispose all the animation controllers to avoid memory leaks
  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});

  final String txt;
  final AnimationController animationController;

  @override
  build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.elasticOut),
      axisAlignment: 0.0, //Streatches all the way to window
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, //Starts where the row starts
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                child: Text(
                  "${defaultUserName[0]}${defaultUserName.split(" ")[1][0]} ",
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    defaultUserName,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      txt,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//What have I learnt

/// Icon buttons can change color on the basis of method provided to their onPressed
/// In order to change the color, put it under [IconTheme]
///
/// [CircleAvatar], how it works
///
/// In order to start an animatin, you have to perofrm `.forward()` or `.reverse()`
