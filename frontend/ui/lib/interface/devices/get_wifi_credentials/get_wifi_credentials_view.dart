import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ui/interface/devices/get_wifi_credentials/get_wifi_credentials_viewmodel.dart';
import 'package:ui/interface/constants.dart';
import 'package:ui/models/wifi_credential_model.dart';
import 'package:http/http.dart' as http;
import 'package:ui/services/wifi_credential_services.dart';

class GetWifiCredentialsView extends StatefulWidget {
  const GetWifiCredentialsView({super.key});

  @override
  State<GetWifiCredentialsView> createState() => _GetWifiCredentialsViewState();
}

class _GetWifiCredentialsViewState extends State<GetWifiCredentialsView> {
  String error = "";
  String ssid = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final String manufacturingId =
        ModalRoute.of(context)!.settings.arguments as String;
    Size screenSize = MediaQuery.of(context).size;
    double borderSize = (screenSize.width + screenSize.height) * 0.0015;
    double outerHorizontalPadding = screenSize.width * 0.1;
    double outerVerticalPadding = screenSize.height * 0.1;
    double innerHorizontalPadding = screenSize.width * 0.05;
    double innerVerticalPadding = screenSize.height * 0.05;
    double horizontalTextPadding = screenSize.width * 0.02;
    double verticalTextPadding = screenSize.height * 0.015;
    TextEditingController ssidController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    ssidController.text = ssid;
    passwordController.text = password;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => GetWifiCredentialsViewModel(),
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
                      'Associate Wifi Credentials',
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
                      controller: ssidController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: Text(
                            'Ssid',
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
                            WifiCredentialModel wifiCredential =
                                WifiCredentialModel(
                              ssid: ssidController.text,
                              password: passwordController.text,
                            );
                            http.Response response =
                                await WifiCredentialServices()
                                    .getWifiCredentials(
                                        wifiCredential, manufacturingId);
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
                                vertical: verticalTextPadding,
                                horizontal: horizontalTextPadding),
                            child: Text(
                              'Associate',
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
