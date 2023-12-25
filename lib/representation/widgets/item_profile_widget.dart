import 'package:flutter/material.dart';

class ItemProfileWidget extends StatelessWidget {
  const ItemProfileWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.iconData});

  final String title;
  final String subtitle;
  final Icon iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: iconData,
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}
