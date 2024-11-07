import 'package:scarlet_erm/components/roundbutton.dart';
import 'package:scarlet_erm/screens/dashboard_modules/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassVisible = false;
  bool isLoading = false;

  final appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    if (appController.isUserLoggedIn) {

      return DashboardScreen();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 1,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.green]),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50.0))),
              ),
              const Center(
                child: Image(image: AssetImage('assets/images/KMFC.png'), height: 200,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 260, left: 25, right: 25),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Form(
                      key: appController.formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Login Account',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          const SizedBox(height: 35),
                          TextFormField(
                            controller: appController.emailContoller,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              hintText: 'Email or Username',
                              hintStyle: TextStyle(color: Colors.black87),
                              suffixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.blueAccent,
                              ),
                            ),
                            validator: (text) {
                              if (text.toString().isEmpty) {
                                return "Email is required";
                              }
                            },
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !isPassVisible,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.black87),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPassVisible = !isPassVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPassVisible
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.visibility_off,
                                      color: Colors.blueAccent,
                                    ))),
                            controller: appController.passContoller,
                            validator: (text) {
                              if (text.toString().isEmpty) {
                                return "Password is required";
                              }
                            },
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 45),
                      GetBuilder<AppController>(builder: (_) {
                        return RoundButton(
                          loading: appController.loading.value,
                          width: MediaQuery.of(context).size.width * 0.85,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onTap: () => appController.login(),
                          title: 'LOG IN',
                        );
                      }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}