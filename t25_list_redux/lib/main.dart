// Redux-->
// Store: Holds the state of the entire application
// Action: User event which gets dispatched to
// Reducer : A function which updates the state

//With redux, most components are decoupled, making UI changes very easy to make.
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ListState {
  final List<String> items;

  ListState({this.items});

  ListState.initialState() : items = [];
}

//Every application event is represented as an Action that gets dispatched to a Reducer function.
class AddAction {
  final String input;

  AddAction({this.input});
}

//A Reducer updates the Store with a new State depending on what Action it receives.
//And whenever a new State is pushed through the Store, the View is recreated to reflect the changes
//
//Only business logic resides inside this reducer function
//A Reducer function takes an Action and the current application State and it returns a new State object
ListState reducer(ListState state, action) {
  if (action is AddAction) {
    //  Takes old items, pipes them into a new list list and adds the new input into it
    return ListState(
        items: []
          ..addAll(state.items)
          ..add(action.input));
  }
  return ListState(items: state.items);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store =
      Store<ListState>(reducer, initialState: ListState.initialState());
  @override
  Widget build(BuildContext context) {
    ///Wrap entire app in StoreProvider which is basically an `InheritedWidget` which gives
    ///everything in the widget tree the access of the `store` value
    ///Now we can use specialized widgets (`StoreConnector`) to gain access to our `store` anywhere in our application
    return StoreProvider<ListState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: 'Redux List App',
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Home build()");
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text('Redux List'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              ListInput(),
              ViewList(),
            ],
          ),
        ));
  }
}

typedef AddItem(String text);

//It acts as a middleware b/w our reducer and action
//thus we can -process an-** action before it reaches the reducer
class _ViewModel {
  final AddItem addItemToList;
  _ViewModel({this.addItemToList});
}

class ListInput extends StatefulWidget {
  @override
  ListInputState createState() => ListInputState();
}

class ListInputState extends State<ListInput> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("ListInputState build()");

    ///With `StoreConnector` we can connect our current widget with the `store` of the applicaiton from anywhere we want.
    ///Allows us to connect to the `store` in different parts of the application
    ///
    ///It has two major properties associated with it,
    /// `#1 converter`
    ///     Takes our store and converts into a "ViewModel" and the ViewModel is essentially the version of the "model"
    ///     that we can pass into the second property #2 builder
    ///
    // return StoreConnector<ListState, _ViewModel>(
    //   //add TypeAnnotation so we know that we are taking in the ListState and we are dealing with the _ViewModel

    //   //converter: (store) => store.dispatch(AddAction),
    //   converter: (store) => _ViewModel(
    //         addItemToList: (inputText) =>
    //         //**We can manipulate our action's data here
    //             store.dispatch(AddAction(input: inputText)),
    //       ),
    //   builder: (context, _ViewModel viewModel) {
    //     return TextField(
    //       decoration: InputDecoration(hintText: "Enter an item"),
    //       controller: controller,
    //       onSubmitted: (text) {
    //         viewModel.addItemToList(
    //             text); //Now this will be executed in the above statement
    //         controller.text = "";
    //       },
    //     );
    //   },
    // );

///StoreConnector can be used instead of `StoreBuilder` (a widget that receives store form `StoreProvider`)
///StoreConnector allows your to convert `Store` into a `ViewModel`
    return StoreConnector<ListState, VoidCallback>(
        converter: (store) => () {
              store.dispatch(AddAction(input: controller.text));
            },
        builder: (context, dispatch) => TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter an item"),
              onSubmitted: (text) {
                dispatch();
                controller.text = "";
              },
            ));
  }
}

//Stateless because we are not dispatching any action form it
//Because ListInputState is updating out store, it will re-render
//all of the widgets that are connected to our store
class ViewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("ViewList build()");
    return StoreConnector<ListState, List<String>>(
        //List<String> will be ViewModel that will come out of the Converter
        converter: (store) => store.state.items,
        builder: (context, List<String> items) {
          print("ViewList StoreConnector builder()");
          return (Column(
            children: items.map((item) => ListTile(title: Text(item))).toList(),
          ));
        });
  }
}


///`Middleware` is a component that may process an `Action` before it reaches the `Reducer`
///It receives the current application `State` and the `Action` that got dispatched,
///and it can run some code(usually a side effect), s.a communicating with 3rd-party API
///Finally, middleware may decide to dispatch the original `Action`, to dispatch a different one,
///or to do nothing more.