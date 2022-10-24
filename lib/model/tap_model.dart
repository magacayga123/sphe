import 'package:flutter/cupertino.dart';

class TapModel {
  final String hint;
  final int id;
  final IconData icondata;
  bool isActive;
  TapModel(
      {required this.hint,
      required this.id,
      required this.icondata,
      required this.isActive});
}
