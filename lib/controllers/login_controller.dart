import 'package:scarlet_erm/screens/dashboard_modules/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/api_service.dart';

class AppController extends GetxController {
  final emailContoller = TextEditingController();
  final passContoller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var loading = false.obs;
  GetStorage _box = GetStorage();
  bool isUserLoggedIn = false;

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
    isUserLoggedIn =
        _box.read('email') != null && _box.read('password') != null;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
     // CircularProgressIndicator();
      update();
      var email = emailContoller.text.trim();
      var password = passContoller.text.trim();
      var data =
      await ApiService.get("Account/Getuser?USID=$email&pwd=$password");
      if (data != null) {
        loading.value = false;
        update();
        var usid = data['USID'];
        emailContoller.clear();
        passContoller.clear();

        debugPrint(data.toString());
        Fluttertoast.showToast(
          msg: 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        // Store the email and password values in GetStorage
        _box.write('email', email);
        _box.write('password', password);
        _box.write('usid', usid);
        debugPrint(_box.read('email'));
        debugPrint(_box.read('password'));
        debugPrint(_box.read('usid'));

        Get.offAll(() => DashboardScreen());
      } else {
        Fluttertoast.showToast(
          msg: 'Enter Valid Email and Password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        debugPrint(data.toString());
        loading.value = false;
        update();
      }
    }
  }
}