import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photoshop/database/database.dart';
import 'package:photoshop/model/content.dart';
import 'package:photoshop/model/photoshop.dart';
import 'package:photoshop/state%20mangement/active.dart';
import 'package:provider/provider.dart';

class ContentsProvider with ChangeNotifier {
  Photoshop photoshop =
      Photoshop(contents: [], id: 0, lasEdit: DateTime.now(), background: "");
  // database related
  Future<List<Photoshop>> getAll() async {
    return Database.read();
  }

  void save() async {
    Photoshop? currentphotoshop = await Database.getPhotoshop(photoshop.id);
    if (currentphotoshop == null) {
      int i = await Database.save(photoshop, photoshop.background);

      log(photoshop.id.toString() + "compare" + i.toString());
    } else {
      int updateoneid = await Database.update(photoshop, currentphotoshop.id);
      log(updateoneid.toString() + " updated");
    }
  }

  void delete(int id, BuildContext context) async {
    int i = await Database.delete(id);
    if (i < 0) return;
    notifyListeners();
    final SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content:
          Text("that photoshop  was successfully deleted from device database"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// background related
  Future<void> setBackground() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result == null) return;
    PlatformFile choosedImage = result.files.first;
    photoshop.background = choosedImage.path!;
    notifyListeners();
  }

  void removebackground() {
    photoshop.background = "";
    notifyListeners();
  }

  void openphotoshop(Photoshop photoshopx) {
    photoshop = photoshopx;
    notifyListeners();
  }

  void newfile() {
    photoshop.contents.clear();
    photoshop.id = 0;
    photoshop.background = "";
    notifyListeners();
  }
// content related
  // void addimage(String path,BuildContext context){

  // }
  void addcontent(context,
      {required int id,
      required String datainside,
      required bool isActive,
      required Offset position,
      required String type,
      required double rotationz,
      required Size size,
      required double thickness,
      required Color color}) {
    final content = Content(
        rotationz: rotationz,
        color: color,
        thickness: thickness,
        id: id,
        datainside: datainside,
        size: size,
        isActive: isActive,
        position: position,
        type: type);

    photoshop.contents.add(content);
    photoshop.contents.forEach((e) {
      if (e.id == id) {
        e.isActive = true;
      } else {
        e.isActive = false;
      }
    });
    Provider.of<Activeness>(context, listen: false).taps.forEach((e) {
      if (e.id == 3) {
        e.isActive = true;
      } else {
        e.isActive = false;
      }
    });
    notifyListeners();
  }

  void removecontent(int id) {
    photoshop.contents.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void select(int id) {
    photoshop.contents.forEach((element) {
      if (element.id == id) {
        element.isActive = !element.isActive;
      } else {
        element.isActive = false;
      }
    });

    notifyListeners();
  }

  void changePostionOfActiveContent(DragUpdateDetails details, context) {
    Content activeone =
        photoshop.contents.firstWhere((element) => element.isActive);
    double x = details.localPosition.dx;
    double y = details.localPosition.dy;
    Offset newposition = Offset(x, y);
    activeone.position = newposition;
    notifyListeners();
  }

  void lock(bool value) {
    if (value) {
      photoshop.contents.forEach((element) {
        element.isActive = false;
      });
    }
    notifyListeners();
  }

  double get getsize {
    try {
      Content activeone =
          photoshop.contents.firstWhere((element) => element.isActive);
      return activeone.size.width;
    } catch (e) {
      log(e.toString());
    }
    return 0;
  }

  Content? getActive() {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
      return activeone;
    } catch (e) {
      log(e.toString());
    }
    return activeone;
  }

  void resize(double size, BuildContext context) {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
    } catch (e) {
      log(e.toString());
    }
    if (activeone == null) return;
    bool eligable = Provider.of<Activeness>(context, listen: false)
        .taps
        .firstWhere((element) => element.id == 6)
        .isActive;
    if (eligable) {
      activeone.size = Size(size, 10);
    }
    notifyListeners();
  }

  void rotate(double rotation, BuildContext context) {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
    } catch (e) {
      log(e.toString());
    }
    if (activeone == null) return;
    bool eligable = Provider.of<Activeness>(context, listen: false)
        .taps
        .firstWhere((element) => element.id == 13)
        .isActive;
    if (eligable) {
      activeone.rotationz = rotation;
    }
    notifyListeners();
  }

  Future<void> resizeWidth(double width, BuildContext context) async {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
    } catch (e) {
      log(e.toString());
    }
    if (activeone == null) return;
    bool eligable = Provider.of<Activeness>(context, listen: false)
        .taps
        .firstWhere((element) => element.id == 6)
        .isActive;
    if (eligable) {
      Size previusSize = activeone.size;
      activeone.size = Size(width, previusSize.height);
    }
    notifyListeners();
  }

  Future<void> rethicknessize(double thickness, BuildContext context) async {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
    } catch (e) {
      log(e.toString());
    }
    if (activeone == null) return;
    bool eligable = Provider.of<Activeness>(context, listen: false)
        .taps
        .firstWhere((element) => element.id == 6)
        .isActive;
    if (eligable) {
      double previusThickness = activeone.thickness;
      activeone.thickness = thickness;
    }
    notifyListeners();
  }

  Future<void> resizeHeight(double height, BuildContext context) async {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
    } catch (e) {
      log(e.toString());
    }
    if (activeone == null) return;
    bool eligable = Provider.of<Activeness>(context, listen: false)
        .taps
        .firstWhere((element) => element.id == 6)
        .isActive;
    if (eligable) {
      Size previusSize = activeone.size;
      activeone.size = Size(previusSize.width, height);
    }
    notifyListeners();
  }

  void changeColor(BuildContext context, Color color) {
    Content? activeone;
    try {
      activeone = photoshop.contents.firstWhere((element) => element.isActive);
    } catch (e) {
      log(e.toString());
    }
    if (activeone == null) return;
    bool eligable = Provider.of<Activeness>(context, listen: false)
        .taps
        .firstWhere((element) => element.id == 7)
        .isActive;
    if (eligable) {
      activeone.color = color;
    }
    notifyListeners();
  }
}
