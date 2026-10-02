import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar_SA': {

      ////////////shared text

      'network.timeout': "انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت.",

      /////////////////////welcome screen text
      'welcome.hello': 'مرحبا',
      'welcome.welcome': 'مرحبا بك في نمو!',
      'switch': 'تبديل اللغة',
      'welcome.description':'تطبيق "نمو" هو تطبيق تعليمي للأطفال يستخدم الذكاء الاصطناعي مع ميزات تفاعلية.',
      'welcome.createAccount':'إنشاء حساب',
       'welcome.login':'تسجيل الدخول',
///////////////////////////home page text
      "ready.title.default": "مرحباً، هل أنت مستعد لتعلم حرف جديد اليوم؟",
      "ready.title.prefix": "مرحباً",
      "ready.title.suffix": "، هل أنت مستعد لتعلم حرف جديد اليوم؟",



          'ready.yes': 'أنا مستعد',

      'ready.no': 'ليس الآن',

      'ready.points': 'النقاط',
      'ready.level.beginner': 'مبتدئ',

      'ready.level.master': 'خبير',

      'ready.level.skillful': 'ماهر',

      'ready.level.eminent': 'متميز',

//////////////level one  text
      'level1.pronounce.step1': 'مرحباً أحمد الخطوة 1',
      'level1.pronounce.step2': 'ألف',
      'level1.pronounce.repeat': 'مرة أخرى:',
      'level1.pronounce.instruction': 'جرّب نطق الحرف الذي تعلمته...',
      'level.pronounce.word.instruction': 'جرب نطق الكلمة الذي تعلمتها',
      'level1.pronounce.listening': 'أنا استمع إليك',
////////////// sign Up text
      'signup.title': 'إنشاء حساب جديد',

      'signup.name': 'الاسم',
      'signup.name.hint': 'نايف عبد الرحمن',

      'signup.email': 'البريد الإلكتروني',
  'signup.email.hint':'ali123@gmail.com',

      'signup.password': 'كلمة المرور الجديدة',
      'signup.confirm.password': 'تأكيد كلمة المرور الجديدة',

      'signup.birthYear': 'تاريخ الميلاد',

      'signup.createAccount': 'إنشاء حساب',

      'signup.haveAccount': 'هل لديك حساب مسبق؟',

      'signup.login': 'تسجيل دخول',

      ////////////signUp error

      'name.empty': "الاسم لا يمكن أن يكون فارغًا",
      'email.in.use': "البريد الإلكتروني مستخدم بالفعل",
      'password.weak': "كلمة المرور ضعيفة جدًا",
      'birth.year.invalid': "الرجاء إدخال سنة صحيحة",
      'email.invalid': "الرجاء إدخال بريد إلكتروني صحيح",
      "password.length": "يجب أن تحتوي كلمة المرور على ٦ أحرف على الأقل.",
      'password.mismatch': 'كلمتا المرور غير متطابقتين',
      "password.number": "أضِف رقمًا واحدًا.",
      "password.special": "أضِف رمزًا خاصًا.",
      "name.length.min": "يجب أن يكون الاسم مكوّنًا من حرفين على الأقل.",
      "name.length.max": "لا يمكن أن يزيد طول الاسم عن ٢٦ حرفًا.",
      "password.length.max": "لا يمكن أن يزيد طول كلمة المرور عن ٤٥ حرفًا.",
////////////// signIn text
      'login.title': 'تسجيل الدخول',

      'login.email': 'البريد الإلكتروني',

      'login.password': 'كلمة المرور',

      'login.forgotPassword': 'هل نسيت كلمة المرور؟',

      'login.loginButton': 'تسجيل الدخول',

      'login.noAccount': 'ليس لديك حساب؟',

      'login.createAccount': 'إنشاء حساب',
      'login.password.empty': "لا يمكن ترك كلمة المرور فارغة.",
      "login.invalid.credentials": "البريد الإلكتروني أو كلمة المرور غير صحيحة",
          // email varification text
      "verification.title": "التحقق من البريد الإلكتروني",
      "verification.description": "تم إرسال رسالة تحقق إلى يرجى فتح بريدك الإلكتروني والتحقق",
      "verification.resend": "إعادة إرسال رسالة التحقق",
      "verification.sent": "تم إرسال رسالة التحقق بنجاح!",
      'error.tooManyRequests': 'تم حظر الطلبات مؤقتًا بسبب نشاط غير معتاد. يرجى المحاولة لاحقًا',
      'verification.resendIn': 'إعادة الإرسال في   ',
      'verification.backToSignup': 'العودة إلى إنشاء الحساب',

  ///////forget screen text
      'forgetPassword.title': 'نسيت كلمة المرور',
      'forgetPassword.enterEmail': 'أدخل بريدك الإلكتروني المسجل',
      'forgetPassword.resetButton': 'إعادة تعيين كلمة المرور',
      'forgetPassword.emailSent': 'تم إرسال رابط إعادة التعيين!',

      // reset screen text
      'reset.successTitle': 'تم بنجاح',
      'reset.successMessage': 'تم إرسال رسالة إعادة تعيين كلمة المرور! يرجى التحقق من بريدك.',
      'error.emailNotRegistered': 'هذا البريد الإلكتروني غير مسجل. الرجاء المحاولة مرة أخرى.',


       // level one feature letter tracing
      'level1.tracing.start':'جرب الآن كتابة الحرف الذي تعلمته',
      'level1.repeat':'إعادة',
      'button.tryAgain': 'جرّب مرة أخرى',
      'level1.complete':'اكمل',
      'level1.youGot':'لقد حصلت على',
      'level1.points':'نقطة',
      'level1.great.write':'هذا رائع , احسنت  سوف نتنقل للمرحلة التالية',
      'level1.bad.write':'كتابتك للحرف خاطئة. جرب مرة أخرى',
      'level.bad.letter.speak':'لقد نطقت الحرف بشكل غير صحيح. حاول مرة أخرى.',
      'level.bad.pronounce.word':'تطقك للكلمة خاطئ. جرب مرة أخرى',
      'level.quiz.instruction':'طابق الكلمة مع الصورة الصحيحة',
      'level.quiz.good': 'حسنًا الآن سننتقل إلى الحرف التالي',

      'level.quiz.bad': 'إجابة غير صحيحة، حاول مرة أخرى.',

      'level.part.passThisPart' : 'اجتزت هذا الجزء',
      'level.part.failThisPart' : 'لم تجتز هذا الجزء',
      ////////////////////////////////// parentn


      'parent.dashboard.start.title': 'ابدأ الآن',

      'parent.dashboard.start.whoLearning': 'دور من في التعلم اليوم؟',

      "parent.dashboard.addChild": "أضف طفلاً جديداً؟",

      ////////////add child


      'addChild.title': 'إضافة طفل',

      'addChild.name': 'الاسم',

      'addChild.age': 'العمر',

      'addChild.selectAvatar': 'اختر الأفاتار الذي تفضله',

      'addChild.addButton': 'إضافة',


    },
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    'en_US': {
      /////////////////////shared text
      "network.timeout": "Connection timeout. Please check your internet connection.",
      ///////////////welcome screen text
      'welcome.hello': 'Hello',
      'welcome': 'Welcome to Numou',
      'switch': 'Switch Language',
      'welcome.description':'The "Namu" app is an educational app for children that uses artificial intelligence with interactive features.',
       'welcome.createAccount':'Create an account',
      'welcome.login':'Login',

      /////////////////home page text

        "ready.title.default": "Hello, are you ready to learn a new letter today?",
        "ready.title.prefix": "Hello",
        "ready.title.suffix": ", are you ready to learn a new letter today?",



      'ready.yes': 'I’m ready',

      'ready.no': 'Not now',

      'ready.points': 'Points',

      'ready.level.beginner': 'Beginner',
      'ready.level.master': 'Master',
          'ready.level.skillful': 'Skillful',

      'ready.level.eminent': 'Eminent',
      /////////////////level 1 text
      'level1.pronounce.step1': 'Step 1',
      'level1.pronounce.step2': 'Alif',
      'level1.pronounce.repeat': 'Again: Alif',
      'level1.pronounce.instruction': 'Try pronouncing the letter you just learned...',
      'level1.pronounce.listening': 'I’m listening to you',
      'level.quiz.bad': 'Not correct, try again.',
      ///////////////sign up text
      'signup.title': 'Create New Account',
      'signup.name': 'Name',
      'signup.name.hint': 'Naif Abdul Rahman',
      'signup.email': 'Email',
      'signup.email.hint':'ali123@gmail.com',
      'signup.password': 'Password',
      'signup.confirm.password': 'Confirm new password',
      'signup.birthYear': 'Birth Year',
      'signup.createAccount': 'Create Account',
      'signup.haveAccount': 'Already have an account?',
      'signup.login': 'Login',
      'name.empty': "Name can't be empty",
      'email.in.use': "Email already in use",
      'password.mismatch': 'Passwords do not match',
      'password.weak': "Password is too weak",
      'birth.year.invalid': "Please enter a valid age year",
      'email.invalid': "Please enter a valid email address",
      'password.length': "Password must be at least 8 characters long",
      'password.number': "Password must contain at least one number",
      'password.special': "Password must contain at least one special character",
      "name.length.min": "Name must be at least 2 characters.",
      "name.length.max": "Name cannot be longer than 26 characters.",
      "password.length.max": "Password cannot be longer than 45 characters.",

  //     signIn text
      'login.title': 'Login',

      'login.email': 'Email',

      'login.password': 'Password',

      'login.forgotPassword': 'Forgot your password?',

      'login.loginButton': 'Login',

      'login.noAccount': 'Don\'t have an account?',

      'login.createAccount': 'Create Account',
      'password.empty': "Password cannot be empty.",
      "login.invalid.credentials": "Incorrect email or password.",
      // email varification text
      "verification.title": "Email Verification",
      "verification.description": "We sent a verification email . Please open your mailbox and verify your account",
      "verification.resend": "Resend Verification Email",
      "verification.sent": "Verification email sent successfully!",
      'error.tooManyRequests': 'Too many attempts. Please try again later',
      'verification.resendIn': 'Resend in {seconds} sec',
      'verification.backToSignup': 'Back to SignUp',

      // forget screen text
      'forgetPassword.title': 'Forgot Password',
      'forgetPassword.enterEmail': 'Enter your registered email',
      'forgetPassword.resetButton': 'Reset Password',
      'forgetPassword.emailSent': 'Password reset email sent!',

      // reset screen text
      'reset.successTitle': 'Success',
      'reset.successMessage': 'Password reset email has been sent! Check your mailbox.',
      'error.emailNotRegistered': 'This email is not registered. Please try again.',




      // level one feature letter tracing
      'level1.tracing.start':'Now try writing the letter you learned.',
      'level1.repeat':'Repeat',
      'button.tryAgain': 'Try again',
      'level1.complete':'Complete',
          'level1.youGot':'you got ',
  'level1.points':'Points',
      'level1.great.write':'This is great, well done Ahmed, we will move to the next stage',
      'level1.bad.write':'You are typing the message incorrectly. Try again.',
      'level.part.passThisPart' : 'You passed this part',
      'level.part.failThisPart' : 'You failed this part',
      'level.bad.letter.speak':'You pronounced the letter incorrectly. Try again.',
/////////////////////// parent dashboard

      'parent.dashboard.start.title': 'Start Now',
      'parent.dashboard.start.whoLearning':  'Who is learning today?',
      "parent.dashboard.addChild": "Add new child?",










  'addChild.title': 'Add Child',

  'addChild.name': 'Name',

  'addChild.age': 'Age',

  'addChild.selectAvatar': 'Choose your favorite avatar',

  'addChild.addButton': 'Add',


    },
  };
}
