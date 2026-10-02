import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../Models/device.dart';
import '../features/history/modals/device_history.dart';
import '../features/history/modals/electricity_consumption_history.dart';
import '../features/history/modals/water_level_history.dart';
import '../features/scheduels/models/schedule.dart';
import 'firebase_data_controller.dart';

class WaterHeaterController extends GetxController {
  WaterHeaterController({
    required this.controllerId,
    required this.device,
  });
    var firebaseController=Get.find<FirebaseDataController>();
   Device device;
  int deviceIndex = 0;
  final String controllerId;

  // Reactive variable to hold the temperature value value will update accroding firebase in ready function;
  var setTemperature = 0.0.obs;

  // static final WaterHeaterController whc=Get.find();
  var selectedDuration = 0
      .obs; // Selected duration in seconds value will update according to firebase in ready funciton,
  var currentTime = 0.obs; // Current time in seconds
  var percentage = 0.0.obs; // Percentage for circular indicator
  var isTimerRunning = false.obs; // To track if the timer is running
  var selectedTimerOption = 0.obs;
  var totalTime = 600; // 10 minutes fix time for timer
  DateTime? startTime;
  Timer? timer;
  Timer? notificationTimer;
  var schedules = <Rx<Schedule>>[].obs;

  // Declare a global reference to the Firebase listener
  StreamSubscription? powerConsumptionListener;
  var isLoading = false.obs;

  void addPowerConsumptionListener(String deviceId) {
    // Listen to changes in the 'power' node of the specific device
    powerConsumptionListener = firebaseController.fb
        .child('devices/$deviceId/curMonthlyPower')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        int currentMonthConsumption = event.snapshot.value as int;

        // Compare current month consumption to the previous month's
        if (currentMonthConsumption > device.preMonthlyPower) {
          sendNotification(
            title: 'Electech',
            message:
                '"Action", $deviceId has exceeded its power consumption for this month.',
          );
        }
      }
    });
  }

  Future<void> selectDuration(int duration, optionNumber) async {
    selectedDuration.value = duration;
    // currentTime.value = duration;
    percentage.value = selectedDuration / totalTime;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTimerRunning.value) {
        percentage.value = 0.0;
      }
      timer.cancel();
    });
    //percentage.value=0.0;
    selectedTimerOption.value = optionNumber;

    firebaseController.user.value.devices[deviceIndex]
        .notification_time_in_sec = duration;
    await firebaseController.setDevice(controllerId);
  }

  Future<void> sendNotification(
      {required String title, required String message}) async {
    await firebaseController
        .sendNotificationToUsersWithDevice(controllerId, title, message);
  }

  Future<void> deleteDevice()async {
    await firebaseController.removeDeviceFromUser(controllerId);
    //onClose();
  }
  void toggleTimer() {
    if (isTimerRunning.value) {
      //Todo 2 also add values in history
      sendNotification(
          title: 'electech',
          message:
              '"action",  ${device.name} is turning off manually after ${formatTime(currentTime.value)}.');

      stopTimer();
    } else {
      // Todo 3 also add values in history
      startTimer();
    }
  }

  void startTimer() {
   // pushRandomPowerConsumption();
   // pushWaterLevelHistory();
    //before timer start first check temperature limit
    if (setTemperature.value >=
        firebaseController.user.value.devices[deviceIndex].temperature_C) {
      isTimerRunning.value = true;
      firebaseController.user.value.devices[deviceIndex].toggle();
      firebaseController.setDevice(firebaseController.user.value.devices[deviceIndex].deviceID);
      //  currentTime.value = 0; // Reset to the selected duration
      waterHeaterLogic();
      checkPowerConsumption();
    } else {
      // Show message: Temperature is too high to start the device.
      Get.snackbar("Warning",
          "Temperature is high from set value .\n Device cannot be turned on.");
    }
  }

  void startNotificationTimer() {
    int notificationCount = (totalTime - selectedDuration.value) ~/ 60;
    print('first notificaiton count is $notificationCount');
    notificationTimer?.cancel();
    notificationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      notificationCount--;

      // Show scaffold message each minute
      // sendNotification(title: 'electech', message: '"Reminder", ${device.name}   timeout before ${notificationCount+1}Turn   Off please ');

      if (notificationCount == 0 || currentTime.value >= totalTime) {
        // After 3 notifications, show final message and stop the device
        Get.snackbar("Notification", "Device is turning off due to timeout.");
        sendNotification(
            title: 'electech',
            message:
                '"action",  ${device.name} is turning off due to timeout .');
        stopTimer();
        timer.cancel(); // Stop the notification timer
      } else {
        Get.snackbar("Reminder", "Please turn off the device manually.");
        sendNotification(
            title: 'electech',
            message: '"Reminder" ${device.name} TimeOUT  Please turn off');
      }
    });
  }

  void waterHeaterLogic() {
    timer?.cancel();
    startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (setTemperature.value >=
         firebaseController.user.value.devices[deviceIndex].temperature_C) {
        if (currentTime.value < totalTime) {
          if (currentTime.value == selectedDuration.value) {
            // Show message when the current time equals the selected time
            Get.snackbar(
                "Notification", "Device has reached the selected time.");
            sendNotification(
                title: 'electech',
                message: '"Reminder", ${device.name}   TimeOUT Turn Off ');
            startNotificationTimer();
            //firebase notificaiton

            // sendNotification(title: 'electech', message: '"action" ${device.name} is turning off due to device has reached the selected time');
          }

          currentTime.value++;
          percentage.value = currentTime.value / totalTime;
        } else {
          Get.snackbar("Completed Schedule ",
              " 10 minutes completed .\n Stopping the device.",
              icon: const Icon(Icons.thermostat));
          stopTimer();
        }
      } else {
        sendNotification(
            title: 'electech',
            message:
                '"action", ${device.name} Temperature is High from Set Temperature .');

        // Show message and stop timer if temperature is over limit
        Get.snackbar("Warning",
            "Temperature is High from set Temperature. Stopping the device.");
        stopTimer();
      }
    });
  }

  // Method to update the temperature value
  Future updateTemperature(double value) async {
    setTemperature.value = value;
    firebaseController.user.value.devices[deviceIndex]
        .setTemperatureLimit(value);
    await firebaseController.setDevice(firebaseController.user.value.devices[deviceIndex].deviceID);
  }

  void stopTimer() async {
    pushDeviceHistory();
    timer?.cancel();
    notificationTimer?.cancel();
    currentTime.value = 0;
    percentage.value = 0.0;
    isTimerRunning.value = false;
    //update on firebase also switch button off
    firebaseController.user.value.devices[deviceIndex].toggle();
    await firebaseController.setDevice(firebaseController.user.value.devices[deviceIndex].deviceID);
    // print('${currentTime.value}');

    // currentTime.value=0;
  }

  void pushDeviceHistory() async {
    // Use the stored startTime instead of the current time for when the device was started
    if (startTime == null) {
      // print('Start time not available.');
      return;
    }
    // Get the current date and time for when the device is being turned off
    //   DateTime now = DateTime.now();

    // Format the start time and the duration
    String formattedTime = formatTime(
        currentTime.value); // Use your formatTime method to format the duration
    String dateString =
        "${startTime?.year}-${startTime?.month}-${startTime?.day}";
    String timeString =
        "${startTime?.hour}:${startTime?.minute}:${startTime?.second}";

    // Get the Firebase reference for device history
    final deviceHistoryRef = firebaseController.fb
        .child('devices/${device.deviceID}/history/deviceHistory');

    // Generate a new push reference, this creates a new entry with a unique ID
    final newEntryRef = deviceHistoryRef.push();

    // Get the pushId (unique key generated by Firebase)
    String pushId = newEntryRef.key!;

    // Prepare the history entry (duration, timestamp, and pushId)
    Map<String, dynamic> historyEntry = DeviceHistory.toJson(
        duration: formattedTime,
        date: dateString,
        time: timeString,
        myId: pushId);

    // Push the new history entry with the pushId included in the data
    newEntryRef.set(historyEntry).then((_) {
      print('Device history updated successfully with pushId.');
    }).catchError((error) {
      print('Failed to update device history: $error');
    });

    // Reset the start time
    startTime = null;
  }

  void pushRandomPowerConsumption() async {
    // Generate a random number of days between 1 and 30
    int randomDays = Random().nextInt(30) + 1; // Random number from 1 to 30

    // Get the current date and time and add the random number of days
    DateTime now = DateTime.now().add(Duration(days: randomDays));
   //  DateTime now = DateTime.now();
    // Format the current date and time
    String dateString = "${now.year}-${now.month}-${now.day}";
    String timeString = "${now.hour}:${now.minute}:${now.second}";

    // Generate random values for power1 and power2 for testing
    int randomPower1 = Random().nextInt(1001); // Random power1 value between 0 and 1000
    int randomPower2 = Random().nextInt(1001); // Random power2 value between 0 and 1000

    // Get the Firebase reference for power consumption history
    final powerConsumptionHistoryRef = firebaseController.fb
        .child('devices/${device.deviceID}/history/electricityConsumptionHistory');

    // Generate a new push reference, this creates a new entry with a unique ID
    final newEntryRef = powerConsumptionHistoryRef.push();

    // Get the pushId (unique key generated by Firebase)
    String pushId = newEntryRef.key!;

    // Prepare the history entry with random power values, date, time, and pushId
    Map<String, dynamic> historyEntry = {
      'id': pushId,
      'power1': randomPower1,
      'power2': randomPower2,
      'date': dateString,
      'time': timeString,
    };

    // Push the new power consumption entry with the pushId included in the data
    newEntryRef.set(historyEntry).then((_) {
      if (kDebugMode) {
        print(
          'Power consumption history updated successfully with pushId and random power values: power1=$randomPower1, power2=$randomPower2, date=$dateString, time=$timeString.');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to update power consumption history: $error');
      }
    });
  }


  void pushWaterLevelHistory() async {
    // Get the current date and time for when the water level is being recorded
    DateTime now = DateTime.now();

    // Format the current date and time
    String dateString = "${now.year}-${now.month}-${now.day}";
    String timeString = "${now.hour}:${now.minute}:${now.second}";

    // Generate a random water level between 0 and 100
    int randomWaterLevel = Random().nextInt(101); // Random number from 0 to 100

    // Get the Firebase reference for water level history
    final waterLevelHistoryRef = firebaseController.fb
        .child('devices/${device.deviceID}/history/waterLevelHistory');

    // Generate a new push reference, this creates a new entry with a unique ID
    final newEntryRef = waterLevelHistoryRef.push();

    // Get the pushId (unique key generated by Firebase)
    String pushId = newEntryRef.key!;

    // Prepare the history entry (random water level, date, time, and pushId)
    Map<String, dynamic> historyEntry = WaterLevelHistory.toJson(
      myId: pushId,
      waterLevel: randomWaterLevel, // Convert int to string
      date: dateString,
      time: timeString,
    );

    // Push the new history entry with the pushId included in the data
    newEntryRef.set(historyEntry).then((_) {
      print(
          'Water level history updated successfully with pushId and random water level: $randomWaterLevel.');
    }).catchError((error) {
      print('Failed to update water level history: $error');
    });
  }

  String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();

    ever(firebaseController.user, (user) {
      // Refresh schedules and other data when the user data changes
      // print('ever function called');
      refreshData();
    });
    // late Rx<DatabaseEvent> device;
    //  device.bindStream(fcontroller.fb.child('devices/$controllerId').onValue);
    //  ever(fcontroller.fb.child('devices/$controllerId').onValue,(event){
    //
    //  }
    //  );

    ///////////////Todo change this its just moke of power consumiton
    //addPowerConsumptionListener(controllerId);


    //checkPowerConsumption();
  }

  void refreshData() {
    deviceIndex =
        firebaseController.user.value.devices.indexWhere((device) {
      return device.deviceID == controllerId;
    });
     if(deviceIndex==-1){
       return;
     }
    setTemperature.value = firebaseController.user.value.devices[deviceIndex].temperature_limit
        .toDouble();
    int notiTime = firebaseController.user.value.devices[deviceIndex].notification_time_in_sec;
    selectedDuration.value = notiTime;
    int optionGuss = notiTime ~/ 60;
    if (optionGuss == 1) {
      selectedTimerOption.value = 0;
    } else if (optionGuss == 2) {
      selectedTimerOption.value = 1;
    } else if (optionGuss == 3) {
      selectedTimerOption.value = 2;
    } else {
      selectedTimerOption.value = 0;
    }

    schedules.value = firebaseController.user.value.devices[deviceIndex].schedules
        .map((s) => Rx(s))
        .toList();
  }

  @override
  void onClose() {
    timer?.cancel();
    notificationTimer?.cancel();
    powerConsumptionListener?.cancel();

    super.onClose();
  }

  Future addNewSchedule(
    DateTime time,
    List<String> daysOfWeek,
  ) async
  {
    await firebaseController
        .addSchedule(controllerId, time, daysOfWeek, true, '');
  }

  Future deleteSchedule(String scheduleId) async {
    await firebaseController
        .deleteSchedule(deviceId: controllerId, scheduleId: scheduleId);
  }

  Future updateSchedule(String scheduleId, DateTime time,
      List<String> daysOfWeek, bool isActive) async
  {
    var result = schedules.firstWhere((s) => s.value.id == scheduleId);
    result.value.time = time;
    result.value.daysOfWeek = daysOfWeek;
    result.value.isActive = isActive;
    isLoading.value = true;
    await firebaseController
        .updateSchedule(controllerId, scheduleId, result.value);
    isLoading.value = false;
    //Todo call firebase update method here
  }

  // Function to toggle the day in daysOfWeek list
  void toggleDay(String scheduleId, int dayIndex) {
    // Map dayIndex to actual day string (0=Sunday, 1=Monday, ..., 6=Saturday)
    var schedule = schedules.firstWhere((s) => s.value.id == scheduleId);
    String day = getDayString(dayIndex);

    if (schedule.value.daysOfWeek.contains(day)) {
      // If the day is already selected, remove it
      schedule.update((val) {
        val?.daysOfWeek.remove(day);
        updateSchedule(scheduleId, val!.time, val.daysOfWeek, val.isActive);
      });
    } else {
      // If the day is not selected, add it
      schedule.update((val) {
        val?.daysOfWeek.add(day);
        updateSchedule(scheduleId, val!.time, val.daysOfWeek, val.isActive);
      });
    }
  }

  // Get the day string from index (0=Sunday, 1=Monday, ..., 6=Saturday)
  String getDayString(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }
  bool validateTime(
    DateTime newTime,
    String scheduleId,
  )
  {
    const int minDifferenceInMinutes = 10;
    for (var schedule in schedules) {
      // Skip the schedule itself when updating
      if (schedule.value.id == scheduleId) continue;

      // Calculate the time difference in minutes
      final int differenceInMinutes =
          newTime.difference(schedule.value.time).inMinutes.abs();

      // If the time difference is less than 10 minutes, return false
      if (differenceInMinutes < minDifferenceInMinutes) {
        return false;
      }
    }

    // Return true if all schedules have a difference of 10 minutes or more
    return true;
  }

  String getDayAbbreviation(int index) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return days[index];
  }

  // Function to convert the time and days of the week to a readable string
  String getFormattedDate(DateTime time) {
    String formattedTime =
        "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
    //String formattedDays = daysOfWeek.join(', ');
    return formattedTime;
  }



  void checkPowerConsumption() {
    // Step 1: Sort the consumption history by date and time
  var sortedHistory= _getSortedData( device.deviceElectricityConsumptionHistories);

    // Step 2: Group by week
    Map<String, double> weeklyConsumption = {};

    for (var record in sortedHistory) {
      String weekKey = getWeekKey(record.date);

      if (weeklyConsumption.containsKey(weekKey)) {

          weeklyConsumption[weekKey] =weeklyConsumption[weekKey]!+ record.power1 ; // Assuming both power1 and power2 are to be summed

      } else {
        weeklyConsumption[weekKey] = record.power1 ;
      }
    }

    // Step 3: Check current week's consumption against previous week's
    List<String> sortedWeeks = weeklyConsumption.keys.toList()..sort();

    if (sortedWeeks.length < 2) return; // Not enough data to compare

    String currentWeekKey = sortedWeeks.last;
    String previousWeekKey = sortedWeeks[sortedWeeks.length - 2];

    double currentWeekConsumption = weeklyConsumption[currentWeekKey] ?? 0.0;
    double previousWeekConsumption = weeklyConsumption[previousWeekKey] ?? 0.0;

    // Step 4: Send notification if current week's consumption exceeds previous week's
    if (currentWeekConsumption > previousWeekConsumption) {
     sendNotification(title: ' ${device.name} Waring', message:  'Power consumption($currentWeekConsumption W) \n exceeds previous week consumption($previousWeekConsumption W).');
    }
  }

  String getWeekKey(String date) {
    // Assuming the date is in 'YYYY-MM-DD' format
    DateTime parsedDate = DateTime.parse(_formatDate(date));
    // Return a key representing the week (e.g., '2024-W43' for week 43 of 2024)
    return '${parsedDate.year}-W${(parsedDate.day / 7).ceil()}';
  }



  List<ElectricityConsumptionHistory> _getSortedData(List<ElectricityConsumptionHistory> histories) {
    histories.sort((a, b) {
      DateTime dateTimeA = _combineDateAndTime(a.date, a.time);
      DateTime dateTimeB = _combineDateAndTime(b.date, b.time);
      return dateTimeA.compareTo(dateTimeB);
    });
    return histories;
  }

  DateTime _combineDateAndTime(String date, String time) {
    try {
      // Parse the date and time strings into a DateTime object
      return DateTime.parse('${_formatDate(date)} ${_formatTime(time)}');
    } catch (e) {
      // Handle parsing error, return current date-time if error occurs
      if (kDebugMode) {
        print('Error: time and date are not correct');
      }
      return DateTime.now();
    }
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    final year = parts[0].padLeft(4, '0');
    final month = parts[1].padLeft(2, '0');
    final day = parts[2].padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hours = parts[0].padLeft(2, '0');
    final minutes = parts[1].padLeft(2, '0');
    final seconds = parts.length > 2 ? parts[2].padLeft(2, '0') : '00'; // Default to '00' if seconds aren't provided
    return '$hours:$minutes:$seconds';
  }

  String formatRemainingTime(String deviceID) {
    int passedTime=0;
    if(firebaseController.user.value.devices
        .firstWhere((device) => device.deviceID == deviceID)
        .remainingTime==0){
      passedTime=0;
    }else {
      passedTime = 600 - firebaseController.user.value.devices
          .firstWhere((device) => device.deviceID == deviceID)
          .remainingTime;
    }
    // Calculate hours, minutes, and seconds
    final hours = (passedTime ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((passedTime % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (passedTime % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

}
