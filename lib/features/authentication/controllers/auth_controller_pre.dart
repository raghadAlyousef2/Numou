import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:numou/features/authentication/screens/numou_welcome_screen.dart';


import '../../../utiles/Widgets/alert_messages_dailog.dart';

import '../../dashbaord/screens/home_screen.dart';
import '../screens/email_varification_pre.dart';

import '../services/google_Service.dart';


class AuthControllerPre extends GetxController {
 var isUserAlreadyLogin=false;
 bool isOwner=false;
  static AuthControllerPre instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  Timer? _verificationTimer;

  User? get cuser => _user.value;

  // Password visibility state
  var isPasswordVisible = true.obs;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // auth.authStateChanges();
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());

    ever(_user, initialScreen);
  }

  void initialScreen(User? user) {
    //print('inital screen called');
    if (user == null) {
      //login page
      Get.offAll(() =>  NumouWelcomeScreen());//WelcomePage());
      // if(isUserAlreadyLogin){
      //
      //   Timer.periodic(Duration(milliseconds: 200), (timer){
      //     print( Restart.restartApp());
      //     timer.cancel();
      //   });
      // }

    } else {
      //home page
      if (!user.emailVerified) {
        startEmailVerificationTimer();
        Get.offAll(() => const EmailVerificationScreen());
      } else {
        addUserToDatabase(user.uid ,isOwner);
      var key = UniqueKey();
     // print(key);

        Get.offAll(
          () =>   HomeScreen(key: key),
        );
      }
    }
  }

// Function to send reset password email
  void sendResetPasswordEmail(String email) async {
    if (!isValidEmail(email)) return; // Validate email before proceeding

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
    );

    try {
      // Check if the email is registered in the database
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child('users');
      DatabaseEvent event =
          await usersRef.orderByChild('email').equalTo(email).once();

      if (event.snapshot.exists) {
        // Email is registered, send the reset password email
        await auth.sendPasswordResetEmail(email: email);

        // Dismiss the loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Closes the dialog
        }

        // Navigate back to the login page
        Get.back(); // Go back to the previous page

        // Show success message in a snackbar
        Get.snackbar(
          'Success',
          'Password reset email has been sent! Check your mailbox.',
          backgroundColor: Get.theme.colorScheme.surface,
          colorText: Get.theme.colorScheme.primary,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        // Email is not registered, show an error message
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close the loading dialog
        }

        // Show error message using snackbar
        // Get.snackbar(
        //   'Error',
        //   'This email is not registered. Please try again.',
        //   backgroundColor: Get.theme.colorScheme.surface,
        //   colorText: Get.theme.colorScheme.error,
        //   snackPosition: SnackPosition.BOTTOM,
        //   duration: const Duration(seconds: 3),
        // );
        AlertMessagesDialog.errorMessageDialog('This email is not registerd');
      }
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog if there's an error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      // Show error message using the existing AlertMessagesDialog
      AlertMessagesDialog.errorMessageDialog(e.message ?? "An error occurred.");
    } catch (e) {
      // Dismiss the loading dialog if there's another error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show any other error messages
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  void startEmailVerificationTimer() {
    _verificationTimer?.cancel();
    _user.value?.sendEmailVerification();
    _verificationTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      // print('refresing user data on each 3 second ');
      await _user.value?.reload();
      var newUser = FirebaseAuth.instance.currentUser;
      if (newUser!.emailVerified) {
        // print('email is varifide now I am want to change screen');
        timer.cancel();
        _user.value = newUser;
        // _verificationTimer?.cancel();

        // initialScreen(_user.value);
      }
    });
  }

  void cancelVerification() {
    _verificationTimer?.cancel();
    logOut();
  }

  void resendVerificationEmail() {
    _user.value?.sendEmailVerification();
  }

  Future<void> addUserToDatabase(String userId, bool isOwner) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(userId);
    try {
      // Check if the user already exists in the database
      DatabaseEvent event = await userRef.once();
      if (event.snapshot.exists) {
        //  print('I am called but not add user ');
        return; // User already exists, no need to add again
      }

      if(isOwner){
        //if this user owner then  Generate share code
        String displayName = _user.value?.displayName ?? 'Unknown';
        String firstName = displayName.split(' ').first.toLowerCase(); // Extract first name
        String randomNumber = (Random().nextInt(9000) + 1000).toString(); // Generate 4-digit random number

        String shareCode = '$firstName$randomNumber';
        print('share code is $shareCode');

        await userRef.set({
          'name': _user.value?.displayName ?? 'Unknown',
          'email': _user.value?.email,
          'isOwner':isOwner.toString(),
          'shareCode': shareCode,
        });

      }else{


      await userRef.set({
        'name': _user.value?.displayName ?? 'Unknown',
        'email': _user.value?.email,
        'isOwner':isOwner.toString(),
      });

      }
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Failed to add user: $e');
    }
  }

  void login({required String email, required String password}) async {
    if (!isValidEmail(email) || !(password.length > 1)) {
      return;
    }
    // Show a loading dialog using GetX
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
    );

    try {
      // Attempt to sign in with email and password
      await auth.signInWithEmailAndPassword(email: email, password: password);

      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Closes the dialog
      }
    } on FirebaseAuthException catch (e) {
      // Close the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show an error dialog using GetX
      AlertMessagesDialog.errorMessageDialog(e.code);
    }
  }

  void register(
      {required String email,
      required String password,
      required String confirmPassword,
      required String name,
      required bool   owner,
      }) async {
    isOwner=owner;
    if (!isValidEmail(email)) {
      // AlertMessagesDialog.errorMessageDialog(
      //     "Please enter a valid email address.");
      return; // Stop if email validation fails
    } else if (!isValidPassword(password))
    {
      // AlertMessagesDialog.errorMessageDialog(
      //     "Please Enter one Capital one number character in password.");
      return; // Stop if password validation fails
    } else if (password != confirmPassword)
    {
      AlertMessagesDialog.errorMessageDialog("Passwords not match.");
      return; // Stop if passwords do not match
    } else if (name.isEmpty) {
      AlertMessagesDialog.errorMessageDialog("Name can't be empty.");
      return; // Stop if name is empty
    }

    // Show a loading dialog using GetX
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
    );

    try {
      // Attempt to register with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await userCredential.user!.updateDisplayName(name);
      // Get the user's unique ID
      // String userId = userCredential.user!.uid;
      //
      // // Update the Realtime Database with the user's name and email
      // DatabaseReference userRef =
      // FirebaseDatabase.instance.ref().child('users').child(userId);
      // userRef.set({
      //   'name': name,
      //   'email': email,
      // });

      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Closes the dialog
      }
    } on FirebaseAuthException catch (e) {
      // Close the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show an error dialog using GetX
      AlertMessagesDialog.errorMessageDialog(e.code);
    } catch (e) {
      // Show an error dialog using GetX
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  void signInWithGoogle() async {
    // Show a loading dialog using GetX
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
    );

    try {
      // Attempt to sign in with Google
      await GoogleService.signInWithGoogle();

      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Closes the dialog
      }
    } on FirebaseAuthException catch (e) {
      // Close the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show an error dialog using GetX

      AlertMessagesDialog.errorMessageDialog(e.code);
    }
  }

  bool isValidEmail(String email) {
    // Regular expression to validate email format
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(email)) {
      AlertMessagesDialog.errorMessageDialog(
          "Please enter a valid email address.");
      return false;
    }
    return true;
  }

  bool isValidPassword(String password) {
    // Check if password has at least 6 characters
    if (password.length < 6) {
      AlertMessagesDialog.errorMessageDialog(
          "Password must be at least 6 characters long.");
      return false;
    }

    // Check if password contains at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      AlertMessagesDialog.errorMessageDialog(
          "Password must contain at least one uppercase letter.");
      return false;
    }

    // Check if password contains at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      AlertMessagesDialog.errorMessageDialog(
          "Password must contain at least one number.");
      return false;
    }

    // Check if password contains at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      AlertMessagesDialog.errorMessageDialog(
          "Password must contain at least one special character.");
      return false;
    }

    return true;
  }

  void logOut() async {
    // Show a loading dialog using GetX
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
    );

    try {
      // Attempt to sign out


      await auth.signOut();
      isUserAlreadyLogin=true;
     //Get.deleteAll(force: true);
      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Closes the dialog
      }
    } catch (e) {
      // Close the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show an error dialog using GetX
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }





}
