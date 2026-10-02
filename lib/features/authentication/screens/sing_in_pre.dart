
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numou/features/authentication/screens/reset_password.dart';
import '../controllers/auth_controller.dart';
import 'Welcome_page.dart';

class SignInPre extends StatelessWidget {
  SignInPre({super.key});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E6891),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.35,
            // Container starts in the middle
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Text(
                      'Enter your email:',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        // Light gray background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          // More rounded corners
                          borderSide: const BorderSide(
                            color: Colors.black, // Set the border color to black
                            width: 1.0, // Optionally, adjust the border width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          // More rounded corners
                          borderSide: const BorderSide(
                            color: Colors.black,
                            // Set the border color to black when focused
                            width: 1.0, // Optionally, adjust the border width
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          // More rounded corners
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            // Set the border color to black when enabled
                            width: 1.0, // Optionally, adjust the border width
                          ),
                        ),
                        hintText: 'email@domain.com',
                        hintStyle: TextStyle(
                          color: Colors.grey[
                              500], // Lighter gray for less visible hint text
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter your password:',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextField(
                        controller: passwordController,
                        obscureText:
                            AuthController.instance.isPasswordVisible.value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                AuthController.instance
                                    .togglePasswordVisibility();
                              },
                              icon: Icon(
                                AuthController.instance.isPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              )),
                          filled: true,
                          fillColor: Colors.white,
                          // Light gray background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            // Rounded corners
                            borderSide: const BorderSide(
                              color: Colors.black,
                              // Set the border color to black
                              width: 1.0, // Optionally, adjust the border width
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            // Rounded corners
                            borderSide: const BorderSide(
                              color: Colors.black,
                              // Set the border color to black when focused
                              width: 1.0, // Optionally, adjust the border width
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            // Rounded corners
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              // Set the border color to black when enabled
                              width: 1.0, // Optionally, adjust the border width
                            ),
                          ),
                          hintText: '*******************',
                          hintStyle: TextStyle(
                            color: Colors.grey[
                                500], // Lighter gray for less visible hint text
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          Get.to(ResetPassword());
                        },
                        child: Text(
                          'Forgot Password',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            shadows: [
                              Shadow(
                                offset: const Offset(-2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.2),
                              ),]
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height*0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              AuthController.instance.login(
                                  email: emailController.text,
                                  password: passwordController.text);

                              // Handle sign-in action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBCD22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    14), // Increase the borderRadius value for more rounded corners
                              ),
                              // padding: const EdgeInsets.symmetric(
                              //   horizontal: 120,
                              //   // Increase horizontal padding for a wider button
                              //   vertical:
                              //       15, // Increase vertical padding for a taller button
                              // ),
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.off(const WelcomePage()),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 16,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Don’t have an account?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFBCD22),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/elogo.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
