import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/authentication/screens/numou_welcome_screen.dart';
import 'package:numou/features/authentication/screens/sign_in.dart';
import '../../../utiles/Widgets/alert_messages_dailog.dart';
import '../../dashbaord/screens/ParentDashboard.dart';
import '../screens/email_verification.dart';
import '../services/google_Service.dart';
class AuthController extends GetxController {
  var isUserAlreadyLogin = false;
  bool isParent = true;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  Timer? _userVerificationTimer;
  var isResendButtonEnabled = false.obs;
  Timer? _resendTimer;
  var resendCount = 120.obs; // 2 minutes in seconds

  void startResendTimer() {
    resendCount.value = 120;
    isResendButtonEnabled.value = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCount.value == 0) {
        isResendButtonEnabled.value = true;
        timer.cancel();
      } else {
        resendCount.value--;
        isResendButtonEnabled.value = false;
      }
    });
  }

  String timerText(int time) {
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  User? get cuser => _user.value;

  // Password visibility state
  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
 void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var nameError = ''.obs;
  var birthYearError = ''.obs;
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode birthYearFocus = FocusNode();

  // Function to clear all focus
  void clearFocus() {
    nameFocus.unfocus();
    emailFocus.unfocus();
    passwordFocus.unfocus();
    birthYearFocus.unfocus();
  }

  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value='';
    nameError.value = '';
    birthYearError.value = '';
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
    if (user == null) {
      //login page
      Get.offAll(() => NumouWelcomeScreen()); //WelcomePage());
    } else {
      //home page
      if (!user.emailVerified) {
        startUserVerificationTimer();

        Get.offAll(() => EmailVerification());
      } else {
        addUserToDatabase(user.uid);
        var key = UniqueKey();
        // print(key);

        Get.offAll(() => ParentDashboard(key: key));
      }
    }
  }

  // Function to send reset password email
  void sendResetPasswordEmail(String email) async {
    clearErrors();
    clearFocus();
    if (!isValidEmail(email)) {
      return;
    }
    // Validate email before proceeding

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
    );

    try {
      // Check if the email is registered in the database
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child(
        'users',
      );
      DatabaseEvent event = await usersRef
          .orderByChild('email')
          .equalTo(email)
          .once()
          .timeout(
            Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException("timeout");
            },
          );

      if (event.snapshot.exists) {
        // Email is registered, send the reset password email
        await auth
            .sendPasswordResetEmail(email: email)
            .timeout(
              Duration(seconds: 15),
              onTimeout: () {
                throw TimeoutException("timeout");
              },
            );
        ;

        // Dismiss the loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Closes the dialog
        }

        // Navigate back to the login page

        clearErrors();
        clearFocus();
        Get.off(()=>SignIn()); // Go back to the previous page

        // Show success message in a snackbar
        Get.snackbar(
          'reset.successTitle'.tr,
          'reset.successMessage'.tr,
          backgroundColor:Color(0xFF58A700),
          colorText: Color(0xFFFFFFFF),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        // Email is not registered, show an error message
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close the loading dialog
        }
        emailError.value='error.emailNotRegistered';
       // AlertMessagesDialog.errorMessageDialog('This email is not registerd');
      }
    } on TimeoutException catch (_) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      AlertMessagesDialog.errorMessageDialog('network.timeout'.tr);
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

  void startUserVerificationTimer() {
    _userVerificationTimer?.cancel();
    resendVerificationEmail();
    _userVerificationTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
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
    _resendTimer?.cancel();
    _userVerificationTimer?.cancel();
    logOut();
  }

  Future<void> resendVerificationEmail() async {
    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Await with timeout
      await _user.value?.sendEmailVerification().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('timeout');
        },
      );

      // Success - Dismiss dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      startResendTimer(); // Optional if you need to block the button
    } on FirebaseAuthException catch (e) {
      isResendButtonEnabled.value = true;
      // Close the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (e.code == 'too-many-requests') {
        AlertMessagesDialog.errorMessageDialog('error.tooManyRequests'.tr);
      } else {
        // Handle other errors
        AlertMessagesDialog.errorMessageDialog(e.message ?? e.code);
      }
    } on TimeoutException {
      isResendButtonEnabled.value = true;
      // Close dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show timeout alert
      AlertMessagesDialog.errorMessageDialog('network.timeout'.tr);
    } catch (e) {
      isResendButtonEnabled.value = true;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Handle other errors
      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  Future<void> addUserToDatabase(String userId) async {
    final user = _user.value; // FirebaseAuth.currentUser
    if (user == null) return;

    final userRef = FirebaseDatabase.instance.ref('users/$userId');

    try {
      // 1) Check if exists
      final snap = await userRef.get();
      if (snap.exists) {
        // Already created with old/new schema — leave it as-is
        return;
      }

      // 2) Create with new schema (parent-only signup)
      await userRef.set({
        'role': 'parent',                // parent-only signup for Phase I
        'name': user.displayName ?? '',  // keep it simple
        'email': user.email ?? '',
        'childIds': {},                  // empty at start
      });
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Failed to add user: $e');
    }
  }


  void login({required String email, required String password}) async {
    clearErrors();
    clearFocus();

    // Validation: Email
    if (!isValidEmail(email)) {
      emailError.value = "email.invalid";
      emailFocus.requestFocus();
      return;
    }

    // Validation: Password
    if (password.isEmpty) {
      passwordError.value = "login.password.empty";
      passwordFocus.requestFocus();
      return;
    }

    if (password.length < 6) {
      passwordError.value = "password.length";
      passwordFocus.requestFocus();
      return;
    }

    if (password.length > 45) {
      passwordError.value = "password.length.max";
      passwordFocus.requestFocus();
      return;
    }
    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException("timeout");
            },
          );

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Login success - Next screen handled in onReady/initialScreen
    } on FirebaseAuthException catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('firebase error e');
      // Handle specific login errors
      switch (e.code) {
        case 'user-not-found':
          emailError.value = "email.not.found";
          emailFocus.requestFocus();
          break;
        case 'wrong-password':
          passwordError.value = "password.incorrect";
          passwordFocus.requestFocus();
          break;
        case 'invalid-email':
          emailError.value = "email.invalid";
          emailFocus.requestFocus();
          break;
        case 'invalid-credential':
          // Show a unified "invalid credentials" error
          emailError.value = "login.invalid.credentials";
          passwordError.value = "login.invalid.credentials";
          emailFocus.requestFocus(); // Focus on email for UX

        default:
          AlertMessagesDialog.errorMessageDialog(e.message ?? e.code);
      }
    } on TimeoutException catch (_) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      AlertMessagesDialog.errorMessageDialog('network.timeout'.tr);
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      AlertMessagesDialog.errorMessageDialog(e.toString());
    }
  }

  void register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String birthYear,
  }) async
  {
    clearErrors(); // Clear previous errors
    if (!isValidName(name)) {
      nameFocus.requestFocus();
      return;
    }
    if (!isValidEmail(email)) {
      emailFocus.requestFocus();
      return;
    }
    if (!isValidPassword(password,confirmPassword)) {
      passwordFocus.requestFocus();
      return;
    }

    if (birthYear.isEmpty || int.tryParse(birthYear) == null) {
      birthYearFocus.requestFocus();
      birthYearError.value = "birth.year.invalid";
      return;
    }

    // Show a loading dialog using GetX
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
    );

    try
    {
      // Attempt to register with email and password
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
            Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException("timeout");
            },
          );

      await userCredential.user!
          .updateDisplayName(name)
          .timeout(
            Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException("timeout");
            },
          );
      // Dismiss the loading dialog using GetX
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Closes the dialog
      }
    } on FirebaseAuthException catch (e) {
      // Close the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Map Firebase errors to form fields
      switch (e.code) {
        case 'email-already-in-use':
          emailError.value = "email.in.use";
          break;
        case 'weak-password':
          passwordError.value = "password.weak";
          break;
        default:
          AlertMessagesDialog.errorMessageDialog(e.code);
      }
    } on TimeoutException catch (_) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      AlertMessagesDialog.errorMessageDialog('network.timeout'.tr);
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

  bool isValidName(String name) {
    final n = name.trim();
    if (n.length < 2) {
      nameError.value = "name.length.min";
      return false;
    }
    if (n.length > 26) {
      nameError.value = "name.length.max";
      return false;
    }
    return true;
  }

  bool isValidEmail(String email) {
    // Regular expression to validate email format
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(email)) {
      emailError.value = "email.invalid";
      return false;
    }
    return true;
  }

  bool isValidPassword(String password, String confirmPassword) {
    // Check if password has at least 6 characters
    if (password.length < 8) {
      passwordError.value = "password.length".tr;
      return false;
    }
    // NEW: MAX 45
    if (password.length > 45) {
      passwordError.value = "password.length.max";
      return false;
    }



    // // Check if password contains at least one uppercase letter
    // if (!RegExp(r'[A-Z]').hasMatch(password)) {
    //   passwordError.value=
    //       "Password must contain at least one uppercase letter.";
    //   return false;
    // }

    // Check if password contains at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      passwordError.value = "password.number".tr;
      return false;
    }

    // Check if password contains at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      passwordError.value = "password.special".tr;
      return false;
    }
    if(password!=confirmPassword){
      confirmPasswordError.value ="password.mismatch".tr;
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
      isUserAlreadyLogin = true;
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

  /////////////////////
  // final id = await AuthController.instance.addStudentUnderParent(
  // studentName: 'Ali',
  // age: 6,
  // );
// id is the new /students/{id}





}
