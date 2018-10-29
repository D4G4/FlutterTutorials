import 'package:flutter/material.dart';

class RadialListItem extends StatelessWidget {
  final RadialListItemViewModel listItem;

  RadialListItem({this.listItem});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
