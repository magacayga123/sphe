import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photoshop/database/database.dart';
import 'package:photoshop/model/content.dart';
import 'package:photoshop/services/service.dart';
import 'package:photoshop/state%20mangement/active.dart';
import 'package:photoshop/state%20mangement/content.dart';
import 'package:photoshop/uitls.dart';
import 'package:photoshop/widgets/appbar.dart';
import 'package:photoshop/widgets/changeThemeWidget.dart';
import 'package:photoshop/widgets/content_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart' as screenshot;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences shared;
  const HomePage({Key? key, required this.shared}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  final controller = screenshot.ScreenshotController();
  final service = Service();
  bool lock = false;
  bool nofileka = false;

  @override
  void dispose() {
    Database.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providergrid = Provider.of<Activeness>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: (context, constrait) {
        log(constrait.maxHeight.toString());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: constrait.maxHeight * 0.2,
              child: FunctioningAppBar(
                constrait: constrait,
                controller: controller,
              ),
            ),
            SizedBox(height: constrait.maxHeight * 0.025),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("to remove background image double tap on workspace",
                  style: Theme.of(context).textTheme.caption!),
            ),
            if (providergrid.hasGrid)
              GridPaper(
                divisions: 2,
                color: Colors.grey,
                subdivisions: 1,
                interval: 30,
                child: screenshot.Screenshot(
                  controller: controller,
                  child: Consumer<ContentsProvider>(builder: (c, data, w) {
                    List<Content> contents = data.photoshop.contents;
                    nofilex(data.photoshop.background);
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4,
                      panEnabled: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: constrait.maxHeight * 0.500,
                        child: GestureDetector(
                          onDoubleTap: () async {
                            bool allow = await allowed(context,
                                "are you sure to remove background image");
                            if (allow) {
                              data.removebackground();
                            }
                          },
                          behavior: HitTestBehavior.deferToChild,
                          // onPanStart: (details) => data.dragStart(details),
                          onPanUpdate: (details) => data
                              .changePostionOfActiveContent(details, context),
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              image:
                                  data.photoshop.background.isEmpty || !nofileka
                                      ? null
                                      : DecorationImage(
                                          image: FileImage(
                                              File(data.photoshop.background)),
                                          fit: BoxFit.fill),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            width: double.infinity,
                            height: constrait.maxHeight * 0.4919,
                            alignment: Alignment.center,
                            child: Stack(children: [
                              ...contents.map(
                                (e) => ContentWidget(content: e),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            if (!providergrid.hasGrid)
              screenshot.Screenshot(
                controller: controller,
                child: Consumer<ContentsProvider>(builder: (c, data, w) {
                  List<Content> contents = data.photoshop.contents;
                  nofilex(data.photoshop.background);
                  return SizedBox(
                    width: double.infinity,
                    height: constrait.maxHeight * 0.500,
                    child: GestureDetector(
                      onDoubleTap: () async {
                        bool allow = await allowed(
                            context, "are you sure to remove background image");
                        if (allow) {
                          data.removebackground();
                        }
                      },
                      behavior: HitTestBehavior.deferToChild,
                      // onPanStart: (details) => data.dragStart(details),
                      onPanUpdate: (details) =>
                          data.changePostionOfActiveContent(details, context),
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: data.photoshop.background.isEmpty || !nofileka
                              ? null
                              : DecorationImage(
                                  image: FileImage(
                                      File(data.photoshop.background)),
                                  fit: BoxFit.fill),
                          color: Colors.white,
                          border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        width: double.infinity,
                        height: constrait.maxHeight * 0.4919,
                        alignment: Alignment.center,
                        child: Stack(children: [
                          ...contents.map(
                            (e) => ContentWidget(content: e),
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ContentsProvider>(builder: (c, d, w) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(lock ? Icons.lock : Icons.lock_open),
                      Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: lock,
                          onChanged: (bool? value) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            lock = value!;
                            d.lock(lock);
                          })
                    ]);
              }),
            ),
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Center(
              child: SizedBox(
                height: constrait.maxHeight * 0.09,
                child: TextButton(
                  child: Text(
                    '''tap here to select item that you want to edit''',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  onPressed: () {
                    bool isDark = false;
                    showModalBottomSheet(
                        isDismissible: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        context: context,
                        enableDrag: true,
                        builder: (_) =>
                            botomsheetbuilder(_, isDark, widget.shared));
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget botomsheetbuilder(
      BuildContext context, bool isDark, SharedPreferences shared) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(),
              icon: Icon(Icons.close),
              label: Text("close")),
          SizedBox(
            height: 20,
          ),
          ChangeThemeWidget(isDark, shared),
          Consumer<ContentsProvider>(builder: (context, data, w) {
            List<Content> contents = data.photoshop.contents;
            return Scrollbar(
              child: Column(
                children: [
                  ...contents.map((e) {
                    return InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        if (lock) {
                          double heightneeded =
                              MediaQuery.of(context).size.height - 120;
                          final snackbar = SnackBar(
                            elevation: 20,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(bottom: heightneeded),
                            content: Text("un lock first"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                        if (!lock) {
                          data.select(e.id);
                        }
                      },
                      child: ListTile(
                        selected: e.isActive,
                        selectedColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          selectIcon(e),
                          color: e.color,
                        ),
                        title: e.type == "image"
                            ? Text(e.type + "${e.datainside.split("/").last}")
                            : Text(e.datainside),
                        subtitle: e.isActive
                            ? Text(
                                "active",
                              )
                            : const Text("tap to select"),
                        trailing: TextButton(
                          child: Text("delete"),
                          onPressed: () {
                            data.removecontent(e.id);
                          },
                        ),
                      ),
                    );
                  })
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData? selectIcon(Content e) {
    switch (e.type) {
      case "text":
        return Icons.text_fields;
      case "circle":
        return Icons.circle;
      case "rectangle":
        return Icons.rectangle;
      case "image":
        return Icons.photo;
      case "rectangle_outlined":
        return Icons.rectangle_outlined;
      case "circle_outlined":
        return Icons.circle_outlined;
      default:
        return Icons.abc;
    }
  }

  void nofilex(String background) async {
    nofileka = await nofile(background);
  }

  Future<bool> nofile(String background) async {
    if (background.isEmpty) return true;
    File f = await File(background).create();
    return await f.exists();
  }
}
