import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class Content {
  final int id;
  Offset position;
  double rotationz;
  String datainside;
  bool isActive;
  String type;
  Color color;
  Size size;
  double thickness;
  String? fontfamily;
  Content(
      {required this.id,
      required this.rotationz,
      required this.type,
      this.fontfamily,
      required this.thickness,
      required this.color,
      required this.size,
      required this.position,
      required this.datainside,
      required this.isActive});
  Map<String, dynamic> tojson() {
    String width = json.encode(size.width);
    String height = json.encode(size.height);
    return {
      "thickness": thickness,
      "id": id.toString(),
      "position": json.encode([position.dx, position.dy]),
      "datainside": datainside,
      "isActive": isActive.toString(),
      "type": type,
      "width": width,
      "rotationz": rotationz,
      "height": height,
      "color": color.value,
      "fontfamily": fontfamily ?? ""
    };
  }

  factory Content.fromjson(Map<String, dynamic> d) {
    List<dynamic> ps = json.decode(d["position"]) as List<dynamic>;
    double x = ps[0];
    double y = ps[1];

    Offset positions = Offset(x, y);
    double width = json.decode(d["width"]);
    double height = json.decode(d["height"]);
    Size sizes = Size(width, height);
    // log("before return");
    final content = Content(
        rotationz: d["rotationz"],
        thickness: d["thickness"],
        id: int.parse(d["id"]),
        type: d['type'],
        color: Color(d["color"]),
        fontfamily: d["fontfamily"],
        size: sizes,
        position: positions,
        datainside: d['datainside'].toString(),
        isActive: d["isActive"] == "true" ? true : false);
    log("after return");
    return content;
  }
}
