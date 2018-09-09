import 'package:flutter/material.dart';

enum TileState { covered, blown, open, flagged, revealed }

void main() => runApp(new MineSweeper());

class MineSweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: "Mine Sweeper", home: Board());
}

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  final int rows = 9;
  final int cols = 9;
  final int numOfMines = 11;

  List<List<TileState>> uiState; //2D list   R & C
  List<List<bool>> tiles;

//Also initializes the list
  void resetBoard() {
    //Create a list of Row and each item(row) itself is a/4
    uiState = new List<List<TileState>>.generate(rows, (row) {
      return List<TileState>.filled(cols, TileState.covered);
    });

    tiles = new List<List<bool>>.generate(
        rows, (row) => List<bool>.filled(cols, false));
  }

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  Widget buildBoard() {
    List<Row> boardRow = <Row>[];
    for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
      List<Widget> rowChildren = <Widget>[];
      for (int colIndex = 0; colIndex < cols; colIndex++) {
        TileState state = uiState[rowIndex][colIndex];
        if (state == TileState.covered) {
          rowChildren.add(GestureDetector(
            child: Listener(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                height: 30.0,
                width: 30.0,
                color: Colors.grey,
              ),
            ),
          ));
        }
      } //end of ColLoop
      boardRow.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
          key: ValueKey<int>(rowIndex)));
    } //end of rowLoop

    return Container(
        color: Colors.grey[700],
        padding: EdgeInsets.all(10.0),
        child: Column(children: boardRow));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mine Sweeper")),
        body: Container(
          color: Colors.grey[50],
          child: Center(child: buildBoard()),
        ));
  }
}
