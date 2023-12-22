import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final dynamic item;
  final Animation<double> animation;
  final VoidCallback? onClicked;
  const ListItemWidget(
      {required this.item,
      required this.animation,
      required this.onClicked,
      super.key});

  @override
  Widget build(BuildContext context) => SizeTransition(
        key: ValueKey(""),
        sizeFactor: animation,
        child: buildItem(),
      );
  Widget buildItem() => Container(
        color: Colors.greenAccent,
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(item["title"]),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: onClicked,
          ),
        ),
      );
}
