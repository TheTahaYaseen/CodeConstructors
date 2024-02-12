import 'package:stacked/stacked.dart';
import 'package:ui/models/device_model.dart';
import 'package:ui/services/device_services.dart';

class DevicesViewModel extends BaseViewModel {
  List<DeviceModel>? devices;

  Future<void> fetchDevices() async {
    setBusy(true);
    try {
      devices = await DeviceServices().devices();
      notifyListeners();
    } catch (e) {
      print("Error fetching devices: $e");
    }
    setBusy(false);
  }
}
