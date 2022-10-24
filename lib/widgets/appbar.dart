import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photoshop/model/tap_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as colorpicker;
import 'package:photoshop/screen/projects.dart';
import 'package:photoshop/state%20mangement/active.dart';
import 'package:photoshop/state%20mangement/content.dart';
import 'package:photoshop/widgets/color.dart';
import 'package:photoshop/widgets/tap.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FunctioningAppBar extends StatefulWidget {
  final ScreenshotController controller;
  final BoxConstraints constrait;
  const FunctioningAppBar(
      {Key? key, required this.controller, required this.constrait})
      : super(key: key);

  @override
  State<FunctioningAppBar> createState() => _FunctioningAppBarState();
}

class _FunctioningAppBarState extends State<FunctioningAppBar> {
  final widthcontroller = TextEditingController();
  final rcontroller = TextEditingController();
  final heightcontroller = TextEditingController();
  final thicknessController = TextEditingController();
  final rotationcontroller = TextEditingController();
  List<Color> colors = [
    Colors.deepOrange,
  ];

  @override
  void dispose() {
    colors.clear();
    rotationcontroller.dispose();
    widthcontroller.dispose();
    thicknessController.dispose();
    heightcontroller.dispose();
    rcontroller.dispose();
    colors.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.secondary))),
        height: widget.constrait.maxHeight * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Activeness>(
            builder: (c, d, w) {
              List<TapModel> taps = d.taps;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...taps
                                    .map((TapModel tapmodel) => Tap(
                                        constrait: widget.constrait,
                                        controller: widget.controller,
                                        id: tapmodel.id,
                                        isActive: tapmodel.isActive,
                                        icondata: tapmodel.icondata,
                                        hint: tapmodel.hint))
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: widget.constrait.maxHeight * 0.01),
                      belowTabs(taps)
                    ],
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget belowTabs(List<TapModel> taps) {
    if (taps[6].isActive) {
      return Consumer<ContentsProvider>(builder: (contexte, data, w) {
        setupwidthAndHeight(data);
        return selectSuitableResizeWidgets(data);
      });
    } else if (taps[7].isActive) {
      return Consumer<ContentsProvider>(builder: (c, d, w) {
        return SizedBox(
          height: widget.constrait.maxHeight * 0.06,
          width: MediaQuery.of(context).size.width * 0.89,
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...colors.map((e) => ColorWidget(
                      color: e, provider: d, constrait: widget.constrait)),
                  IconButton(
                      onPressed: () async {
                        Color pickedColor = Theme.of(context).primaryColor;
                        Color color = await pickColor(pickedColor);
                        d.changeColor(context, color);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.redAccent,
                      ))
                ],
              ),
            ),
          ),
        );
      });
    } else if (taps[13].isActive) {
      return Consumer<ContentsProvider>(builder: (c, d, w) {
        return sliderBuilder(d);
      });
    } else if (taps[0].isActive) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                final route = MaterialPageRoute(
                  builder: (context) => Projects(),
                );
                Navigator.of(context).push(route);
              },
              child: Text(
                "open file",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
          TextButton(
              onPressed: () {
                Provider.of<ContentsProvider>(context, listen: false).newfile();
              },
              child: Text(
                "new file",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget selectSuitableResizeWidgets(ContentsProvider data) {
    if (data.getActive() == null) {
      return SizedBox.shrink();
    } else {
      switch (data.getActive()!.type) {
        case "circle":
          return CustomInputField("radius", data, rcontroller, ValueKey(4));
        case "text":
          return CustomInputField("size", data, rcontroller, ValueKey(5));
        case "rectangle_outlined":
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInputField("width", data, widthcontroller, ValueKey(1)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "height", data, heightcontroller, ValueKey(2)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "thickness", data, thicknessController, ValueKey(3)),
                ],
              ),
            ),
          );
        case "circle_outlined":
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomInputField("radius", data, rcontroller, ValueKey(7)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "thickness", data, thicknessController, ValueKey(3))
                ],
              ),
            ),
          );
        case "rectangle":
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInputField("width", data, widthcontroller, ValueKey(1)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "height", data, heightcontroller, ValueKey(2)),
                ],
              ),
            ),
          );
        case "rectangle_rounded":
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomInputField("width", data, widthcontroller, ValueKey(1)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "height", data, heightcontroller, ValueKey(2)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "thickness", data, thicknessController, ValueKey(3))
                ],
              ),
            ),
          );
        case "image":
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInputField("width", data, widthcontroller, ValueKey(1)),
                  SizedBox(
                    width: 30,
                  ),
                  CustomInputField(
                      "height", data, heightcontroller, ValueKey(2)),
                ],
              ),
            ),
          );
        default:
          return SizedBox();
      }
    }
  }

  Widget sliderBuilder(ContentsProvider data) {
    double value = data.getActive() == null ? 0 : data.getActive()!.rotationz;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Slider(
          activeColor: Theme.of(context).primaryColor,
          min: 0,
          divisions: 36,
          max: 360,
          value: value,
          onChanged: (double valuenew) {
            data.rotate(valuenew, context);
          }),
    );
  }

  void setupwidthAndHeight(ContentsProvider data) {
    widthcontroller.text =
        data.getActive() == null ? "" : data.getActive()!.size.width.toString();
    heightcontroller.text = data.getActive() == null
        ? ""
        : data.getActive()!.size.height.toString();
    thicknessController.text =
        data.getActive() == null ? "" : data.getActive()!.thickness.toString();
    rcontroller.text =
        data.getActive() == null ? "" : data.getActive()!.size.width.toString();
    rotationcontroller.text =
        data.getActive() == null ? "" : data.getActive()!.rotationz.toString();
  }

  CustomInputField(String s, ContentsProvider data,
      TextEditingController controller, Key k) {
    return SizedBox(
      key: k,
      width: widget.constrait.maxWidth * 0.27777,
      height: widget.constrait.maxHeight * 0.0664,
      child: TextField(
        controller: controller,
        onSubmitted: (String? v) {
          if (v == null) return;
          double valuex = double.parse(v);
          switch (s) {
            case "width":
              data.resizeWidth(valuex, context);
              break;
            case "height":
              data.resizeHeight(valuex, context);
              break;
            case "thickness":
              data.rethicknessize(valuex, context);
              break;
            case "radius":
              data.resize(valuex, context);
              break;
            case "size":
              data.resize(valuex, context);
              break;
            case "rotation":
              data.rotate(valuex, context);
              break;

            default:
          }
        },
        cursorColor: Theme.of(context).colorScheme.secondary,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.secondary)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.black)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.black)),
            hintText: s),
      ),
    );
  }

  Future<Color> pickColor(Color pickedColor) async {
    await showDialog<Color>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("pick one color"),
            content: SingleChildScrollView(
              child: SizedBox(
                child: colorpicker.ColorPicker(
                  colorPickerWidth: widget.constrait.maxHeight * 0.5,
                  pickerColor: pickedColor,
                  onColorChanged: (newc) {
                    pickedColor = newc;
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (colors.length < 7 && !colors.contains(pickedColor)) {
                    setState(() {
                      colors.add(pickedColor);
                    });
                  } else {
                    setState(() {
                      colors.remove(colors.last);
                      colors.add(pickedColor);
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Text("ok"),
              ),
            ],
          );
        }).then((value) => pickedColor);
    return pickedColor;
  }
}
