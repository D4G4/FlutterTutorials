import 'package:flutter/material.dart';

class OtherTutorialApp extends StatefulWidget {
  _OtherTutorialState createState() => _OtherTutorialState();
}

class _OtherTutorialState extends State<OtherTutorialApp>
    with SingleTickerProviderStateMixin {
  TabController tabControler;

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'LEFT',
      icon: Icon(Icons.arrow_left),
    ),
    Tab(
      text: 'RIGHT',
      icon: Icon(Icons.arrow_right),
    ),
  ];

  @override
  void initState() {
    tabControler = TabController(length: myTabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context,
                    bool innerBoxIsScrolled) =>
                <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        "Collapsing Toolbar",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      background: Image.network(
                          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                          fit: BoxFit.cover),
                    ),
                    // bottom: TabBar(
                    //     labelColor: Colors.red,
                    //     unselectedLabelColor: Colors.white,
                    //     controller: tabControler,
                    //     tabs: myTabs),
                  ),
                  // SliverPadding(
                  //   padding: EdgeInsets.all(16.0),
                  //   sliver: SliverList(
                  //     delegate: SliverChildListDelegate([
                  //       TabBar(
                  //           labelColor: Colors.red,
                  //           unselectedLabelColor: Colors.white,
                  //           controller: tabControler,
                  //           tabs: myTabs),
                  //     ]),
                  //   ),
                  // )
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                          labelColor: Colors.red,
                          unselectedLabelColor: Colors.green,
                          controller: tabControler,
                          tabs: myTabs),
                    ),
                  ),
                ],
            body: TabBarView(
              controller: tabControler,
              children: myTabs
                  .map((Tab tab) => Center(child: Text(tab.text)))
                  .toList(),
            )),
      );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        child: _tabBar,
      );

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
