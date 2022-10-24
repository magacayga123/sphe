import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photoshop/constants.dart';
import 'package:photoshop/model/photoshop.dart';
import 'package:photoshop/state%20mangement/content.dart';
import 'package:photoshop/widgets/representation.dart';
import 'package:provider/provider.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext context) {
    final providerofphotoshops = Provider.of<ContentsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edited photos"),
      ),
      body: FutureBuilder(
          future: providerofphotoshops.getAll(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Photoshop>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Photoshop> photoshops = snapshot.hasData ? snapshot.data! : [];
            // log(photoshops.length.toString());
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...photoshops.map((e) => Represent(photoshop: e)),
                ],
              ),
            );
          }),
    );
  }
}
