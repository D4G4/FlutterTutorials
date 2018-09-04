import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String _platformVersion;
  Permission permission;

  @override
  void initState() {
    super.initState();
    initPlatform();
  }

  // Just for getting the platform version
  initPlatform() async {
    String platform;

    try {
      platform = await SimplePermissions.platformVersion;
    } on PlatformException {
      platform = 'platform not found';
    }

    //If object is removed from the tree
    if (!mounted) return;

    // otherwise set the platform to our _platformversion global variable
    setState(() {
      _platformVersion = platform;
    });
  }

  @override
  build(context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Permissions')),
            body: Center(
              child: Column(
                children: <Widget>[
                  Text('Platform version is $_platformVersion\n'),
                  Divider(height: 10.0),
                  DropdownButton(
                    items: _getDropdownItems(),
                    value: permission,
                    onChanged: onDropDownChanged,
                  ),
                  Divider(height: 10.0),
                  RaisedButton(
                      onPressed: checkPermission,
                      color: Colors.greenAccent,
                      child: Text('Check permission')),
                  Divider(height: 10.0),
                  RaisedButton(
                    child: Text("Request permission"),
                    color: Colors.orange,
                    onPressed: requestPermission,
                  ),
                  Divider(height: 10.0),
                  RaisedButton(
                    onPressed: getStatus,
                    color: Colors.blue,
                    child: Text("get status"),
                  ),
                  Divider(height: 10.0),
                  RaisedButton(
                    onPressed: SimplePermissions.openSettings,
                    color: Colors.redAccent,
                    child: Text("Open Settings"),
                  )
                ],
              ),
            )));
  }

  // on selection of a permission, assign the value to our global permission variable
  void onDropDownChanged(Permission value) {
    setState(() {
      this.permission = value;
    });
    print(permission);
  }

  void checkPermission() async {
    bool result = await SimplePermissions.checkPermission(permission);
    print("permission is " + result.toString());
  }

  void requestPermission() async {
    bool result = await SimplePermissions.requestPermission(permission);
    print("requested: " + result.toString());
  }

  void getStatus() async {
    final result = await SimplePermissions.getPermissionStatus(permission);
    print("permission status is :" + result.toString());
  }

  List<DropdownMenuItem<Permission>> _getDropdownItems() {
    List<DropdownMenuItem<Permission>> items = List();
    Permission.values.forEach((permission) {
      var item = DropdownMenuItem(
          child: Text(getPermissionString(permission)), value: permission);
      items.add(item);
    });
    return items;
  }
}
