import 'package:scarlet_erm/screens/splash_screen.dart';
import 'package:scarlet_erm/theme/theme_manager.dart';
import 'package:scarlet_erm/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  await GetStorage.init();
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  GetStorage.init().then((value) {
  // Check if it's the first time app installation
  bool isFirstTime = GetStorage().read('isFirstTime') ?? true;

  // If it's the first time, clear stored values
  if (isFirstTime) {
  GetStorage().remove('email');
  GetStorage().remove('password');

  // Set the flag to indicate app has been installed before
  GetStorage().write('isFirstTime', false);
  }
  });

  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Scarlet ERM',
    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: ThemeManager().theme,
      home: const SplashScreen(),
    );
  }
}