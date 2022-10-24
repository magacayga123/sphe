import 'package:flutter/material.dart';
import 'package:photoshop/state%20mangement/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeWidget extends StatefulWidget {
  bool isDark;
  final SharedPreferences shared;
  ChangeThemeWidget(this.isDark, this.shared, {super.key});

  @override
  State<ChangeThemeWidget> createState() => _ChangeThemeWidgetState();
}

class _ChangeThemeWidgetState extends State<ChangeThemeWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, d, w) {
      return Padding(
          padding: const EdgeInsets.all(8),
          child: CheckboxListTile(
              value: d.isDarktheme(widget.shared),
              title: Text("dark mode"),
              onChanged: (bool? newv) {
                d.toggletheme(widget.shared);
              }));
    });
  }
}
