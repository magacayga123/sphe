import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart' as sharedprefences;

class ThemeProvider with ChangeNotifier {
  bool _isDark = true;

  isDarktheme(sharedprefences.SharedPreferences sharedp) {
    final jsondata = sharedp.getString("isDark");
    if (jsondata == null) return true;
    bool isDark = json.decode(jsondata);
    return isDark;
  }

  toggletheme(sharedprefences.SharedPreferences sharedp) {
    _isDark = !_isDark;
    sharedp.setString("isDark", json.encode(_isDark));
    notifyListeners();
  }
}
