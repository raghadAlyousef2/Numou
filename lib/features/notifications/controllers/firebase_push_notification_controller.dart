import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as GoogleApiauth;

import 'local_notification_controller.dart';

class FirebasePushNotificationController extends GetxController {
  final _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription? messageStream;
  String? fcmToken;
  String? serverKey;
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future _init() async {
    Get.put(LocalNotificationController());
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    messageStream =
        FirebaseMessaging.onMessage.listen(_firebaseForegoundMessage);
    serverKey=await getServerTokenKey();
  }

  Future getFcmToken() async {
    // get the device fcm token
    fcmToken = await _firebaseMessaging.getToken();
   // print('Fcm token for this device $fcmToken');
    if (fcmToken != null) {
      return fcmToken;
    } else {
      return '';
    }
  }

  Future<String> getServerTokenKey() async {
    final clientJsonConfiguration = {
      "type": "service_account",
      "project_id": "electech-ee213",
      "private_key_id": "1cee2d937ab5db6a00eb17bbb8a60cd9685934e4",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCb5aes/wLaFw8D\ndfi/+u/8qj58UFRQ/qTqx9nT4YDsxp1Fe+1XC2M9LhulsCBS1vXQds7fSyYawGkZ\nozTENtGmjSyb+8zL9Ipc/SDr+Ss7uIrC3zncRaX69GN/4nLkzIYOQmxYskezdXAF\n719zaMl02gQza4TCq4B+OXcNDssAw2ADYlCkEjVjot30bpLyh5vDpbHhGwKC16pO\nZJ0FxpLRcbgWBzZIMUR1YeoZgUoKxBMWXU8BtpyV1U7OMISWN22B2yiVDS7bov2R\n3Y5wrnzxUPR5rPiYAighZsx7QNzNxuJRw5JzZkpYrbGwyZQjcYEPTz1OKaxb9n5d\nQfF5GXwTAgMBAAECggEAAIoJ6gOMTyX+L9sTfLWulqOb9+zAG5trBWr6RLOjchMI\nOrR+qiIaCgYj61cZZoIkh3mq0hJc6jS0QxkB5rxb9/oTH5Uoj7jh4l9mHnwkJrxv\nR0FCcbTdhqwaNDFCTHYWovEEYW0kmSBXAQKGeRFsTIU+eEUrkgHe7uXf8auf/ydW\nifwHWI5IDOu3FCl1PtwykjlOWm071I5NGkLmhkazAShvxafPBpUDoFbU8x0Ez9vi\nK6nZlK07UIyVMTV4rJUMxq3iuolGtFXuIeLisVIjJ8+k+zbHbnlXPemym6PO9IEH\nCdDKokpIqfNMcGsjajGJINoJV6BXvXa9jC+9AhB5/QKBgQDYvhYr1F0YN8bIvSuH\n2M5EF5RGnMuk7UlcCoJHRZliOdUTZq/giWXXYIfI0HEv67iWYxB+gAInSJty0Ycx\nI7HxCBxO8zr0+BgQazrynngy6qNGJbPgUEmgS8asb8a5rtP0vFLhXO9LnYeefvbo\n8h7CAioq6krxkgUoH02CQEf7LwKBgQC4IknQSPod3QvdSgZhFyaIxZYR4LRwVRqR\nq27nLROl4aygR7KF37uikQkY9Fm52LQfSD5UMYQTbzzrr2TySxDby1M1g+VC+6YH\nP426Hozpof1RfniCSQeqpKDz19R+jiH5CAOqWdDwX29WSwOwoIsTLR9AnD6uqWgl\nYh6OzcGEXQKBgAlwTbre5qb1VtzLECg8Us84T6a7kUq/YqB1fLLp3wIeDp9nq2UV\n1q+IbqFaInO5yjISYld/75gSW2KmqUKEkW0zszfk875TR4j/gnOqXwWoni+h2LF+\nDZbDdgVwYLEZYfWYdeuGho0+cPeAA/SlBp3gRkHULitS9pKGunNfpULVAoGAcoJA\nTRtVEAVLP46tcOuotx3JOcz36XPDVhu6mGFb+qjhZbuwtbhxQ6PWeIJc2kp9mYaf\n3FP+wudGh3tH17X/AfDsCje/92vv0EohpUEieJiYpHl2D+/CqMhAn+P07c8OKYRm\nYyX/3bw7zPpRjSIJ2x8QdGm2QYBwl+7w+fXTBrECgYAs9pDY+UiJESaPCnrIu9iU\nVLfFpWknx5wHnKhQ68AB8ObNNvC1PyiJyOkO2IMs4JuTIIzlaVnj62usBGLfoBqy\n//2NliKBmuAjIOcyJIesHqQIpoT2QgVvMZoRFhKpGDDR/RgxSktNPdWnRTpFQEHx\nLdgEAR5lGTdxRJiuzaqgKg==\n-----END PRIVATE KEY-----\n",
      "client_email": "electech-notification-service@electech-ee213.iam.gserviceaccount.com",
      "client_id": "112580852272965027064",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/electech-notification-service%40electech-ee213.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> clientScopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    try {
    http.Client client = await GoogleApiauth.clientViaServiceAccount(
      GoogleApiauth.ServiceAccountCredentials.fromJson(clientJsonConfiguration),
      clientScopes,
    );
    try {
    GoogleApiauth.AccessCredentials credentials =
        await GoogleApiauth.obtainAccessCredentialsViaServiceAccount(
            GoogleApiauth.ServiceAccountCredentials.fromJson(clientJsonConfiguration),
            clientScopes,
            client);

   // print('server key is generated key is ${credentials.accessToken.data}');

    return credentials.accessToken.data;
  } catch (authError) {

  // Handle errors specific to authentication or token retrieval
  print('Error obtaining access credentials: $authError');
  rethrow; // Optionally rethrow after logging
  } finally {
  client.close(); // Ensure the client is always closed
  }
} catch (e) {
// Handle other potential errors, such as network issues
print('An error occurred: content$e');
 return '';
}
  }


  Future<void> sendFcmNotification(
      String fcmToken, String title, String message) async {
    const String endPointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/electech-ee213/messages:send';

    // Check if the server key is empty or null
    if (serverKey == null || serverKey?.isEmpty==null?true:serverKey!.isEmpty) {
      try {
        // Try generating a new server key
        //print('Server key is null or empty, generating a new one...');
        serverKey = await getServerTokenKey(); // Call your function to get a new token

        if (serverKey == null || serverKey?.isEmpty==null?true:serverKey!.isEmpty) {
          print('Failed to generate a valid server key.');
          return;
        }
      } catch (e) {
        print('Error while generating server key: $e');
        return;
      }
    }

    // Constructing the request body
    final Map<String, dynamic> body = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': title,
          'body': message,
        },
        'data': {}
      }
    };

    try {
      // Sending the FCM notification
      final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey', // Use the server key
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
      //  print('Notification sent successfully to fcm id :$fcmToken.');
      } else {
        print('Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the HTTP request
      print('Error sending FCM notification: $e');
    }
  }


  @override
  void onClose() {
    //Todo must be delete fcm token on user account
    _firebaseMessaging.deleteToken();
    fcmToken = null;
    Get.delete<LocalNotificationController>();
    messageStream?.cancel();
    super.dispose();
  }
}

//function to liston foreground changes both are globle functions
void _firebaseForegoundMessage(RemoteMessage message) {
  if (message.notification != null) {
    LocalNotificationController.instance.showLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: jsonEncode(message.data));
  }
}

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
   // print('some notification Recived');
  } else {
    print('some message recived');
  }
}
