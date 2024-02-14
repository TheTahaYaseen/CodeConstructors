import os


views = ["add_manufactured_device", "validate", "get_wifi_credentials", "update_wifi_credentials"]
views2 = ["AddManufacturedDevice", "Validate", "GetWifiCredentials", "UpdateWifiCredentials"]

# views = ["login", "register"]
# views2 = ["Login", "Register"]

constant = """import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ui/interface/devices/login/login_viewmodel.dart';
import 'package:ui/interface/constants.dart';
import 'package:ui/models/user_model.dart';
import 'package:ui/services/user_services.dart';
import 'package:http/http.dart' as http;

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
    double ApiConstants.borderSize = (screenSize.width + screenSize.height) * 0.0015;
    double ApiConstants.outerHorizontalPadding = screenSize.width * 0.1;
    double ApiConstants.ApiConstants.outerVerticalPadding = screenSize.height * 0.1;
    double ApiConstants.innerHorizontalPadding = screenSize.width * 0.05;
    double ApiConstants.innerVerticalPadding = screenSize.height * 0.05;
    double ApiConstants.horizontalTextPadding = screenSize.width * 0.02;
    double ApiConstants.verticalTextPadding = screenSize.height * 0.015;
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
                horizontal: ApiConstants.outerHorizontalPadding,
                vertical: ApiConstants.ApiConstants.outerVerticalPadding),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppConstants.primaryColor, width: ApiConstants.borderSize),
                  borderRadius: BorderRadius.circular(screenSize.width / 48)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ApiConstants.innerHorizontalPadding,
                    vertical: ApiConstants.innerVerticalPadding),
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
                            String message = responseBody["message"];
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
                                vertical: ApiConstants.verticalTextPadding,
                                horizontal: ApiConstants.horizontalTextPadding),
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
"""

for i in range(len(views)):
    view = views[i]
    view_model = views2[i]
    os.chdir(view)
    with open(f"./{view}_viewmodel.dart", "w") as file:
        file.write(f"""import 'package:stacked/stacked.dart';

class {view_model}ViewModel extends BaseViewModel {{}}
""")
    with open(f"./{view}_view.dart", "w") as file:
        file.write(constant.replace("login", view).replace("Login", view_model))
    os.chdir("..")
