import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:photoshop/constants.dart';
import 'package:photoshop/database/database.dart';
import 'package:photoshop/state%20mangement/active.dart';
import 'package:photoshop/state%20mangement/content.dart';
import 'package:photoshop/uitls.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart' as saver;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Service {
  Future<void> saveToGallery(
      ScreenshotController controller, BuildContext context) async {
    String albumname = "Simplified photo editor images";
    Provider.of<ContentsProvider>(context, listen: false)
        .photoshop
        .contents
        .forEach((element) {
      element.isActive = false;
    });
    final dir = await getApplicationDocumentsDirectory();
    String absolute = dir.path.toString();
    File fileimage = await File(path.join(absolute, "image.png")).create();
    final Duration delay = Duration(milliseconds: 300);
    final bytes = await controller.capture(delay: delay);
    fileimage.writeAsBytesSync(bytes!);
    bool? saved = await saver.GallerySaver.saveImage(fileimage.path,
        albumName: albumname);
    final snackBar = SnackBar(
      content:
          Text("Successfully saved in your gallery as simple photoshop images"),
      action: SnackBarAction(
        label: "view this image",
        onPressed: () {
          OpenFile.open(fileimage.path);
        },
      ),
    );
    Provider.of<ContentsProvider>(context, listen: false).save();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> addText(BuildContext context) async {
    String text = await getText(context);
    log(text);
    if (text.isEmpty) return;
    int id = DateTime.now().microsecondsSinceEpoch;
    Size size = Size(14, 10);
    // log(size.height.toString());
    String datainside = text;
    bool isActive = false;
    Offset position = Offset(0, 0);
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        thickness: 3.0,
        rotationz: 0,
        datainside: datainside,
        isActive: isActive,
        position: position,
        size: size,
        color: Theme.of(context).colorScheme.primary,
        type: "text");
  }

  Future<void> addFilledCircle(BuildContext context, Size size) async {
    bool allowedv =
        await allowed(context, "are you sure to insert filled circle");
    if (!allowedv) return;
    int id = DateTime.now().microsecondsSinceEpoch;
    Offset position = Offset(10, 10);
    // double size = 10;
    String datainside = "circle";
    bool isActive = false;
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        thickness: 3.0,
        datainside: datainside,
        rotationz: 0,
        isActive: isActive,
        position: position,
        type: "circle",
        size: size,
        color: Theme.of(context).colorScheme.primary);
  }

  Future<void> addunFilledCircle(BuildContext context, Size size) async {
    bool allowedv =
        await allowed(context, "are you sure to insert non-filled circle");
    if (!allowedv) return;
    int id = DateTime.now().microsecondsSinceEpoch;
    Offset position = Offset(10, 10);
    // double size = 10;
    String datainside = "circle_outlined";
    bool isActive = false;
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        datainside: datainside,
        isActive: isActive,
        position: position,
        thickness: 3.0,
        rotationz: 0,
        type: "circle_outlined",
        size: size,
        color: Theme.of(context).colorScheme.primary);
  }

  Future<void> addFilledRectange(
      double width, double height, BuildContext context) async {
    bool allowedv =
        await allowed(context, "are you sure to insert filled rectangle");
    if (!allowedv) return;
    int id = DateTime.now().microsecondsSinceEpoch;
    Offset position = Offset(10, 20);
    Size size = Size(width, height);
    String datainside = "rectangle";
    bool isActive = false;
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        datainside: datainside,
        isActive: isActive,
        position: position,
        thickness: 3.0,
        rotationz: 0,
        type: "rectangle",
        size: size,
        color: Theme.of(context).colorScheme.primary);
  }

  Future<void> addunFilledRectange(
      double width, double height, BuildContext context) async {
    bool allowedv =
        await allowed(context, "are you sure to insert un-filled rectangle");
    if (!allowedv) return;
    int id = DateTime.now().microsecondsSinceEpoch;
    Offset position = Offset(10, 20);
    Size size = Size(width, height);
    String datainside = "rectangle_outlined";
    bool isActive = false;
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        datainside: datainside,
        isActive: isActive,
        rotationz: 0,
        thickness: 3.0,
        position: position,
        type: "rectangle_outlined",
        size: size,
        color: Theme.of(context).colorScheme.primary);
  }

  Future<void> addoval(
      double width, double height, BuildContext context) async {
    bool allowedv =
        await allowed(context, "are you sure to insert rounded rectangle");
    if (!allowedv) return;
    int id = DateTime.now().microsecondsSinceEpoch;
    Offset position = Offset(10, 20);
    Size size = Size(width, height);
    String datainside = "rectangle_rounded";
    bool isActive = false;
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        datainside: datainside,
        isActive: isActive,
        thickness: 3.0,
        position: position,
        rotationz: 0,
        type: "rectangle_rounded",
        size: size,
        color: Theme.of(context).colorScheme.primary);
  }

// TODO do to insert image
  Future<void> insertImageContent(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result == null) return;
    PlatformFile thefile = result.files.first;
    int id = DateTime.now().microsecondsSinceEpoch;
    Provider.of<ContentsProvider>(context, listen: false).addcontent(context,
        id: id,
        thickness: 3.0,
        datainside: thefile.path.toString(),
        isActive: false,
        position: Offset(0, 0),
        rotationz: 0,
        type: "image",
        size: Size(50, 50),
        color: Colors.transparent);
  }

  Future<void> setBackground(BuildContext context) async {
    Provider.of<ContentsProvider>(context, listen: false).setBackground();
  }
}
