import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photoshop/model/tap_model.dart';

class Activeness with ChangeNotifier {
  bool hasGrid = false;
  List<TapModel> taps = [
    TapModel(hint: "file", id: 0, icondata: Icons.file_open, isActive: false),
    TapModel(hint: "save", id: 1, icondata: Icons.save, isActive: false),
    TapModel(
        hint: "add text", id: 2, icondata: Icons.text_fields, isActive: false),
    TapModel(
        hint: "grid", id: 3, icondata: Icons.grid_4x4_sharp, isActive: false),
    TapModel(hint: "circle", id: 4, icondata: Icons.circle, isActive: false),
    TapModel(
        hint: "Rectangle", id: 5, icondata: Icons.rectangle, isActive: false),
    TapModel(hint: "Resize", id: 6, icondata: Icons.expand, isActive: false),
    TapModel(hint: "color", id: 7, icondata: Icons.color_lens, isActive: false),
    TapModel(hint: "background", id: 8, icondata: Icons.image, isActive: false),
    TapModel(
        hint: "photo", id: 9, icondata: Icons.add_a_photo, isActive: false),
    TapModel(
        hint: "empty circle",
        id: 10,
        icondata: Icons.circle_outlined,
        isActive: false),
    TapModel(
        hint: "empty rectangle",
        id: 11,
        icondata: Icons.rectangle_outlined,
        isActive: false),
    TapModel(
        hint: "curved shape", id: 12, icondata: Icons.egg, isActive: false),
    TapModel(
        hint: "rotate",
        id: 13,
        icondata: Icons.rotate_90_degrees_cw_rounded,
        isActive: false),
  ];

  void selection(int id) {
    taps.forEach((element) {
      if (element.id == id) {
        element.isActive = !element.isActive;
      } else {
        element.isActive = false;
      }
    });

    notifyListeners();
  }

  void toggleGrid() {
    hasGrid = !hasGrid;
    notifyListeners();
  }
}
