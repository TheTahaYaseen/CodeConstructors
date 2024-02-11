import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ui/interface/base/login/login_viewmodel.dart';
import 'package:ui/interface/constants.dart';
import 'package:ui/models/user_model.dart';
import 'package:ui/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:ui/storage.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String error = "";
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double borderSize = (screenSize.width + screenSize.height) * 0.0015;
    double outerHorizontalPadding = screenSize.width * 0.1;
    double outerVerticalPadding = screenSize.height * 0.1;
    double innerHorizontalPadding = screenSize.width * 0.05;
    double innerVerticalPadding = screenSize.height * 0.05;
    double horizontalTextPadding = screenSize.width * 0.02;
    double verticalTextPadding = screenSize.height * 0.015;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    usernameController.text = username;
    passwordController.text = password;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: outerHorizontalPadding,
                vertical: outerVerticalPadding),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppConstants.primaryColor, width: borderSize),
                  borderRadius: BorderRadius.circular(screenSize.width / 48)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: innerHorizontalPadding,
                    vertical: innerVerticalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      error,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppConstants.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: Text(
                            'Username',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          )),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: Text(
                            'Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          )),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            UserModel user = UserModel(
                                username: usernameController.text,
                                password: passwordController.text);
                            http.Response response =
                                await UserServices().login(user);
                            var responseBody = jsonDecode(response.body);
                            print(response.body);
                            String message = responseBody["message"];
                            if (message == "User logged in!") {
                              var token = responseBody['access'];
                              await SecureStorage().storeToken(token);
                            }
                            setState(() {
                              error = message;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalTextPadding,
                                horizontal: horizontalTextPadding),
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
