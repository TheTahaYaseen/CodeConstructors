import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ui/interface/constants.dart';
import 'package:ui/interface/devices/devices/devices_viewmodel.dart';
import 'package:ui/models/device_model.dart';
import 'package:ui/services/device_services.dart';

class DevicesView extends StatelessWidget {
  const DevicesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DevicesViewModel>.reactive(
      viewModelBuilder: () => DevicesViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchDevices(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          // Show loading indicator
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (viewModel.devices == null || viewModel.devices!.isEmpty) {
          // Handle no devices or error
          return Scaffold(
              body: Center(child: Text("No devices found or error occurred")));
        }

        // Build your UI with the list of devices
        return Scaffold(
          body: ListView.builder(
            itemCount: viewModel.devices!.length,
            itemBuilder: (context, index) {
              final device = viewModel.devices![index];
              return ListTile(
                title: Text(device.manufacturingId ?? "Unknown ID"),
              );
            },
          ),
        );
      },
    );
  }
}
