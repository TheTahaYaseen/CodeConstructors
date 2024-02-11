import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ui/interface/constants.dart';
import 'package:ui/interface/devices/validate/validate_viewmodel.dart';
import 'package:ui/models/device_model.dart';
import 'package:ui/services/device_services.dart';
import 'package:http/http.dart' as http;

class ValidateView extends StatefulWidget {
  const ValidateView({super.key});

  @override
  State<ValidateView> createState() => _ValidateViewState();
}

class _ValidateViewState extends State<ValidateView> {
  String error = "";
  String manufacturingId = "";
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
    TextEditingController manufacturingIdController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    manufacturingIdController.text = manufacturingId;
    passwordController.text = password;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ValidateViewModel(),
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
                      'Validate Your Device',
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
                      controller: manufacturingIdController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: Text(
                            'Manufacturing Id',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          )),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String message;
                            if (manufacturingIdController.text.isEmpty) {
                              message = "Manufacturing Id Must Be Provided!";
                            } else {
                              String? manufacturingId =
                                  manufacturingIdController.text;
                              DeviceModel device =
                                  DeviceModel(manufacturingId: manufacturingId);
                              http.Response response =
                                  await DeviceServices().validateDevice(device);
                              var responseBody = jsonDecode(response.body);
                              message = responseBody["message"];
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
                              'Validate',
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
