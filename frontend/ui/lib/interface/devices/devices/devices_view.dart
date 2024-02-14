import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/interface/constants.dart';
import 'package:ui/services/device_services.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({Key? key}) : super(key: key);

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double borderSize = 1.5;
    double outerHorizontalPadding = screenSize.width * 0.07;
    double outerVerticalPadding = screenSize.height * 0.01;
    double innerHorizontalPadding = screenSize.width * 0.0125;
    double innerVerticalPadding = screenSize.height * 0.0125;
    double horizontalTextPadding = screenSize.width * 0.0025;
    double verticalTextPadding = screenSize.height * 0.00325;
    String message = "";
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: DeviceServices().devices(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: outerHorizontalPadding / 2,
                            right: outerHorizontalPadding / 2,
                            top: 25,
                            bottom: 10),
                        child: Text(
                          'Your Devices',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: AppConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                    const SizedBox(height: 3),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final device = snapshot.data![index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: outerHorizontalPadding,
                                  vertical: outerVerticalPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppConstants.primaryColor,
                                        width: borderSize),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10,
                                      right: 25,
                                      top: innerVerticalPadding,
                                      bottom: innerVerticalPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "#${device.manufacturingId!}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: AppConstants.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 3),
                                      (device.associatedUser == null)
                                          ? Text(
                                              "*Not Associated",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        AppConstants.errorColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            )
                                          : Column(children: [
                                              Wrap(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7, right: 7),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.pushNamed(
                                                          context,
                                                          (device.associatedWifiCredentials !=
                                                                  null)
                                                              ? '/updateWifiCredentials'
                                                              : '/getWifiCredentials',
                                                          arguments: (device
                                                                      .associatedWifiCredentials !=
                                                                  null)
                                                              ? device
                                                                  .associatedWifiCredentials
                                                              : device
                                                                  .manufacturingId,
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppConstants
                                                                .primaryColor,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 10),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical:
                                                                verticalTextPadding,
                                                            horizontal:
                                                                horizontalTextPadding),
                                                        child: Text(
                                                          (device.associatedWifiCredentials !=
                                                                  null)
                                                              ? 'Update Wifi'
                                                              : 'Associate Wifi',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7, right: 7),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        http.Response response =
                                                            await DeviceServices()
                                                                .toggleMode(
                                                                    device);
                                                        var responseBody =
                                                            jsonDecode(
                                                                response.body);
                                                        setState(() {
                                                          message =
                                                              responseBody[
                                                                  "message"];
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppConstants
                                                                .primaryColor,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 10),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical:
                                                                verticalTextPadding,
                                                            horizontal:
                                                                horizontalTextPadding),
                                                        child: Text(
                                                          device.isAuto != null
                                                              ? device.isAuto!
                                                                  ? "Auto"
                                                                  : "Manual"
                                                              : "Unknown",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 7, top: 7),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        http.Response response =
                                                            await DeviceServices()
                                                                .toggleState(
                                                                    device);
                                                        var responseBody =
                                                            jsonDecode(
                                                                response.body);
                                                        setState(() {
                                                          message =
                                                              responseBody[
                                                                  "message"];
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppConstants
                                                                .primaryColor,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 10),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical:
                                                                verticalTextPadding,
                                                            horizontal:
                                                                horizontalTextPadding),
                                                        child: Text(
                                                          device.state != null
                                                              ? device.state!
                                                                  ? "On"
                                                                  : "Off"
                                                              : "Unknown",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        http.Response response =
                                                            await DeviceServices()
                                                                .removeDevice(
                                                                    device);
                                                        var responseBody =
                                                            jsonDecode(
                                                                response.body);
                                                        setState(() {
                                                          message =
                                                              responseBody[
                                                                  "message"];
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppConstants
                                                                .primaryColor,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 10),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical:
                                                                verticalTextPadding,
                                                            horizontal:
                                                                horizontalTextPadding),
                                                        child: Text(
                                                          "Remove",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
