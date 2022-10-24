import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photoshop/constants.dart';
import 'package:photoshop/model/photoshop.dart';
import 'package:photoshop/state%20mangement/content.dart';
import 'package:photoshop/uitls.dart';
import 'package:photoshop/widgets/content_widget.dart';
import 'package:provider/provider.dart';

class Represent extends StatefulWidget {
  final Photoshop photoshop;
  const Represent({super.key, required this.photoshop});

  @override
  State<Represent> createState() => _RepresentState();
}

class _RepresentState extends State<Represent> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentsProvider>(context);
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        Navigator.of(context).pop();
        provider.openphotoshop(widget.photoshop);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    image: widget.photoshop.background.isEmpty
                        ? null
                        : DecorationImage(
                            image: FileImage(File(widget.photoshop.background)),
                            fit: BoxFit.fill),
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: double.infinity,
                  height: 300,
                  alignment: Alignment.center,
                  child: Stack(children: [
                    ...widget.photoshop.contents.map(
                      (e) => ContentWidget(content: e),
                    ),
                  ]),
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<ContentsProvider>(context, listen: false)
                      .delete(widget.photoshop.id, context);
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
              Text(formated(widget.photoshop.lasEdit))
            ],
          ),
        ),
      ),
    );
  }
}
