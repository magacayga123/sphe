import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:photoshop/model/content.dart';

class ContentWidget extends StatefulWidget {
  Content content;
  ContentWidget({Key? key, required this.content}) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    // log(widget.content.isActive.toString());
    return Positioned(
      top: widget.content.position.dy,
      left: widget.content.position.dx,
      child: Transform(
        transform: Matrix4.identity()
          ..rotateZ((widget.content.rotationz / 180) * math.pi),
        child: Container(
          child: selectorWidgetbuilder(widget.content),
          decoration: BoxDecoration(
              border: widget.content.isActive
                  ? Border.all(
                      color: Theme.of(context).colorScheme.tertiary, width: 3)
                  : null),
        ),
      ),
    );
  }
}

Widget selectorWidgetbuilder(Content content) {
  switch (content.type) {
    case "text":
      return Text(
        content.datainside,
        style: TextStyle(
            fontFamily: content.fontfamily,
            fontSize: content.size.width,
            color: content.color),
      );
    case "circle":
      return CustomPaint(
        child: Container(),
        painter: CustomPainterCircle(
            color: content.color,
            offset: Offset(0, 0),
            radius: content.size.width),
      );
    case "rectangle":
      return CustomPaint(
          child: Container(),
          painter: CustomPainterRectangle(
              color: content.color,
              width: content.size.width,
              height: content.size.height));
    case "rectangle_outlined":
      return CustomPaint(
          child: Container(),
          painter: CustomPainterunfilledRectangle(
              color: content.color,
              thickness: content.thickness,
              width: content.size.width,
              height: content.size.height));
    case "circle_outlined":
      return CustomPaint(
        child: Container(),
        painter: CustomPainterunfilledCircle(
            color: content.color,
            thickness: content.thickness,
            offset: Offset(0, 0),
            radius: content.size.width),
      );
    case "rectangle_rounded":
      return CustomPaint(
        child: Container(),
        painter: CustomPainterRoundedRectangle(
          color: content.color,
          width: content.size.width,
          height: content.size.height,
          thickness: content.thickness,
        ),
      );
    case "image":
      return Image.file(
        File(content.datainside),
        width: content.size.width,
        height: content.size.height,
        fit: BoxFit.fill,
      );
    default:
      return Container();
  }
}

class CustomPainterRectangle extends CustomPainter {
  final Color color;
  final double width;
  final double height;
  CustomPainterRectangle(
      {required this.color, required this.width, required this.height});
  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Rect.fromCenter(center: Offset(0, 0), width: width, height: height);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPainterunfilledRectangle extends CustomPainter {
  final Color color;
  final double width;
  final double thickness;
  final double height;
  CustomPainterunfilledRectangle(
      {required this.thickness,
      required this.color,
      required this.width,
      required this.height});
  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Rect.fromCenter(center: Offset(0, 0), width: width, height: height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..color = color;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPainterCircle extends CustomPainter {
  final Color color;
  final Offset offset;
  final double radius;
  CustomPainterCircle(
      {required this.color, required this.offset, required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    final c = offset;
    canvas.drawCircle(c, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPainterunfilledCircle extends CustomPainter {
  final Color color;
  final Offset offset;
  final double radius;
  final double thickness;
  CustomPainterunfilledCircle(
      {required this.color,
      required this.offset,
      required this.thickness,
      required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..color = color;
    final c = offset;
    canvas.drawCircle(c, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPainterRoundedRectangle extends CustomPainter {
  final double width;
  final double height;
  final double thickness;
  final Color color;
  CustomPainterRoundedRectangle(
      {required this.width,
      required this.height,
      required this.color,
      required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    final rect =
        Rect.fromCenter(center: Offset(0, 0), width: width, height: height);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
