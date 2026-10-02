import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/dashbaord/screens/widgets/child_avatar.dart';

import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../../authentication/controllers/auth_controller.dart';

class AddChildScreen extends StatelessWidget {
  AddChildScreen({super.key});

  final _studentName = TextEditingController();
  final _studentAge = TextEditingController();
  final _selectedAvatar = 'assets/avatars/1.png'.obs; // default selection
  final _isSaving = false.obs;
  final _isValid  = false.obs; // computed from name+age


  final _avatars = const [
    'assets/avatars/1.png',
    'assets/avatars/2.png',
    'assets/avatars/3.png',
    'assets/avatars/4.png',
  ];

  final _nameError = ''.obs;
  final _ageError  = ''.obs;

  bool get _nameOk {
    final n = _studentName.text.trim().length;
    return n >= 2 && n <= 26;
  }

  bool get _ageOk {
    final s = _studentAge.text.trim();
    return s.isNotEmpty && int.tryParse(s) != null;
  }

  void _recomputeValid() => _isValid.value = _nameOk && _ageOk;
  @override
  Widget build(BuildContext context) {
    Get.put(NamouFirebaseDataController());
    var size = MediaQuery.sizeOf(context);
    var authController =Get.find<AuthController>();
    var dataController = Get.find<NamouFirebaseDataController>();
    return Obx(
          ()=> GrayscaleWidget(
          isGrayscale: !dataController.isOnline.value,
          isAbsorb: false,

          child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill,
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // NEW: Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xFF023047),
                        onPressed: () => Get.back(),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(194, 237, 251, 0.7),
                          // Light blue background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'addChild.title'.tr,
                          style: TextStyle(
                            fontSize: size.height * 0.035,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(2, 48, 71, 1),
                            // Dark blue text color
                            // Use Arabic-friendly font (optional)
                          ),
                          //  textDirection: TextDirection.rtl,
                        ),
                      ),
                      Image.asset(
                        "assets/images/numou_logo.png",
                        height: size.height * 0.13,
                        width: size.width * 0.22,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          spreadRadius: 0.0,
                          blurRadius: 2,
                          offset: Offset(0, 5), // Only bottom shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Row(
                          children: [
                            Text(
                              'addChild.name'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.040,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Obx(
                          ()=> TextField(

                            controller: _studentName,
                            onChanged: (_) {
                              final len = _studentName.text.trim().length;
                              if (len == 0) {
                                _nameError.value = '';
                              } else if (len < 2) {
                                _nameError.value = 'الاسم قصير جدًا (على الأقل 2 أحرف)';
                              } else if (len > 26) {
                                _nameError.value = 'الاسم طويل جدًا (بحد أقصى 26 حرفًا)';
                              } else {
                                _nameError.value = '';
                              }
                              _recomputeValid();
                            },
                            decoration: InputDecoration(
                              hintText: 'signup.name.hint'.tr,
                              hintStyle: TextStyle(
                                color: Colors.grey, // Gray hint text
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color:
                                  Colors.grey, // Gray border when not focused
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(2, 48, 71, 1), // Gray border when focused
                                ),

                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: size.width*0.01,
                                vertical: size.height*0.01,
                              ),
                              errorText: _nameError.value.isEmpty ? null : _nameError.value,
                              // errorText: authController.nameError.value.isEmpty
                              //     ? null
                              //     : authController.nameError.value.tr,
                            ),
                            style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),

                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Text(
                              'addChild.age'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.040,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Obx(
                              ()=> TextField(

                            // obscureText: authController.isPasswordVisible.value,
                            // obscuringCharacter: '*',
                            controller: _studentAge,
                                keyboardType: TextInputType.number,
                                // Optional: restrict to digits only
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (_) {
                                  final s = _studentAge.text.trim();
                                  if (s.isEmpty) {
                                    _ageError.value = '';
                                  } else if (int.tryParse(s) == null) {
                                    _ageError.value = 'الرجاء إدخال عمر صحيح (أرقام فقط)';
                                  } else {
                                    _ageError.value = '';
                                  }
                                  _recomputeValid();
                                },
                            // Arabic text direction
                            decoration: InputDecoration(
                              hintText: '7'.tr,

                              hintStyle: TextStyle(
                                color: Colors.grey, // Gray hint text
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color:
                                  Colors.grey, // Gray border when not focused
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(2, 48, 71, 1), // Gray border when focused
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: size.width*0.01,
                                vertical: size.height*0.01,
                              ),
                              errorText: _ageError.value.isEmpty ? null : _ageError.value,

                            ),
                            style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),

                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Text(
                              'addChild.selectAvatar'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.040,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Obx(() => Wrap(
                          spacing: 12,
                          runSpacing: 0,
                          children: _avatars.map((p) {
                            final sel = _selectedAvatar.value == p;
                            return ChildAvatar(
                              name: '',                 // no name needed at add stage
                              assetPath: p,
                              selected: sel,
                              onTap: () => _selectedAvatar.value = p,
                            );
                          }).toList(),
                        )),


                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color of the button
                            borderRadius: BorderRadius.circular(12),
                            // border: Border.all(
                            //   color: Color(0xFFE5E5E5), // Border color
                            //   width: 2, // Border thickness
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF58A700), // Shadow color
                                spreadRadius: 0.0,
                                blurRadius: 0.0,
                                offset: Offset(0, 4), // Only bottom shadow
                              ),
                            ],
                          ),
                          child: Obx(() => ElevatedButton(
                            onPressed: (_isSaving.value || !_isValid.value)
                                ? null
                                : () async {
                              // extra guard (in case)
                              if (_studentName.text.trim().isEmpty || _studentAge.text.trim().isEmpty) return;

                              _isSaving.value = true;
                              FocusScope.of(context).unfocus(); // hide keyboard
                              try {
                                await dataController.addChildUnderParent(
                                  childName: _studentName.text.trim(),
                                  age: _studentAge.text.trim(),
                                  avatarPath: _selectedAvatar.value,
                                );

                                // Clear inputs BEFORE leaving
                                _studentName.clear();
                                _studentAge.clear();
                                _isValid.value = false; // disables button after clear

                                // Pop screen
                                Get.back();
                                // Success toast
                                Get.snackbar(
                                  'تم الحفظ',
                                  'تم إضافة الطفل بنجاح',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                );

                              } catch (e) {
                                Get.snackbar('خطأ', e.toString(), snackPosition: SnackPosition.BOTTOM);
                              } finally {
                                _isSaving.value = false; // always stop spinner
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF58CC02),
                              disabledBackgroundColor: const Color(0xFF9CD77C),
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.05,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isSaving.value
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                                : Text(
                              'addChild.addButton'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.048,
                                color: Colors.white,
                              ),
                            ),
                          ))


                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.004),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/auth_character_1.png',
                      height: size.height * 0.20,
                      width: size.width * 0.32,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
