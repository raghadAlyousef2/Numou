import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> checkPermissions() async {
    // Check and request microphone permission
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) return false;

    // Internet permission is always granted on Android/iOS,
    // but we can check connectivity separately if required.

    return true;
  }
}
