import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/device.dart';
import '../features/authentication/controllers/auth_controller.dart';
import '../features/members/models/member.dart';
import '../features/members/models/member_ship.dart';
import '../features/scheduels/models/schedule.dart';
import '../Models/user.dart';
import '../features/notifications/controllers/firebase_push_notification_controller.dart';
import '../utiles/Widgets/alert_messages_dailog.dart';

class FirebaseDataController extends GetxController {
  final connectivityDuration = const Duration(seconds: 10);
  RxBool isOnline = true.obs; // Reactive variable to track connectivity status
  final List<StreamSubscription> _subscriptions = [];
  final currentUserId = AuthController.instance.cuser!.uid;
  final currentUser = AuthController.instance.cuser;
  static final FirebaseDataController instance =
      Get.find<FirebaseDataController>();
  Rx<User> user = User.dummy().obs;
  final fb = FirebaseDatabase.instance.ref();

  Rx<int> bottomNavigationCurrentIndex = 0.obs;

  set setIndex(int index) {
    bottomNavigationCurrentIndex.value = index;
  }

  @override
  void onInit() {
    final connectedRef = fb.child(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        isOnline.value = true;

        debugPrint(" firebase is Connected.");

        Get.snackbar('Connected', 'Online ',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white70,
            messageText: Text(
              'Online',
              style: TextStyle(color: Colors.black),
            ));
        fetchUserData(currentUserId).then((value) {
          // print('then fucniton called');
          user.value = value;
          user.value.fetchDevicesData().then((v) {
            addListonerToUser(currentUserId).then((value) {
              //  print(user.value.devicesIds);
            });
          });
          storeFcmToken(currentUserId);
        });
      }
      else
      {
        isOnline.value = false;
        debugPrint(" firebase is Not connected.");
        Get.snackbar(
          'No Internet', 'Check Your Connection Please',
          icon: const Icon(Icons.close),
          isDismissible: true,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          // margin: const EdgeInsets.only(bottom: 110),
        );
      }
    });
    //print('current user id ${currentUser?.displayName}');
    fetchUserData(currentUserId).then((value) {
      // print('then fucniton called');
      user.value = value;
      user.value.fetchDevicesData().then((v) {
        addListonerToUser(currentUserId).then((value) {
          //  print(user.value.devicesIds);
        });
      });
      storeFcmToken(currentUserId);
    });

    super.onInit();
  }

  Future<void> addListonerToUser(var userId) async {
    var userSubscription =
        fb.child('users/$userId').onValue.listen((event) async {
      // print('user listoner called');
      if (event.snapshot.exists) {
        //  print('lister is called for change in user detected');
        var u = User.fromJson(event.snapshot.value as Map, userId);

        await u.fetchDevicesData().then((value) {});
        user.value = u;

        // print(user.value.name);
        await addListonerToAllDevices();

        // await addListonerToAllDevices();
      } else {
        print('somehow event is empty ');
      }
    });
    _subscriptions.add(userSubscription);
  }

  Future<void> addListonerToAllDevices() async {
    // Iterate over the devicesIds list to fetch and listen for each device
    for (String deviceId in user.value.devicesIds) {
      var deviceSubscription =
          fb.child('devices/$deviceId').onValue.listen((event) async {
        // Fetch the device data from Firebase
        //  print('listerern is called at device :$deviceId');
        Device? fetchedDevice = await fetchDeviceData(deviceId);

        if (fetchedDevice != null) {
          // Update the local devices list with the fetched device data
          // Find and replace the device in the local devices list
          int index = user.value.devices
              .indexWhere((device) => device.deviceID == deviceId);
          if (index != -1) {
            user.update((val) {
              // print('updateing user device data ${val!.devices[index].name}');
              val!.devices[index] = fetchedDevice;
            });

            //user.value.devices[index] = fetchedDevice;
          } else {
            // If the device doesn't exist, add it to the list (optional)
            user.value.devices.add(fetchedDevice);
          }
        } else {
          //if device is delete then delete from modal

          // Find and and delete  in the local devices list
          int index = user.value.devices
              .indexWhere((device) => device.deviceID == deviceId);
          if (index != -1) {
            user.update((val) {
              val!.devices.removeAt(index);
            });

            //user.value.devices[index] = fetchedDevice;
          } else {
            // // If the device doesn't exist, add it to the list (optional)
            // user.value.devices.add(fetchedDevice);
          }
        }
      });

      _subscriptions.add(deviceSubscription);
    }
  }

  // Inside your FirebaseDataController class
  Future<User> fetchUserData(String userId) async {
    try {
      final snapshot =
          await fb.child('users/$userId').get().timeout(connectivityDuration);
      final userData = snapshot.value;
      if (userData != null && userData is Map) {
        var u = User.fromJson(userData, userId);

        return u;
      }
    } on TimeoutException {
      print('timeout exeption l');
      isOnline.value = false;
    } catch (e) {
      // Handle error gracefully
    }
    return User.dummy();
  }

  Future<Device?> fetchDeviceData(String deviceId) async {
    try {
      final snapshot = await fb.child('/devices/$deviceId').get();
      final deviceData = snapshot.value;

      if (deviceData != null && deviceData is Map) {
        // print(deviceData);
        return Device.fromJson(deviceData, deviceId);
      } else {
        // print('device not exist on /devices/$deviceId');
      }
    } catch (e) {
      print('error detedect .....................');
      print(e);
      // Handle error gracefully
    }
    return null;
  }

/////////////////////////////////////////////////////////////////////////
  Future<void> removeDeviceFromUser(String deviceId) async {
    try {
      final currentUserId = user.value
          .userId; // Replace this with your logic to get the current user ID

      // 1. Fetch all members from the current user that have this device

     /* final controller = Get.find<FirebasePushNotificationController>();*/
      //remove data in member record in current user
      final currentUserMembersRef = fb.child('users').child(currentUserId).child('members');
      DataSnapshot allMembersSnapshot = await currentUserMembersRef.get();

      for (var member in allMembersSnapshot.children) {
        Map<dynamic, dynamic> memberData =
        member.value as Map<dynamic, dynamic>;
        if (memberData['device'] == deviceId) {
         var memberId= member.key;
          await fb
              .child('users/$currentUserId/members/$memberId')
              .update({'device': ''});
          print('membership data updated on owner account');


        }
      }

      //////////////////////////////////////////////////////
      // 2. Check all members for the device

      final userRef = fb.child('users');
      DataSnapshot allUsersSnapshot = await userRef.get();
      for (var user in allUsersSnapshot.children) {
        DataSnapshot memberShipsSnapshot = user.child('memberShips');
        if(memberShipsSnapshot.exists) {
          String? memberUserId;
          for (var memberShip in memberShipsSnapshot.children) {
            Map<dynamic, dynamic> memberShipData =
            memberShip.value as Map<dynamic, dynamic>;
            if (memberShipData['device'] == deviceId) {
              memberUserId = user.key; // Found the memberId
              var memberShipId = memberShipData['id'];
              await fb
                  .child('users/$memberUserId/memberShips/$memberShipId')
                  .update({'device': ''});
              print('membership data updated on member account');

            }
          }
          if(memberUserId!=null) {
            final memberUserDeviceSnapshot = await fb
                .child('users/$memberUserId/devices')
                .orderByValue()
                .equalTo(deviceId)
                .once();
            if (memberUserDeviceSnapshot.snapshot.exists) {
              for (var device in memberUserDeviceSnapshot.snapshot.children) {
                final deviceKey = device.key!;
                await fb.child('users/$memberUserId/devices/$deviceKey')
                    .remove();
                print(
                    'Device $deviceId removed from member acount  user\'s devices list');
              }
            }
          }
        }
      }

//////////////////////////////////////////////////////////////////////
      // 4. Remove the device from the current user's devices list
      final currentUserDeviceSnapshot = await fb
          .child('users/$currentUserId/devices')
          .orderByValue()
          .equalTo(deviceId)
          .once();

      if (currentUserDeviceSnapshot.snapshot.exists) {
        for (var device in currentUserDeviceSnapshot.snapshot.children) {
          final deviceKey = device.key!;
          await fb.child('users/$currentUserId/devices/$deviceKey').remove();
          print('Device $deviceId removed from current user\'s devices list');
        }
      }

      print(
          'Device $deviceId removed from all members and the current user\'s account.');
    } catch (e) {
      print('Error removing device: $e');
      // Handle error gracefully (e.g., show a dialog)
      AlertMessagesDialog.errorMessageDialog('Error removing device: $e');
    }
  }

  Future<void> setDevice(String deviceId) async {
    try {
      // Find the device in the user.value.devices list
      Device? device = user.value.devices.firstWhere(
        (device) => device.deviceID == deviceId,
      );

      // Call toJson on the found device and update the Firebase database
      //print('set device state $deviceId current swtich state is ${device.switch2state}');
      // print('updateding firebase data');
      // print(device.switch2state);
      await fb.child('devices/$deviceId').update(device.toJson());
      // print('updated firebase data has been completeed');
      // print(device.switch2state);
    } catch (e) {
      // Handle error gracefully
      print('Failed to update device data: $e');
    }
  }

  Future<void> addNewDeviceToUser(String newDeviceId) async {
    try {
      final userDevicesRef =
          FirebaseDatabase.instance.ref().child('users/$currentUserId/devices');

      final deviceExists = await userDevicesRef
          .orderByValue()
          .equalTo(newDeviceId)
          .once()
          .then((DatabaseEvent event) => event.snapshot.exists);

      if (deviceExists) {
        print('device already added ');
        AlertMessagesDialog.errorMessageDialog('device already added ');
        return;
      } else {
        final deviceSnapshot = await fb.child('devices/$newDeviceId').get();

        if (deviceSnapshot.exists) {
          await fb
              .child('/users/$currentUserId/devices')
              .push()
              .set(newDeviceId);
        } else {
          // // await fb.child('devices').push().set(newDeviceId);
          //  await fb
          //      .child('/users/$currentUserId/devices')
          //      .push()
          //      .set(newDeviceId);
          AlertMessagesDialog.errorMessageDialog(
              'device is not exist in database');
        }
      }
    } catch (e) {
      return;
    }
  }

  void resetValues() {
    user = User.dummy().obs;
    user.value.clearDevicesData();
  }

  @override
  void onClose() {
    print(' firebase data contorller close method called');
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear(); // Clear the list to prevent memory leaks
    deleteFcmToken(currentUserId);
    // Reset the user data or perform any other cleanup
    // resetValues();

    super.onClose();
  }

  Future<void> storeFcmToken(String userId) async {
    try {
      // Get the FCM token from the FirebasePushNotificationController
      String? fcmToken =
          await Get.find<FirebasePushNotificationController>().getFcmToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // Store the FCM token under the user's ID in Firebase Realtime Database
        await fb.child('users/$userId').update({
          'fcmToken': fcmToken,
        });
        print('FCM token stored successfully.');
      } else {
        print('Failed to retrieve FCM token.');
      }
    } catch (e) {
      print('Error storing FCM token: $e');
    }
  }

  Future<void> deleteFcmToken(String userId) async {
    try {
      // Remove the FCM token from the user's data in Firebase
      await fb.child('users/$userId/fcmToken').remove();
      print('FCM token deleted successfully.');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }

  Future<void> sendNotificationToUsersWithDevice(
      String deviceId, String title, String message) async
  {
    try {
      // Fetch all users from Firebase Realtime Database
      final usersSnapshot = await fb.child('users').get();
      List<String> fcmTokens = [];

      if (usersSnapshot.exists && usersSnapshot.value != null) {
        final usersData = usersSnapshot.value as Map;

        // Iterate through all users and filter those with the specific device
        usersData.forEach((userId, userData) {
          if (userData != null && userData is Map) {
            final devices = userData['devices'] as Map<dynamic, dynamic>?;

            // Check if the user has the specific device in their devices list
            if (devices != null && devices.containsValue(deviceId)) {
              final fcmToken = userData['fcmToken'];
              if (fcmToken != null && fcmToken.isNotEmpty) {
                fcmTokens.add(fcmToken); // Add valid FCM tokens to the list
              }
            }
          }
        });
      }

      // Now send notifications to all collected FCM tokens
      if (fcmTokens.isNotEmpty) {
        var controller = Get.find<FirebasePushNotificationController>();
        for (String token in fcmTokens) {
          await controller.sendFcmNotification(token, title, message);
        }
        //  print('Notification sent to all users with device: $deviceId');
      } else {
        print('No users found with device: $deviceId');
      }
    } catch (e) {
      print('Error while sending notification: $e');
    }
  }

  Future<void> addSchedule(
    String deviceId,
    DateTime time,
    List<String> daysOfWeek,
    bool isActive,
    String name, // Adding name parameter if needed
  ) async
  {
    try {
      // Create a reference to the Firebase Realtime Database for the schedules node
      DatabaseReference deviceRef = FirebaseDatabase.instance
          .ref()
          .child('devices')
          .child(deviceId)
          .child('schedules');

      // Generate a unique key for the new schedule
      DatabaseReference newScheduleRef = deviceRef.push();

      // Create a new Schedule object with the unique ID
      Schedule newSchedule = Schedule(
        id: newScheduleRef.key ?? '',
        // Use the generated unique key
        name: name,
        time: time,
        daysOfWeek: daysOfWeek,
        isActive: isActive,
      );

      // Convert the new schedule to JSON
      Map<String, dynamic> newScheduleJson = newSchedule.toJson();

      // Add the new schedule under the unique key
      await newScheduleRef.set(newScheduleJson);

      print('Schedule added successfully.');
    } catch (e) {
      // Handle any errors or exceptions that occur
      print('Failed to add schedule: $e');
      // You can also log the error or show a user-friendly message here
    }
  }

  Future<void> deleteSchedule({
    required String deviceId,
    required String scheduleId,
  }) async
  {
    try {
      // Create a reference to the specific schedule to be deleted
      DatabaseReference scheduleRef = fb
          .child('devices')
          .child(deviceId)
          .child('schedules')
          .child(scheduleId);

      // Remove the schedule from the database
      await scheduleRef.remove();

      print('Schedule deleted successfully.');
    } catch (e) {
      // Handle any errors or exceptions that occur
      print('Failed to delete schedule: $e');
      // You can also log the error or show a user-friendly message here
    }
  }

  Future<void> updateSchedule(
    String deviceId,
    String scheduleId,
    Schedule updatedSchedule,
  ) async
  {
    try {
      // Create a reference to the specific schedule to be updated
      DatabaseReference scheduleRef = FirebaseDatabase.instance
          .ref()
          .child('devices')
          .child(deviceId)
          .child('schedules')
          .child(scheduleId);

      // Convert the updated schedule to JSON
      var updatedScheduleJson = updatedSchedule.toJson();

      // Update the schedule data in the database
      await scheduleRef.update(updatedScheduleJson);

      print('Schedule updated successfully.');
    } catch (e) {
      // Handle any errors or exceptions that occur
      print('Failed to update schedule: $e');
      // You can also log the error or show a user-friendly message here
    }
  }

  Future<void> updateProfileImageUrl(String? imageUrl) async
  {
    user.update((userData) {
      userData?.profileImageUrl = imageUrl;
    });
    // real time database update url
    await fb
        .child('users/${user.value.userId}')
        .update({'profileImageUrl': imageUrl});
  }

  Future<void> deleteMemberFromDevice(String email, String deviceId) async
  {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Reference to users node
      final usersRef = FirebaseDatabase.instance.ref().child('users');

      // Find the user with the given email
      final userSnapshot =
          await usersRef.orderByChild('email').equalTo(email).once();

      // Check if the user with the given email exists
      if (userSnapshot.snapshot.exists) {
        String memberUserId = '';

        // Get the userId of the member
        for (var user in userSnapshot.snapshot.children) {
          memberUserId = user.key!; // Get the userId
        }

        // Check if the member has the device
        final memberDevicesSnapshot =
            await fb.child('users/$memberUserId/devices').get();

        if (memberDevicesSnapshot.exists) {
          bool deviceFound = false;
          String? deviceKey;

          // Loop through the devices to find the specific deviceId
          for (var device in memberDevicesSnapshot.children) {
            if (device.value == deviceId) {
              deviceFound = true;
              deviceKey = device.key;
              break;
            }
          }

          if (deviceFound && deviceKey != null) {
            // Remove the device from the member's devices list
            await fb.child('users/$memberUserId/devices/$deviceKey').remove();
            print('Device removed from member successfully');

            // Remove the member from the current user's member list
            final currentUserId = user
                .value.userId; // Replace with your logic to get current user ID
            final memberRefInOwner =
                fb.child('users/$currentUserId/members/$memberUserId');

            // Check if the member exists in the current user's members list
            final memberSnapshot = await memberRefInOwner.get();
            if (memberSnapshot.exists) {
              // Remove the member from the current user's members list
              await memberRefInOwner.remove();
              print('Member removed from current user\'s member list');
              // Dismiss the loading dialog using GetX
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
            } else {
              // Dismiss the loading dialog using GetX
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
              print('Member does not exist in current user\'s member list');
            }
          } else {
            // Dismiss the loading dialog using GetX
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            print('Device not found for the member');
            AlertMessagesDialog.errorMessageDialog(
                'Device not found for the member');
          }
        } else {
          // Dismiss the loading dialog using GetX
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          print('Member does not have any devices');
          AlertMessagesDialog.errorMessageDialog(
              'Member does not have any devices');
        }
      } else {
        // Dismiss the loading dialog using GetX
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        print('Member email not found');
        AlertMessagesDialog.errorMessageDialog('Member email not found');
      }
    } catch (e) {
      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('Error deleting member: $e');
    }
  }

  Future<void> addMemberToDevice(String email, String deviceId) async
  {
    // print('deviceid $deviceId');

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible:
            false, // Prevent closing the dialog by tapping outside
      );
      // Reference to users node
      final usersRef = FirebaseDatabase.instance.ref().child('users');

      // Find the user with the given email
      final userSnapshot =
          await usersRef.orderByChild('email').equalTo(email).get();

      // Check if the user with the given email exists
      if (userSnapshot.exists) {
        String? isOwner = '';
        String memberUserId = '';
        String memberEmail = email;
        String memberName = '';

        // Loop through the snapshot to find the user data
        for (var user in userSnapshot.children) {
          memberUserId = user.key!; // Get the userId
          isOwner =
              user.child('isOwner').value as String; // Check isOwner field
          memberName = user.child('name').value as String; // Get member name
        }

        if (isOwner == 'true') {
          print('Cannot add owner as a member');
          // Dismiss the loading dialog using GetX
          if (Get.isDialogOpen ?? false) {
            Get.back(); // Closes the dialog
          }
          AlertMessagesDialog.errorMessageDialog(
              'Cannot add owner as a member');
          return;
        }

        // Check if the member already has a device
        final memberDevicesSnapshot =
            await fb.child('users/$memberUserId/devices').get();
        if (memberDevicesSnapshot.exists &&
            memberDevicesSnapshot.children.isNotEmpty) {
          print(
              'Member already has a device. A member can only have one device.');
          // Dismiss the loading dialog using GetX
          if (Get.isDialogOpen ?? false) {
            Get.back(); // Closes the dialog
          }
          AlertMessagesDialog.errorMessageDialog(
              'Member already has a device. A member can only have one device.');

          return;
        }

        // Check if the device exists in the devices node
        final deviceSnapshot = await fb.child('devices/$deviceId').get();

        if (deviceSnapshot.exists) {
          // Add the device to the member's devices list
          await fb.child('users/$memberUserId/devices').push().set(deviceId);

          print('Device added to member successfully');

          // Add the member and the device to the current user's member list
          final currentUserId = user
              .value.userId; // Replace with your logic to get current user ID

          // Reference to the member under the current user
          final memberRefInOwner =
              fb.child('users/$currentUserId/members/$memberUserId');

          // Check if the member already exists in the current user's members list
          final memberSnapshot = await memberRefInOwner.get();

          if (memberSnapshot.exists) {
            print('Member exists, now checking devices.');

            // Reference to the devices child of the member
            final devicesRef = memberRefInOwner.child('device');

            // Since the member can have only one device, we directly set the deviceId (not using push)
            await devicesRef.set({deviceId});
            print('Device updated in  member');
          } else {
            // Member does not exist, create a new member entry with the device
            //  print('trying');
            await memberRefInOwner.set({
              'email': memberEmail,
              'name': memberName,
              'device': deviceId,
              'status': 'Approved',
            });
            //   print('pass');
            // Set the device under the member
            // await memberRefInOwner.child('devices').set({deviceId});
            print(
                'Member and device added successfully to current user\'s members list');
            // Dismiss the loading dialog using GetX
            if (Get.isDialogOpen ?? false) {
              Get.back(); // Closes the dialog
            }
          }
        } else {
          // Dismiss the loading dialog using GetX
          if (Get.isDialogOpen ?? false) {
            Get.back(); // Closes the dialog
          }
          print('Device does not exist in the database');
          AlertMessagesDialog.errorMessageDialog(
              'Device does not exist in the database');
        }
      } else {
        // Dismiss the loading dialog using GetX
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Closes the dialog
        }
        print('Member email not found');
        AlertMessagesDialog.errorMessageDialog('Member email not found');
      }
    } catch (e) {
      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Closes the dialog
      }
      print('Error adding member: $e');
      return;
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Reference to the current user's members node
      final membersRef = FirebaseDatabase.instance
          .ref()
          .child('users/${user.value.userId}/members');

      // Get all members of the current user
      final membersSnapshot = await membersRef.get();

      if (membersSnapshot.exists) {
        // Loop through each member to check if they are attached to the device
        for (var member in membersSnapshot.children) {
          String memberUserId = member.key!;

          // Check if this member has the given deviceId attached
          final memberDeviceSnapshot = await FirebaseDatabase.instance
              .ref()
              .child('users/$memberUserId/devices')
              .orderByValue()
              .equalTo(deviceId)
              .once();

          if (memberDeviceSnapshot.snapshot.exists) {
            // Device found for this member, so delete the member-device association
            await deleteMemberFromDevice(
                member.child('email').value as String, deviceId);
          }
        }
      }

      // Once all members are processed, delete the device from the current user's device list
      final currentUserDevicesRef = FirebaseDatabase.instance
          .ref()
          .child('users/${user.value.userId}/devices');

      final deviceSnapshot =
          await currentUserDevicesRef.orderByValue().equalTo(deviceId).once();

      if (deviceSnapshot.snapshot.exists) {
        // Remove the device from the current user's device list
        for (var device in deviceSnapshot.snapshot.children) {
          await currentUserDevicesRef.child(device.key!).remove();
          print('Device $deviceId removed from current user\'s device list');
        }
        // Dismiss the loading dialog using GetX
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      } else {
        // Dismiss the loading dialog using GetX
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        print('Device not found in current user\'s device list');
        AlertMessagesDialog.errorMessageDialog(
            'Device not found in current user\'s device list');
      }
    } catch (e) {
      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('Error deleting device: $e');
    }
  }


  Future<void> handleMembershipRequest({
    required String ownerShareCode, // Share code provided by the user
  }) async
  {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. Check if the owner with the share code exists
      DataSnapshot ownersSnapshot = await usersRef.get();
      String? ownerId;
      String? ownerName;
      String? ownerFcmToken;

      for (var user in ownersSnapshot.children) {
        Map<dynamic, dynamic> userData = user.value as Map<dynamic, dynamic>;
        if (userData['shareCode'] == ownerShareCode) {
          ownerId = user.key;
          ownerName = userData['name'];
          ownerFcmToken = userData['fcmToken'];
          break;
        }
      }

      if (ownerId == null) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'No owner exists with the provided share code.');
        return;
      }

      // 2. Check if the current user already has a membership for this share code
      DatabaseReference currentUserMembershipsRef =
          usersRef.child(currentUserId).child('memberShips');

      DataSnapshot membershipsSnapshot = await currentUserMembershipsRef.get();
      for (var membership in membershipsSnapshot.children) {
        Map<dynamic, dynamic> membershipData =
            membership.value as Map<dynamic, dynamic>;
        if (membershipData['ownerShareCode'] == ownerShareCode) {
          Get.back();
          AlertMessagesDialog.errorMessageDialog(
              'You have already sent a membership request.');
          return;
        }
      }

      // 3. Add the new membership request to the current user
      String newMembershipId = currentUserMembershipsRef.push().key ??
          'membership_${DateTime.now().millisecondsSinceEpoch}';

      MemberShip newMembership = MemberShip(
        id: newMembershipId,
        ownerName: ownerName!,
        device: "",
        // Device assignment will be handled later by the owner
        ownerShareCode: ownerShareCode,
        status: "pending",
      );

      await currentUserMembershipsRef
          .child(newMembershipId)
          .set(newMembership.toJson());

      // 4. Add the member to the owner's account
      DatabaseReference ownerMembersRef =
          usersRef.child(ownerId).child('members');

      String newMemberId = newMembershipId;

      Member newMember = Member(
        id: newMemberId,
        email: user.value.email,
        name: user.value.name,
        device: "",
        // Device assignment will be handled later
        status: "pending", // Membership pending approval
      );

      await ownerMembersRef.child(newMemberId).set(newMember.toJson());
      Get.back();
      Get.back();
      var controller = Get.find<FirebasePushNotificationController>();
      print('Membership request sent successfully and member added to owner.');
      controller.sendFcmNotification(ownerFcmToken ?? '', 'MemberShip Request',
          'You have recived a new membership request from ${user.value.name}');
    } catch (e) {
      Get.back();
      print('Error: $e');
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  Future<void> deleteMembership({
    required String membershipId, // Membership ID
  }) async
  {
    DatabaseReference usersRef = fb.child('users');

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. Reference to current user's memberships
      DatabaseReference currentUserMembershipRef = usersRef
          .child(currentUserId)
          .child('memberShips')
          .child(membershipId);

      // Get the membership data
      DataSnapshot membershipSnapshot = await currentUserMembershipRef.get();

      if (!membershipSnapshot.exists) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'Membership does not exist or has already been deleted.');
        return;
      }

      // Extract the device ID (if assigned)
      Map<dynamic, dynamic> membershipData =
          membershipSnapshot.value as Map<dynamic, dynamic>;
      String? deviceId = membershipData['device'];

      // 2. Delete the membership from the current user's data
      await currentUserMembershipRef.remove();

      // 1. Locate the owner based on membershipId
      String? ownerId;
      String? ownerFcmToken;
      DataSnapshot allUsersSnapshot = await usersRef.get();

      for (var user in allUsersSnapshot.children) {
        DataSnapshot membersSnapshot = user.child('members');
        for (var member in membersSnapshot.children) {
          if (member.key == membershipId) {
            Map<dynamic, dynamic> ownerData =
                user.value as Map<dynamic, dynamic>;
            ownerId = user.key;
            ownerFcmToken = ownerData['fcmToken']; // Found the ownerId
            break;
          }
        }
        if (ownerId != null) break; // Exit outer loop if ownerId is found
      }

      if (ownerId == null) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'No owner found for the provided membership ID.');
        return;
      }
      // 4. Delete the member entry from the owner's data
      DatabaseReference ownerMemberRef =
          usersRef.child(ownerId).child('members').child(membershipId);
      await ownerMemberRef.remove();

      // 4. If there is an assigned device, delete it from the current user's devices list

      // Check if the member has the device
      final memberDevicesSnapshot =
          await fb.child('users/$currentUserId/devices').get();

      if (memberDevicesSnapshot.exists) {
        bool deviceFound = false;
        String? deviceKey;

        // Loop through the devices to find the specific deviceId
        for (var device in memberDevicesSnapshot.children) {
          if (device.value == deviceId) {
            deviceFound = true;
            deviceKey = device.key;
            break;
          }
        }

        if (deviceFound && deviceKey != null) {
          // Remove the device from the member's devices list
          await fb.child('users/$currentUserId/devices/$deviceKey').remove();
          print('Device removed from member successfully');
        }
      }

      Get.back();
      //AlertMessagesDialog.successMessageDialog('Membership deleted successfully.');
      final controller = Get.find<FirebasePushNotificationController>();
      controller.sendFcmNotification(ownerFcmToken ?? '', 'MemberShip Removed',
          ' ${user.value.name} skip membership by itself');

      print('Membership and associated data deleted successfully.');
    } catch (e) {
      Get.back();
      print('Error: $e');
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  Future<void> acceptMembershipRequest({
    required String membershipId, // Membership ID
  }) async
  {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. Get the membership data from the owner
      DatabaseReference ownerMembersRef =
          usersRef.child(currentUserId).child('members').child(membershipId);
      await ownerMembersRef.update({'status': 'approved'});

      // 1. Locate the member based on membershipId
      String? memberId;
      String? memberFcmToken;
      DataSnapshot allUsersSnapshot = await usersRef.get();

      for (var user in allUsersSnapshot.children) {
        DataSnapshot membersSnapshot = user.child('memberShips');
        for (var memberShip in membersSnapshot.children) {
          if (memberShip.key == membershipId) {
            memberId = user.key; // Found the memberId
            Map<dynamic, dynamic> memberData =
                user.value as Map<dynamic, dynamic>;
            memberFcmToken = memberData['fcmToken'];
            break;
          }
        }
        if (memberId != null) break; // Exit outer loop if ownerId is found
      }

      if (memberId == null) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'No member  found for the provided membership ID.');
        return;
      }
      // 4. Delete the member entry from the owner's data
      DatabaseReference ownerMemberRef =
          usersRef.child(memberId).child('memberShips').child(membershipId);
      await ownerMemberRef.update({'status': 'approved'});

      Get.back();
      // AlertMessagesDialog.successMessageDialog('Membership request accepted and approved.');
      print('Membership request accepted and status updated to approved.');
      final controller = Get.find<FirebasePushNotificationController>();
      controller.sendFcmNotification(
          memberFcmToken ?? '',
          'MemberShip Accepted',
          ' ${user.value.name} Accept your memberShip request');
    } catch (e) {
      Get.back();
      print('Error: $e');
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  Future<void> deleteMember({
    required String memberId, // Membership ID
  }) async
  {
    DatabaseReference usersRef = fb.child('users');

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. Reference to current user's memberships
      DatabaseReference currentUserMemberRef =
          usersRef.child(currentUserId).child('members').child(memberId);

      // Get the membership data
      DataSnapshot memberSnapshot = await currentUserMemberRef.get();

      if (!memberSnapshot.exists) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'Member  does not exist or has already been deleted.');
        return;
      }

      // Extract the device ID (if assigned)
      Map<dynamic, dynamic> memberData =
          memberSnapshot.value as Map<dynamic, dynamic>;
      String? deviceId = memberData['device'];

      // 2. Delete the membership from the current user's data
      await currentUserMemberRef.remove();

      // 1. Locate the owner based on membershipId
      String? memberUserId;
      String? memberFcmToken;
      DataSnapshot allUsersSnapshot = await usersRef.get();

      for (var user in allUsersSnapshot.children) {
        DataSnapshot membersSnapshot = user.child('memberShips');
        for (var memberUser in membersSnapshot.children) {
          if (memberUser.key == memberId) {
            memberUserId = user.key; // Found the memberUser id
            Map<dynamic, dynamic> memberData =
                user.value as Map<dynamic, dynamic>;
            memberFcmToken = memberData['fcmToken'];
            break;
          }
        }
        if (memberUserId != null) break; // Exit outer loop if ownerId is found
      }

      if (memberUserId == null) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'No owner found for the provided membership ID.');
        return;
      }
      // 4. Delete the member entry from the owner's data
      DatabaseReference memberUserRef =
          usersRef.child(memberUserId).child('memberShips').child(memberId);
      await memberUserRef.remove();

      // 4. If there is an assigned device, delete it from the member user's devices list
      /////////////////////////////////////////////
      // Check if the member has the device
      final memberDevicesSnapshot =
          await fb.child('users/$memberUserId/devices').get();

      if (memberDevicesSnapshot.exists) {
        bool deviceFound = false;
        String? deviceKey;

        // Loop through the devices to find the specific deviceId
        for (var device in memberDevicesSnapshot.children) {
          if (device.value == deviceId) {
            deviceFound = true;
            deviceKey = device.key;
            break;
          }
        }

        if (deviceFound && deviceKey != null) {
          // Remove the device from the member's devices list
          await fb.child('users/$memberUserId/devices/$deviceKey').remove();
          print('Device removed from member successfully');
        }
      }

      ////////////////////////////////////////

      Get.back();
      //AlertMessagesDialog.successMessageDialog('Membership deleted successfully.');
      final controller = Get.find<FirebasePushNotificationController>();
      controller.sendFcmNotification(memberFcmToken ?? '', 'MemberShip Removed',
          ' ${user.value.name} skip membership by itself');

      print('Membership and associated data deleted successfully.');
    } catch (e) {
      Get.back();
      print('Error: $e');
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  Future<void> addDeviceToMember({
    required String deviceId,
    required String membershipId,
  }) async
  {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. Get the current user's devices and add the device to their `members` data
      DatabaseReference ownerDeviceRef =
          usersRef.child(currentUserId).child('members').child(membershipId);
      await ownerDeviceRef.update({'device': deviceId});

      // 2. Locate the member in the database
      DataSnapshot allUsersSnapshot = await usersRef.get();

      String? memberUserId;
      String? memberFcmToken;

      for (var user in allUsersSnapshot.children) {
        DataSnapshot membersSnapshot = user.child('memberShips');
        for (var memberShip in membersSnapshot.children) {
          if (memberShip.key == membershipId) {
            memberUserId = user.key; // Found the memberId
            Map<dynamic, dynamic> memberData =
                user.value as Map<dynamic, dynamic>;
            memberFcmToken = memberData['fcmToken'];
            break;
          }
        }
        if (memberUserId != null) break; // Exit outer loop if memberId is found
      }

      if (memberUserId == null) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog(
            'No member  found for the provided membership ID.');
        return;
      }

      await fb.child('users/$memberUserId/devices').push().set(deviceId);

      DatabaseReference memberDeviceRef =
          usersRef.child(memberUserId).child('memberShips').child(membershipId);
      await memberDeviceRef.update({'device': deviceId});

      /*for (var user in allUsersSnapshot.children) {
        if (user.key == memberId) {
          // Member found, update their devices and memberships
          memberFound = true;
          Map<dynamic, dynamic> memberData = user.value as Map<dynamic, dynamic>;

          // Get FCM token for notification
          memberFcmToken = memberData['fcmToken'];

          // 3. Update the member's devices list
          DatabaseReference memberDeviceRef = usersRef.child(memberId).child('devices');
          await memberDeviceRef.update({'deviceId': deviceId});

          // 4. Update the membership data to include the device
          DatabaseReference memberMembershipRef = usersRef.child(memberId).child('memberShips').child(memberId).child('devices').child(deviceId);
          await memberMembershipRef.set({'deviceId': deviceId});

          break;
        }
      }

      if (!memberFound) {
        Get.back();
        AlertMessagesDialog.errorMessageDialog('No member found for the provided member ID.');
        return;
      }*/

      // 5. Notify the member about the device addition
      Get.back();
      final controller = Get.find<FirebasePushNotificationController>();
      controller.sendFcmNotification(memberFcmToken ?? '', 'Device Added',
          'A new device ($deviceId) has been added to your account.');

      print('Device successfully added to member.');
      // AlertMessagesDialog.successMessageDialog('Device successfully added to the member.');
    } catch (e) {
      // Handle errors
      Get.back();
      print('Error: $e');
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }
}
