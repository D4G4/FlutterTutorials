import 'package:flutter/material.dart';
import 'package:t5_grid_tabs_steepers/src/my_app_grid.dart';

class MyApp extends StatefulWidget {
  @override
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  dispose() {
    tabController?.dispose();
    super.dispose();
  }

  TabBar makeTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          icon: Icon(
            Icons.home,
            size: 30.0,
          ),
          text: "Home",
        ),
        Tab(
          icon: Icon(Icons.settings_power, size: 30.0),
          text: "Settings",
        )
      ],
      controller: tabController,
    );
  }

//Connecting TabBar to TabBarView so that it knows
//which view to look at based on the tab that has been clicked
  TabBarView makeTabBaView(widgets) {
    return TabBarView(children: widgets, controller: tabController);
  }

  @override
  Widget build(context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Tabs Demo"),
              backgroundColor: Colors.redAccent,
              bottom: makeTabBar(),
            ),
            body: makeTabBaView(<Widget>[
              TheGridView().build(),
              SimpleWidgetForSecondScreen()
            ])));
  }
}

class SimpleWidgetForSecondScreen extends StatefulWidget {
  @override
  createState() => SimpleWidgetState();
}

class SimpleWidgetState extends State<SimpleWidgetForSecondScreen> {
  int stepCounter = 0;

  List<Step> steps = [
    Step(
      title: Text("Step one"),
      content: Text("This is the first step"),
      isActive: true,
    ),
    Step(
      title: Text("Step 2"),
      content: Text("This is the second step"),
      isActive: false,
    ),
    Step(
      title: Text("Step 3"),
      content: Text("This is the third step"),
      isActive: false,
    ),
    Step(
        title: Text("Step 4"),
        content: Text("This is the fourth step"),
        isActive: false,
        state: StepState.complete),
  ];

  @override
  build(context) => Container(
          child: Stepper(
        currentStep: this.stepCounter,
        steps: steps,
        type: StepperType.vertical,
        onStepTapped: (stepIndex) {
          setState(() {
            stepCounter = stepIndex;
          });
        },
        onStepCancel: () {
          setState(() {
            stepCounter > 0 ? stepCounter -= 1 : stepCounter = 0;
            steps[stepCounter + 1] = Step(
              state: steps[stepCounter + 1].state,
              isActive: false,
              title: steps[stepCounter + 1].title,
              content: steps[stepCounter + 1].content,
            );
          });
        },
        onStepContinue: () {
          setState(() {
            stepCounter < steps.length - 1 ? stepCounter++ : stepCounter = 0;
            steps[stepCounter] = Step(
              state: steps[stepCounter].state,
              isActive: true,
              title: steps[stepCounter].title,
              content: steps[stepCounter].content,
            );
          });
        },
      ));
}
