import 'package:flutter/material.dart';

Widget bottomSheet(List<String> list, BuildContext context) {
  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Radio(
            value: index,
            groupValue: "groupValue",
            onChanged: (value) {
              print(value);
            }),
        title: Text(list[index]),
        onTap: () {},
      );
    },
  );
}
