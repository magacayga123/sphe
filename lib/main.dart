import 'package:flutter/material.dart';
import 'package:photoshop/database/database.dart';
import 'package:photoshop/state%20mangement/active.dart';
import 'package:photoshop/state%20mangement/content.dart';
import 'package:photoshop/state%20mangement/themeprovider.dart';
import 'package:photoshop/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'
    as sharedpreferences;
import './screen/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.createdb();
  final sharedpreferences.SharedPreferences shared =
      await sharedpreferences.SharedPreferences.getInstance();
  runApp(SimplePhotoShop(
    shared: shared,
  ));
}

class SimplePhotoShop extends StatefulWidget {
  final sharedpreferences.SharedPreferences shared;
  const SimplePhotoShop({Key? key, required this.shared}) : super(key: key);

  @override
  State<SimplePhotoShop> createState() => _SimplePhotoShopState();
}

class _SimplePhotoShopState extends State<SimplePhotoShop> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Activeness()),
        ChangeNotifierProvider(create: (_) => ContentsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(builder: (context, data, w) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(
              shared: widget.shared,
            ),
            themeMode: data.isDarktheme(widget.shared)
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: data.isDarktheme(widget.shared) ? darkTheme : lightTheme);
      }),
    );
  }
}
