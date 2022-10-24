import 'package:flutter/material.dart';
import 'package:photoshop/state%20mangement/content.dart';

class ColorWidget extends StatefulWidget {
  final Color color;
  final ContentsProvider provider;
  final BoxConstraints constrait;
  const ColorWidget(
      {Key? key,
      required this.color,
      required this.provider,
      required this.constrait})
      : super(key: key);

  @override
  State<ColorWidget> createState() => _ColorWidgetState();
}

class _ColorWidgetState extends State<ColorWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.provider.changeColor(context, widget.color);
      },
      child: Container(
          width: 60,
          height: widget.constrait.maxHeight * 0.050,
          decoration: BoxDecoration(
              color: widget.color,
              border: Border.all(width: 1, color: Colors.black))),
    );
  }
}
