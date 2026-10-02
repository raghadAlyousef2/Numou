
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../../screens/home_screen_pre.dart';
import '../../authentication/controllers/auth_controller_pre.dart';

enum ScheduleRepeatInterval { daily, weekly, monthly, once }

class LocalNotificationController extends GetxController {
  static LocalNotificationController instance =
      Get.find<LocalNotificationController>();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isAndroidNotificationPermissionGranted = false;
  bool isAndroidExactAlarmPermissionGranted = false;
  bool isAndroidFullScreenIntentPermissionGranted = false;
  RxString onClickNotificationData = ''.obs;

  @override
  void onReady() {
    super.onReady();
    _init(); // Initialize your other necessary code here

    // Listen to changes in the notification data
    ever(onClickNotificationData, (response) async {
      // print(response);
      var currentUser = AuthControllerPre.instance.cuser;

      if (currentUser != null) {
        // User is logged in
        if (currentUser.emailVerified) {
          // Email is verified, navigate to HomeScreen

          // Check if HomeScreen is already in the navigation stack
          bool isHomeScreenInStack = false;
          Get.until((route) {
            if (route.settings.name == HomeScreenPrev().toString()) {
              isHomeScreenInStack = true;
            }
            return true;
          });

          // If HomeScreen is in the stack, pop all screens above it
          if (isHomeScreenInStack) {
            Get.until(
                (route) => route.settings.name == HomeScreenPrev().toString());
          } else {
            // If HomeScreen is not in the stack, navigate to it
            Get.to(() => HomeScreenPrev());
          }
        } else {
          // Email is not verified, you can choose to show a message or do nothing
          Get.snackbar(
            'Email Not Verified',
            'Please verify your email to access the home page.',
            backgroundColor: Get.theme.colorScheme.surface,
            colorText: Get.theme.colorScheme.error,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        // User is not logged in, show the login screen or do nothing
        // Get.to(() => WelcomePage());
      }
    });
  }

  Future _init() async {
    // initialise the plugin.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
        //    onDidReceiveLocalNotification: (id, title, body, payload) {}
        );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTab,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTab,



    );
    // await _requestNotificationPermissions();
  }

  @pragma('vm:entry-point')
  static void _onNotificationTab(NotificationResponse response) {
    LocalNotificationController.instance.onClickNotificationData.value =
        response.payload ?? '';

  }

  Future _requestNotificationPermissions() async {
    final androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      bool? granted =
          await androidImplementation.requestNotificationsPermission();
      if (granted != null) {
        //print(granted);
        isAndroidNotificationPermissionGranted = true;
        // print('Notification permission granted in android .');
      } else {
        isAndroidNotificationPermissionGranted = false;
        // print('Notification permission denied.');
      }
      bool? granted1 =
          await androidImplementation.requestExactAlarmsPermission();

      if (granted1 != null) {
        //print(granted);
        isAndroidExactAlarmPermissionGranted = true;
        // print('AndroidExactAlarmPermissionGranted granted in android .');
      } else {
        isAndroidExactAlarmPermissionGranted = false;
        // print('AndroidExactAlarmPermissionGranted denied.');
      }

      bool? granted2 =
          await androidImplementation.requestFullScreenIntentPermission();

      if (granted2 != null) {
        //print(granted);
        isAndroidFullScreenIntentPermissionGranted = true;
        // print('AndroidFullScreenIntentPermissionGranted granted in android .');
      } else {
        isAndroidFullScreenIntentPermissionGranted = false;
        // print('AndroidFullScreenIntentPermissionGranted denied.');
      }
    }
  }

  Future showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 1', 'current channel ',
            channelDescription:
                'this channel use for show instant notifications',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  Future setPeriodicLocalNotification(
      {required int id,
      required RepeatInterval repeatInterval,
      required String title,
      required String body,
      required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 8', 'repeat channel',
            channelDescription: ' this channel use for periodic notifications',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        id, title, body, repeatInterval, notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<List<ActiveNotification>> getActiveNotifications() async {
    return await _flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  Future cancelLocalNotification({required int id, String? tag}) async {
    await _flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }

  Future cancelAllLocalNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> setScheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int hour, // Input hour (1-12)
    required int minute, // Input minute (0-59)
    required bool isPM, // Input whether the time is PM
    required int channelNumber, // Input channel number
    required ScheduleRepeatInterval repeatInterval, // Input repetition type
  }) async {
    // Initialize time zones
    tz.initializeTimeZones();

    // Determine the time zone based on the location
    String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.Location location;
    try {
      location = tz.getLocation(timeZoneName);
      // print(location);
    } catch (e) {
      location = tz.local;
      // print('defult timezone set is $location');
      print(e);
    }
    // Convert 12-hour format to 24-hour format
    int hour24 = isPM ? (hour % 12) + 12 : hour % 12;

    // Get the current time in the determined time zone

    final tz.TZDateTime now = tz.TZDateTime.now(location);
    print(now);
    // Calculate the scheduled time for today or tomorrow
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(location, now.year, now.month, now.day, hour24, minute);

    // If the scheduled time is before the current time, schedule it for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_$channelNumber', // Using the input channel number
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //  uiLocalNotificationDateInterpretation:
        //  UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatInterval == ScheduleRepeatInterval.once
          ? null
          : _getMatchDateTimeComponents(repeatInterval),
      payload: payload,
    );
  }

  DateTimeComponents? _getMatchDateTimeComponents(
      ScheduleRepeatInterval repeatInterval) {
    switch (repeatInterval) {
      case ScheduleRepeatInterval.daily:
        return DateTimeComponents.time;
      case ScheduleRepeatInterval.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case ScheduleRepeatInterval.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case ScheduleRepeatInterval.once:
      default:
        return null; // For one-time notifications, don't match any components
    }
  }

  @override
  void onClose() {
    LocalNotificationController.instance.cancelAllLocalNotification();
    super.onClose();
  }
}
