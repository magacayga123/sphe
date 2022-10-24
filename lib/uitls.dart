import 'package:flutter/material.dart';
import 'package:photoshop/constants.dart';

Future<String> getText(BuildContext context) async {
  final controllerx = TextEditingController();
  final simple = TextStyle();
  bool? okeyed = await showDialog<bool>(
      context: context,
      builder: (c) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AlertDialog(
            title: Text(
              "insert text",
              textAlign: TextAlign.center,
            ),
            content: TextField(
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "enter override text",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              controller: controllerx,
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.of(context).pop(false);
                  },
                  child: Text("cancel", style: simple)),
              TextButton(
                  onPressed: () {
                    return Navigator.of(context).pop(true);
                  },
                  child: Text("ok", style: simple))
            ],
          ),
        );
      });
  return okeyed! ? controllerx.text : "";
}

Future<bool> allowed(BuildContext context, String text) async {
  bool? allowed = await showDialog(
      context: context,
      builder: (contexte) {
        return AlertDialog(
            content: Text(text),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(true);
                },
                child: Text(
                  "YES",
                ),
              ),
              TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
                child: Text(
                  "NO",
                ),
              )
            ]);
      });

  if (allowed == null || allowed == false) {
    return false;
  } else {
    return true;
  }
}

String formated(DateTime date) {
  int monthindex = date.month;
  int year = date.year;
  int day = date.day;
  int hour = date.hour;
  int min = date.minute;

  List<String> months = [
    "",
    "jan",
    "feb",
    "mar",
    "apr",
    "may",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ];
  String formatted = "$day/${months[monthindex]}/$year at $hour:$min";
  return formatted;
}
