import 'package:flutter/material.dart';
import 'package:photoshop/constants.dart';
import 'package:photoshop/services/service.dart';
import 'package:photoshop/state%20mangement/active.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class Tap extends StatefulWidget {
  bool isActive;
  final IconData icondata;
  final BoxConstraints constrait;
  final String hint;
  final int id;
  ScreenshotController? controller;
  Tap(
      {Key? key,
      this.controller,
      required this.constrait,
      required this.icondata,
      required this.hint,
      required this.id,
      this.isActive = false})
      : super(key: key);

  @override
  State<Tap> createState() => _TapState();
}

class _TapState extends State<Tap> {
  @override
  Widget build(BuildContext context) {
    final Activeness activenessProvider = Provider.of<Activeness>(context);
    return InkWell(
      onTap: () async {
        final Service service = Service();
        activenessProvider.selection(widget.id);
        if (widget.isActive) return;
        switch (widget.id) {
          case 1:
            await service.saveToGallery(widget.controller!, context);
            break;
          case 2:
            service.addText(context);
            break;
          case 3:
            activenessProvider.toggleGrid();
            break;

          case 4:
            await service.addFilledCircle(context, Size(20, 8));
            break;
          case 5:
            await service.addFilledRectange(40, 30, context);
            break;
          case 8:
            await service.setBackground(context);
            break;
          case 9:
            await service.insertImageContent(context);
            break;
          case 10:
            await service.addunFilledCircle(context, Size(20, 8));
            break;
          case 11:
            await service.addunFilledRectange(40, 30, context);
            break;
          case 12:
            await service.addoval(40, 30, context);
            break;
          default:
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        width: widget.constrait.maxHeight * 0.069,
        height: widget.constrait.maxHeight * 0.066,
        child: Column(children: [
          Icon(
            widget.icondata,
            size: widget.constrait.maxHeight * 0.026,
          ),
          Text(widget.hint,
              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 8))
        ]),
        decoration: BoxDecoration(
          color: widget.isActive ? Theme.of(context).colorScheme.primary : null,
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
