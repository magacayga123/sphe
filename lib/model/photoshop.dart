import 'package:photoshop/model/content.dart';

class Photoshop {
  List<Content> contents;
  int id;
  String background;
  DateTime lasEdit;
  Photoshop(
      {required this.contents,
      required this.id,
      required this.lasEdit,
      required this.background});
}
