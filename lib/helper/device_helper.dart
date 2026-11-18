import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class DeviceHelper {
  static Future<String> _getDeviceId() async {
    final deviceIdKey = AppConstants.deviceIdKey;

    final prefs = await SharedPreferences.getInstance();

    String? deviceId = prefs.getString(deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();

      await prefs.setString(deviceIdKey, deviceId);
    }

    return deviceId;
  }

  static Future<String> getDeviceName() async {
    final deviceId = await _getDeviceId();

    return '${AppConstants.deviceName}-$deviceId';
  }
}
