import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/dashbaord/screens/widgets/skill_badges.dart';
import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../Models/Child.dart';
import '../../../Models/letters_seed.dart';
import '../../../utiles/Constant/helper_funciton.dart';
import '../../../utiles/Widgets/arabic_progress_bar.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';

class ChildDashboardScreen extends StatefulWidget {
  const ChildDashboardScreen({super.key});

  @override
  State<ChildDashboardScreen> createState() => _ChildDashboardScreenState();
}

class _ChildDashboardScreenState extends State<ChildDashboardScreen> {
  final data = Get.find<NamouFirebaseDataController>();
  // ---- Difficulty state (0: سهل, 1: متوسط, 2: صعب)
  // ⬇️ ADD THESE (move from inside build)
  final RxString nameError = ''.obs;
  final RxString ageError = ''.obs;




  // simple avatar catalog (replace with your real assets)
  final List<String> _avatarChoices = const [
    'assets/avatars/1.png',
    'assets/avatars/2.png',
    'assets/avatars/3.png',
    'assets/avatars/4.png',
  ];

  final _nameCtrl = TextEditingController();
  final _studentAge = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _studentAge.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final childId = data.selectedChildId.value;
    if (childId != null) {
      final child = data.children[childId];
      if (child != null) {
        _nameCtrl.text = child.name.trim();
        _studentAge.text = child.age.toString().trim();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
      Obx(
              ()=> GrayscaleWidget(
              isGrayscale: !data.isOnline.value,
              isAbsorb: false,

              child:
      Obx(() {
      final childId = data.selectedChildId.value;


      if (childId == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('لوحة التحكم')),
          body: const Center(child: Text('لم يتم اختيار طفل')),
        );
      }

      final child = data.children[childId];

      if (child == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('لوحة التحكم')),
          body:     const Center(child: CircularProgressIndicator( color: Colors.orange,strokeWidth: 5,)),
        );
      }
     String difficulty=child.difficulty;


      final pts = data.selectedChildPoints;
      final total = data.totalPossiblePoints; // 112
      final prog = data.selectedChildProgress01;

      final levelTitle = titleForPoints(pts, total);

      final passedSeeds = _passedLetterSeeds(child);
      final learnedWords = passedSeeds.map((s) => s.pronunciationWord).toList();

      return Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== Child info card (edit name + avatar) =====
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () =>
                          _pickAvatar(childId, current: child.avatarPath!),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: size.width * 0.09,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: child.avatarPath!.isNotEmpty
                                ? AssetImage(child.avatarPath!) as ImageProvider
                                : null,
                            child: child.avatarPath!.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: size.width * 0.9,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.width * 0.02),
                            child: CircleAvatar(
                              radius: size.width * 0.02,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Text(
                    child.name,
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معلومات الحساب الشخصي (الطفل)',
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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

                            TextField(
                              controller: _nameCtrl,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: 'اكتب اسم الطفل',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Gray border when not focused
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(
                                      2,
                                      48,
                                      71,
                                      1,
                                    ), // Gray border when focused
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01,
                                  vertical: size.height * 0.01,
                                ),
                                errorText: nameError.value.isEmpty
                                    ? null
                                    : nameError.value.tr,
                              ),
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                            ),
                            const SizedBox(height: 12),
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
                            TextField(
                              // obscureText: authController.isPasswordVisible.value,
                              // obscuringCharacter: '*',
                              controller: _studentAge,

                              // Arabic text direction
                              decoration: InputDecoration(
                                hintText: '7'.tr,

                                hintStyle: TextStyle(
                                  color: Colors.grey, // Gray hint text
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Gray border when not focused
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(
                                      2,
                                      48,
                                      71,
                                      1,
                                    ), // Gray border when focused
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01,
                                  vertical: size.height * 0.01,
                                ),
                                errorText: ageError.value.isEmpty
                                    ? null
                                    : ageError.value.tr,
                              ),
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                            ),

                            DifficultySlider(difficulty: difficulty,
                              callback:   (int value){

                               difficulty = difficultyLabelAr(value);
                                }
                            ),

                            SizedBox(height: size.height * 0.03),
                            ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus(); // hides keyboard

                                // reset errors
                                nameError.value = '';
                                ageError.value = '';

                                // 🔹 trim name once
                                final newName = _nameCtrl.text.trim();

                                if (newName.length < 2) {
                                  nameError.value = "name.length.min";
                                  return;
                                }
                                if (newName.length > 26) {
                                  nameError.value = "name.length.max";
                                  return;
                                }

                                var birthYear = _studentAge.text.trim();
                                if (birthYear.isEmpty || int.tryParse(birthYear) == null) {
                                  ageError.value = "birth.year.invalid";
                                  return;
                                }
                                var age = int.parse(birthYear);



                                Get.dialog(
                                  const Center(child: CircularProgressIndicator( color: Colors.orange,strokeWidth: 5,)),
                                  barrierDismissible: false,
                                );


                                await data.updateChildProfile(
                                  childId: childId,
                                  name: newName,
                                  age:  age,
                                  difficulty: difficulty, // 'سهل' | 'متوسط' | 'صعب'
                                );
                                if (Get.isDialogOpen ?? false) {
                                  Get.back();
                                }
                                Get.snackbar('تم الحفظ', 'تم تحديث اسم الطفل');
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF58CC02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'حفظ التغييرات',
                                style: TextStyle(fontSize: size.width * 0.06),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ===== Overview =====
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'نظرة عامة',
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.shade300),

                      // Level title + points

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _badge(text: levelTitle, color: Colors.orange),
                      //     _badge(
                      //       text: '$pts النقاط',
                      //       color: Colors.amber.shade700,
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 16),
                      _sectionHeader(
                        'مستوى التقدم للطفل(${child.name} )',
                        size,
                        color:Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      // Overall progress bar (uses your ArabicProgressBar)
                      ArabicProgressBar(
                        progressValue: prog,
                        levelText: levelTitle,
                        points: pts,
                      ),

                      const SizedBox(height: 16),
                      _sectionHeader(
                        'الشارات التي حصل عليها الطفل(${child.name})',
                        size,
                        color:Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      SkillBadges(current: levelTitle,),
                      // Letters passed
                      const SizedBox(height: 16),
                      _sectionHeader(
                        'الأحرف التي تعلمها الطفل (${passedSeeds.length} حرفان)',
                        size,
                        color:Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      // Wrap(
                      //   spacing: 8,
                      //   runSpacing: 8,
                      //   children: passedSeeds.isEmpty
                      //       ? [const Text('لم يتم إكمال أي حرف بعد')]
                      //       : passedSeeds
                      //             .map((s) => _letterPill(s.glyph, size))
                      //             .toList(),
                      // ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: passedSeeds.isEmpty
                            ? [const Text('لم يتم إكمال أي حرف بعد')]
                            : passedSeeds.map((s) {
                          final lp = child.levels[s.id];
                          final letterAttempts =
                              lp?.parts[kPartLetterPronunciation]?.attempts ?? 0;
                          return _letterPill(s.glyph, size, letterAttempts);
                        }).toList(),
                      ),


                      const SizedBox(height: 16),

                      // Words learned (from passed letters' main words)
                      _sectionHeader(
                        'الكلمات التي تعلمها الطفل (${learnedWords.length} كلمات)',
                        size,
                        color:Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      // Wrap(
                      //   spacing: 8,
                      //   runSpacing: 8,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   alignment: WrapAlignment.center,
                      //   children: learnedWords.isEmpty
                      //       ? [const Text('لا توجد كلمات مكتملة بعد')]
                      //       : learnedWords
                      //             .map((w) => _wordPill(w.ar, size))
                      //             .toList(),
                      // ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: passedSeeds.isEmpty
                            ? [const Text('لا توجد كلمات مكتملة بعد')]
                            : passedSeeds.map((s) {
                          final lp = child.levels[s.id];
                          final wordAttempts =
                              lp?.parts[kPartWordPronunciation]?.attempts ?? 0;
                          final w = s.pronunciationWord;
                          return _wordPill(w.ar, size, wordAttempts);
                        }).toList(),
                      ),

                      const SizedBox(height: 16),
                      // Words learned (from passed letters' main words)
                      _sectionHeader(
                        'الكلمات المزدوجة مع الصورة المقابلة التي تعلمها الطفل (${learnedWords.length} كلمات)',
                        size,
                        color:Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      // Wrap(
                      //   spacing: 8,
                      //   runSpacing: 8,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   alignment: WrapAlignment.center,
                      //   children: learnedWords.isEmpty
                      //       ? [const Text('لا توجد كلمات مكتملة بعد')]
                      //       : learnedWords
                      //             .map(
                      //               (w) =>
                      //                   _wordAndImagePill(w.ar, w.emoji, size,),
                      //             )
                      //             .toList(),
                      // ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: passedSeeds.isEmpty
                            ? [const Text('لا توجد كلمات مكتملة بعد')]
                            : passedSeeds.map((s) {
                          final lp = child.levels[s.id];
                          final quizAttempts = lp?.parts[kPartQuiz]?.attempts ?? 0;
                          final w = s.pronunciationWord;
                          return _wordAndImagePill(w.ar, w.emoji, size, quizAttempts);
                        }).toList(),
                      ),

                      // Optional: image-pairing words (quiz passed)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }),),);
  }

  // ------- helpers -------

  List<LetterSeed> _passedLetterSeeds(Child child) {
    return kLetterSeeds.where((s) {
      final st = child.levels[s.id]?.status;
      // your model uses LetterStatus enum; fall back to string if needed
      if (st is LetterStatus) return st == LetterStatus.passed;
      if (st is String) return st == 'passed';
      return false;
    }).toList();
  }

  Widget _sectionHeader(String text, Size size, {Color color=Colors.black}) => Text(
    text,
    textAlign: TextAlign.start,
    style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.w700,color: color),
  );

  Widget _badge({required String text, required Color color}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(32),
      border: Border.all(color: color, width: 1),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w700),
    ),
  );

  // Widget _letterPill(String glyph, Size size) => Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     border: Border.all(color: const Color(0xFFE5E5E5)),
  //     boxShadow: const [
  //       BoxShadow(
  //         color: Color(0x11000000),
  //         blurRadius: 4,
  //         offset: Offset(0, 2),
  //       ),
  //     ],
  //   ),
  //   child: Text(
  //     glyph,
  //     style: TextStyle(
  //       fontSize: size.width * 0.06,
  //       fontWeight: FontWeight.bold,
  //       color: _textColorFor(glyph),
  //     ),
  //   ),
  // );
  Widget _letterPill(String glyph, Size size, int attempts) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E5E5)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          glyph,
          style: TextStyle(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: _textColorFor(glyph),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'عدد المحاولات: $attempts',
          style: TextStyle(
            fontSize: size.width * 0.035,
            color: Colors.grey[700],
          ),
        ),
      ],
    ),
  );

  // Widget _wordAndImagePill(String ar, String emoji, Size size) => Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     border: Border.all(color: const Color(0xFFE5E5E5)),
  //     boxShadow: const [
  //       BoxShadow(
  //         color: Color(0x11000000),
  //         blurRadius: 4,
  //         offset: Offset(0, 2),
  //       ),
  //     ],
  //   ),
  //   child: Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Text(
  //         ar,
  //         style: TextStyle(
  //           fontSize: size.width * 0.06,
  //           fontWeight: FontWeight.w600,
  //           color: _textColorFor(ar),
  //         ),
  //       ),
  //       SizedBox(width: 2),
  //       Text(emoji, style: TextStyle(fontSize: size.width * 0.1)),
  //       const SizedBox(width: 6),
  //     ],
  //   ),
  // );
  Widget _wordAndImagePill(String ar, String emoji, Size size, int attempts) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ar,
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.w600,
                    color: _textColorFor(ar),
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  emoji,
                  style: TextStyle(fontSize: size.width * 0.1),
                ),
                const SizedBox(width: 6),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'عدد المحاولات: $attempts',
              style: TextStyle(
                fontSize: size.width * 0.035,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );

  // Widget _wordPill(String ar, Size size) => Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(12),
  //     border: Border.all(color: const Color(0xFFE5E5E5)),
  //     boxShadow: const [
  //       BoxShadow(
  //         color: Color(0x11000000),
  //         blurRadius: 4,
  //         offset: Offset(0, 2),
  //       ),
  //     ],
  //   ),
  //   child: Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Text(
  //         ar,
  //         style: TextStyle(
  //           fontSize: size.width * 0.06,
  //           fontWeight: FontWeight.w600,
  //           color: _textColorFor(ar),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  Widget _wordPill(String ar, Size size, int attempts) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E5E5)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ar,
          style: TextStyle(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.w600,
            color: _textColorFor(ar),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'عدد المحاولات: $attempts',
          style: TextStyle(
            fontSize: size.width * 0.035,
            color: Colors.grey[700],
          ),
        ),
      ],
    ),
  );

  Future<void> _pickAvatar(String childId, {required String current}) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _avatarChoices.map((a) {
              final isSelected = a == current;
              return GestureDetector(
                onTap: () async {
                  Get.dialog(
                    const Center(child:      Center(child: CircularProgressIndicator( color: Colors.orange,strokeWidth: 5,)),),
                    barrierDismissible: false,
                  );
                  await data.updateChildProfile(
                    childId: childId,
                    avatarAsset: a,
                  );
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                  if (mounted) Get.back();
                  Get.snackbar('تم الحفظ', 'تم تحديث صورة الطفل');
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleAvatar(radius: 36, backgroundImage: AssetImage(a)),
                    if (isSelected)
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Simple palette (tweak as you like)
  final List<Color> _palette = const [
    Color(0xFFEF476F),
    Color(0xFF06D6A0),
    Color(0xFF118AB2),
    Color(0xFFFFA500),
    Color(0xFF9B5DE5),
    Color(0xFF00BBF9),
  ];

  // Deterministic “random” color based on glyph
  Color _textColorFor(String seed) {
    // hash -> index
    final hash = seed.runes.fold<int>(0, (a, b) => (a + b) & 0x7fffffff);
    return _palette[hash % _palette.length];
  }
}

class DifficultySlider extends StatefulWidget {
  DifficultySlider({super.key,required this.difficulty,required this.callback});
  String difficulty = 'سهل';
  final Function callback;

  @override
  State<DifficultySlider> createState() => _DifficultySliderState();
}

class _DifficultySliderState extends State<DifficultySlider> {
  double d=0;
  @override
  void initState() {
    d=  difficultyFromString(widget.difficulty).toDouble();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Column(
    children: [  SizedBox(height: size.height * 0.02),

      // Label + current value
      SizedBox(height: size.height * 0.02),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'درجة الصعوبة',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: size.width * 0.040,
              color: const Color.fromRGBO(2, 48, 71, 1),
            ),
          ),
          Text(
            difficultyLabelAr(d.round()),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: size.width * 0.040,
              color: Colors.orange, // golden label
            ),
          ),
        ],
      ),

      Container(
        margin: const EdgeInsets.only(top: 6, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1), // show border
          borderRadius: BorderRadius.circular(12),
        ),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4, // thinner track
            activeTrackColor:  Colors.orange, // golden
            inactiveTrackColor: Colors.amber.withOpacity(0.3),
            thumbColor:  Colors.orange,
            overlayColor: Colors.amber.withOpacity(0.15),
            valueIndicatorColor:  Colors.orange,
          ),
          child: Slider(
            min: 0,
            max: 2,
            divisions: 2,
            value:d,
            label: difficultyLabelAr(d.round()),
            onChanged: (v) {setState(() => d = v);
              widget.callback(v.round());

              } ,
          ),
        ),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('سهل'),
          Text('متوسط'),
          Text('صعب'),
        ],
      ),
   ] );
  }
}

/// Read-only level badges: 'مبتدئ' | 'متوسط' | 'ماهر'
