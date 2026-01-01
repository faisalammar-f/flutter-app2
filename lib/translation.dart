import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mylocal implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "ar": {
      ...authAr,
      ...authTranslation["ar"]!,
      ...sendTranslation["ar"]!,
      ...verifyEmailTranslation["ar"]!,
      ...homeTranslations["ar"]!,
      ...taskTranslations["ar"]!,
      ...incomeexpensesTranslation["ar"]!,
      ...incomeTranslation["ar"]!,
      ...expTranslations["ar"]!,
      ...taskTypeMapEnToAr,
      ...sourceTypeMapEnToAr,
      ...categoryTypeMapEnToAr,
    },
    "en": {
      ...authEn,
      ...authTranslation["en"]!,
      ...sendTranslation["en"]!,
      ...verifyEmailTranslation["en"]!,
      ...homeTranslations["en"]!,
      ...taskTranslations["en"]!,
      ...incomeexpensesTranslation["en"]!,
      ...incomeTranslation["en"]!,
      ...expTranslations["en"]!,
      ...taskTypeMap,
      ...sourceTypeMapArToEn,
      ...categoryTypeMapArToEn,
    },
  };
}

// ignore: must_be_immutable
class Lang extends StatelessWidget {
  Lang({super.key});

  final Mycon i = Get.put(Mycon());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF121212) // لون داكن
            : const Color(0xFF6A1B9A),
        title: Center(
          child: Text(
            "Settings".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "choose your Language:".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    i.changlang("ar");
                  },
                  child: Text(
                    "العربية",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    i.changlang("en");
                  },
                  child: Text(
                    "English",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Mycon extends GetxController {
  void changlang(String ch) async {
    Locale l = Locale(ch);
    Get.updateLocale(l);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', ch);
  }

  Future<String> getSavedLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang') ?? 'en';
  }
}

final Map<String, String> authAr = {
  "app_title": "الخطة الذكية",
  "email_label": "البريد الإلكتروني",
  "password_label": "كلمة المرور",
  "empty_field": "حقل فارغ",
  "invalid_email": "أدخل بريد إلكتروني صحيح",
  "login_button": "تسجيل الدخول",
  "forget_password": "نسيت كلمة المرور؟",
  "sign_up": "إنشاء حساب",
  "email_verification_sent": "📩 تم إعادة إرسال رسالة التحقق إلى بريدك.",
  "error_general": "حدث خطأ",
  "error_user_not_found": "لا يوجد حساب بهذا البريد",
  "error_wrong_password": "كلمة المرور غير صحيحة",
  "error_invalid_email": "صيغة البريد غير صحيحة",
  'الرجاء إدخال البريد الإلكتروني': 'الرجاء إدخال البريد الإلكتروني',
  'تم إرسال رابط إعادة تعيين كلمة المرور':
      'تم إرسال رابط إعادة تعيين كلمة المرور',
  'الإيميل غير صحيح أو غير مسجل': 'الإيميل غير صحيح أو غير مسجل',
  'حدث خطأ، يرجى إعادة تسجيل الدخول': 'حدث خطأ، يرجى إعادة تسجيل الدخول',
  'تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني':
      'تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني',
  'حدث خطأ أثناء إرسال الرابط': 'حدث خطأ أثناء إرسال الرابط',
  "change password": "تغيير كلمة المرور",
  "Send": "يرسل",
  "اختر رسالة أولاً للرد عليها": "اختر رسالة أولاً للرد عليها",
  "Write your message here": "اكتب رسالتك هنا",
  "🗑️ تم حذف الرسالة بنجاح": "🗑️ تم حذف الرسالة بنجاح",
  "✅ تم تعديل الرسالة بنجاح": "✅ تم تعديل الرسالة بنجاح",
  "الرسالة": "الرسالة",
  "تعديل / حذف الرسالة": "تعديل / حذف الرسالة",
  "لا توجد رسائل حاليا": "لا توجد رسائل حاليا",
  "Message me": "راسلني",
  "Users": "المستخدمون",
  "• Categorize expenses (food, transport, books, etc.).":
      "• تصنيف النفقات (الطعام، المواصلات، الكتب، إلخ).",
  "No data": "لا توجد بيانات",
  "No financial data recorded.": "لم يتم تسجيل أي بيانات مالية.",
  "Add income and expenses to see insights.":
      "أضف الإيرادات والمصروفات للاطلاع على النتائج.",
};

final Map<String, String> authEn = {
  "app_title": "Smart Plan",
  "email_label": "Email",
  "password_label": "Password",
  "empty_field": "Empty field",
  "invalid_email": "Enter a valid email",
  "login_button": "Login",
  "forget_password": "Forget Password?",
  "sign_up": "Sign Up",
  "email_verification_sent": "📩 Verification email sent to your inbox.",
  "error_general": "An error occurred",
  "error_user_not_found": "No user found with this email",
  "error_wrong_password": "Incorrect password",
  "error_invalid_email": "Invalid email format",
  'الرجاء إدخال البريد الإلكتروني': 'Please enter your email address.',
  'تم إرسال رابط إعادة تعيين كلمة المرور':
      'A password reset link has been sent',
  'الإيميل غير صحيح أو غير مسجل':
      'The email address is invalid or not registered',
  'حدث خطأ، يرجى إعادة تسجيل الدخول': 'An error occurred, please log in again.',
  'تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني':
      'A password change link has been sent to your email.',
  'حدث خطأ أثناء إرسال الرابط': 'An error occurred while sending the link.',
  "change password": "change password",
  "Send": "Send",
  "اختر رسالة أولاً للرد عليها": "Choose a message first to reply to",
  "Write your message here": "Write your message here",
  "🗑️ تم حذف الرسالة بنجاح": "🗑️ The message was successfully deleted",
  "✅ تم تعديل الرسالة بنجاح": "✅ Message successfully edited",
  "الرسالة": "message",
  "تعديل / حذف الرسالة": "Edit/Delete Message",
  "لا توجد رسائل حاليا": "No messages at the moment",
  "Message me": "Message me",
  "Users": "Users",
  "• Categorize expenses (food, transport, books, etc.).":
      "• Categorize expenses (food, transport, books, etc.).",
  "No data": "No data",
  "No financial data recorded.": "No financial data recorded.",
  "Add income and expenses to see insights.":
      "Add income and expenses to see insights.",
};
final Map<String, Map<String, String>> authTranslation = {
  "en": {
    "Sign Up": "Sign Up",
    "Full Name": "Full Name",
    "Email": "Email",
    "Password": "Password",
    "Confirm Password": "Confirm Password",
    "Phone Number": "Phone Number",
    "Date of Birth": "Date of Birth",
    "Gender": "Gender",
    "Male": "Male",
    "Female": "Female",

    "empty field": "empty field",
    "Enter a valid email (e.g. name@example.com)":
        "Enter a valid email (e.g. name@example.com)",
    "Password cannot be empty": "Password cannot be empty",
    "Password must be at least 8 characters":
        "Password must be at least 8 characters",
    "Must contain at least 1 uppercase letter":
        "Must contain at least 1 uppercase letter",
    "Must contain at least 1 number": "Must contain at least 1 number",
    "Must contain at least 1 special character (!@#\$&*~)":
        "Must contain at least 1 special character (!@#\$&*~)",
    "Password does not match": "Password does not match",
    "phone number cannot be empty": "phone number cannot be empty",
    " cannot be empty": " cannot be empty",

    "Sign Up & Verify": "Sign Up & Verify",
  },
  "ar": {
    "Sign Up": "إنشاء حساب",
    "Full Name": "الاسم الكامل",
    "Email": "البريد الإلكتروني",
    "Password": "كلمة المرور",
    "Confirm Password": "تأكيد كلمة المرور",
    "Phone Number": "رقم الهاتف",
    "Date of Birth": "تاريخ الميلاد",
    "Gender": "الجنس",
    "Male": "ذكر",
    "Female": "أنثى",

    "empty field": "الحقل فارغ",
    "Enter a valid email (e.g. name@example.com)":
        "أدخل بريدًا إلكترونيًا صالحًا",
    "Password cannot be empty": "لا يمكن أن تكون كلمة المرور فارغة",
    "Password must be at least 8 characters":
        "يجب أن تكون كلمة المرور 8 أحرف على الأقل",
    "Must contain at least 1 uppercase letter":
        "يجب أن تحتوي على حرف كبير واحد على الأقل",
    "Must contain at least 1 number": "يجب أن تحتوي على رقم واحد على الأقل",
    "Must contain at least 1 special character (!@#\$&*~)":
        "يجب أن تحتوي على رمز خاص واحد على الأقل (!@#\$&*~)",
    "Password does not match": "كلمة المرور غير متطابقة",
    "phone number cannot be empty": "لا يمكن أن يكون رقم الهاتف فارغًا",
    " cannot be empty": "لا يمكن أن يكون فارغًا",

    "Sign Up & Verify": "إنشاء حساب وتأكيده",
  },
};

final Map<String, Map<String, String>> sendTranslation = {
  "en": {
    "Email Verification": "Email Verification",
    "⏳ يرجى الانتظار قبل إعادة الإرسال مرة أخرى.":
        "⏳ Please wait before resending again.",
    "📩 تم إرسال رسالة التحقق إلى": "📩 Verification email sent to",
    "✅ البريد مفعّل مسبقًا": "✅ Email already verified",
    "❌ خطأ: ": "❌ Error: ",
    "Register/Sign In & Verify Email": "Register/Sign In & Verify Email",
  },
  "ar": {
    "Email Verification": "التحقق من البريد الإلكتروني",
    "⏳ يرجى الانتظار قبل إعادة الإرسال مرة أخرى.":
        "⏳ يرجى الانتظار قبل إعادة الإرسال مرة أخرى.",
    "📩 تم إرسال رسالة التحقق إلى": "📩 تم إرسال رسالة التحقق إلى",
    "✅ البريد مفعّل مسبقًا": "✅ البريد مفعّل مسبقًا",
    "❌ خطأ: ": "❌ خطأ: ",
    "Register/Sign In & Verify Email": "تسجيل/تسجيل دخول وتأكيد البريد",
  },
};
final Map<String, Map<String, String>> verifyEmailTranslation = {
  "en": {
    "Email Verification": "Email Verification",
    "📩 تحقق من بريدك الإلكتروني ثم اضغط على الزر أدناه.":
        "📩 Check your email then press the button below.",
    "✅ تم التحقق من البريد بنجاح!": "✅ Email verified successfully!",
    "❌ البريد لم يتم تفعيله بعد. تحقق من الرسالة المرسلة.":
        "❌ Email not verified yet. Check the sent message.",
    "❌ خطأ أثناء التحقق:": "❌ Error during verification:",
    "⏳ جاري إرسال رسالة تحقق جديدة...": "⏳ Sending new verification email...",
    "📨 تم إرسال رسالة التحقق مرة أخرى إلى":
        "📨 Verification email sent again to",
    "✅ البريد مفعّل بالفعل.": "✅ Email already verified.",
    "✅ Check Verification": "✅ Check Verification",
    "📩 Resend Verification Email": "📩 Resend Verification Email",
    "⏭️ Skip": "⏭️ Skip",
  },
  "ar": {
    "Email Verification": "التحقق من البريد الإلكتروني",
    "📩 تحقق من بريدك الإلكتروني ثم اضغط على الزر أدناه.":
        "📩 تحقق من بريدك الإلكتروني ثم اضغط على الزر أدناه.",
    "✅ تم التحقق من البريد بنجاح!": "✅ تم التحقق من البريد بنجاح!",
    "❌ البريد لم يتم تفعيله بعد. تحقق من الرسالة المرسلة.":
        "❌ البريد لم يتم تفعيله بعد. تحقق من الرسالة المرسلة.",
    "❌ خطأ أثناء التحقق:": "❌ خطأ أثناء التحقق:",
    "⏳ جاري إرسال رسالة تحقق جديدة...": "⏳ جاري إرسال رسالة تحقق جديدة...",
    "📨 تم إرسال رسالة التحقق مرة أخرى إلى":
        "📨 تم إرسال رسالة التحقق مرة أخرى إلى",
    "✅ البريد مفعّل بالفعل.": "✅ البريد مفعّل بالفعل.",
    "✅ Check Verification": "✅ تحقق من التفعيل",
    "📩 Resend Verification Email": "📩 إعادة إرسال رسالة التحقق",
    "⏭️ Skip": "⏭️ تخطّي",
  },
};

final Map<String, Map<String, String>> homeTranslations = {
  "ar": {
    "Smart Plan": "الخطة الذكية",
    "Edit User Info": "تعديل معلومات المستخدم",
    "Full Name": "الاسم الكامل",
    "Email": "البريد الإلكتروني",
    "Password": "كلمة المرور",
    "Phone Number": "رقم الهاتف",
    "Date of Birth": "تاريخ الميلاد",
    "Male": "ذكر",
    "Female": "أنثى",
    "Cancel": "إلغاء",
    "Save": "حفظ",
    "Home": "الرئيسية",
    "Account": "الحساب",
    "Our Services": "خدماتنا",
    "🎯 Core Services of the App:": "🎯 الخدمات الأساسية للتطبيق:",
    "Time and Task Management": "إدارة الوقت والمهام",
    "• Create daily and weekly schedules for tasks and classes.":
        "• إنشاء جداول يومية وأسبوعية للمهام والدروس.",
    "• Add, edit, and delete tasks easily.":
        "• إضافة وتعديل وحذف المهام بسهولة.",
    "• Smart reminders for upcoming tasks and deadlines.":
        "• تذكيرات ذكية للمهام والمواعيد القادمة.",
    "• AI-powered analysis of time usage to suggest ways to improve productivity.":
        "• تحليل استخدام الوقت بالذكاء الاصطناعي لاقتراح طرق لتحسين الإنتاجية.",
    "Personal Expense Management": "إدارة المصاريف الشخصية",
    "• Record daily expenses and income.": "• تسجيل المصاريف والدخل اليومية.",
    "• Categorize expenses (food, transport, books, etc.)":
        "• تصنيف المصاريف (طعام، مواصلات، كتب، إلخ)",
    "• Display visual reports and charts of spending patterns.":
        "• عرض تقارير ورسوم بيانية عن نمط الإنفاق.",
    "• Provide intelligent financial tips to reduce expenses and manage budgets better.":
        "• تقديم نصائح مالية ذكية لتقليل المصاريف وإدارة الميزانية بشكل أفضل.",
    "Smart Reminder System": "نظام التذكير الذكي",
    "• Custom notifications for tasks, expenses, and bills.":
        "• إشعارات مخصصة للمهام والمصاريف والفواتير.",
    "• Suggest suitable times for study, rest, or focus based on user schedule.":
        "• اقتراح أوقات مناسبة للدراسة أو الراحة أو التركيز بناءً على جدول المستخدم.",
    "AI-Based Insights and Recommendations 🤖":
        "تحليلات وتوصيات بالذكاء الاصطناعي 🤖",
    "• Analyze user behavior and habits.": "• تحليل سلوك وعادات المستخدم.",
    "• Offer personalized suggestions to improve time and money management.":
        "• تقديم اقتراحات شخصية لتحسين إدارة الوقت والمال.",
    "Close": "إغلاق",
    "Contact Us": "اتصل بنا",
    "Settings": "الإعدادات",
    "Sign Out": "تسجيل الخروج",
    "Task & Time Management": "إدارة المهام والوقت",
    "Income & Expenses": "الدخل والمصروفات",
    "AI Assistant": "مساعد ذكي",
    "Tasks": "المهام",
    "Pending": "المعلقة",
    "Income": "الدخل",
    "Expenses": "المصاريف",
    "Source:": "المصدر:",
    "Amount:": "المبلغ:",
    "Date:": "التاريخ:",
    "Category:": "الفئة:",
    "Expenses vs Income": "المصاريف مقابل الدخل",
    "No data available": "لا توجد بيانات متاحة",
    "Add Task": "إضافة مهمة",
    "Add Income": "إضافة دخل",
    "Add Expense": "إضافة مصروف",
    "تم انجاز المهمة": "تم إنجاز المهمة",
    "إعدادات": "Settings",
    "choose your Language:": "اختر لغتك:",
    "change password": "تغيير كلمة المرور",
    "Calendar": "التقوبم",
    "There are no tasks currently": "لا توجد مهام حاليا",
    "Deadline:": ":الموعدالنهائي",
    "Task Today": "مهمة اليوم",
    "Smart Insights for you": "رؤى ذكية لك",
    "based on your recent tasks and spending , here are personalized tips: ":
        "بناءً على مهامك ونفقاتك الأخيرة، إليك بعض النصائح الشخصية: ",
    "Get New Suggestions": "احصل على اقتراحات جديدة",
    "No summary found": "لم يتم العثور على ملخص",
    "💰Total Income:": "إجمالي الدخل:",
    "📉 Total Expenses:": "📉 إجمالي المصاريف:",
    "Your financial report:": "تقريرك المالي:",
    "📝 Summary:": "📝 ملخص:",
    "⚖️ Balance:": "⚖️ التوازن:",
    "💸 Saving Opportunity:": "💸 فرصة للتوفير:",
    "💡 Main Insight:": "💡 الفكرة الرئيسية:",
    "📊Financial Score:": "📊التقييم المالي:",
    "Unknown": "مجهول",
    "no income data available.": "لا تتوفر بيانات الدخل.",
    "Risk": "مخاطرة",
    "You have no income recorded for this month.":
        "ليس لديك أي دخل مسجل لهذا الشهر.",
    "Excellent": "ممتاز",
    "Moderate": "معتدل",
    "High risk": "عالي الخطورة",
    "No expense category data.": "لا توجد بيانات عن فئات المصاريف.",
    "Your monthly financial health is good.": "وضعك المالي الشهري جيد.",
    "Your financial situation is moderate and needs monitoring.":
        "وضعك المالي متوسط ​​ويحتاج إلى متابعة.",
    "Your expenses are high and need control.": "نفقاتك مرتفعة وتحتاج إلى ضبط.",
    ".ما قدرنا نستخرج جدول واضح من الصورة":
        ".ما قدرنا نستخرج جدول واضح من الصورة",
    ' ما قدرنا نطلع جدول واضح': ' ما قدرنا نطلع جدول واضح',

    'Import Study Schedule': "استيراد جدول دراسة",
    'Choose a table image': ' اختيار صورة الجدول',
    'اختاري صورة جدولك وشوفي النص هون': 'اختاري صورة جدولك وشوفي النص هون',
    "Add to Tasks": "إضافة إلى المهام",
  },
  "en": {
    "Smart Plan": "Smart Plan",
    "Edit User Info": "Edit User Info",
    "Full Name": "Full Name",
    "Email": "Email",
    "Password": "Password",
    "Phone Number": "Phone Number",
    "Date of Birth": "Date of Birth",
    "Male": "Male",
    "Female": "Female",
    "Cancel": "Cancel",
    "Save": "Save",
    "Home": "Home",
    "Account": "Account",
    "Our Services": "Our Services",
    "🎯 Core Services of the App:": "🎯 Core Services of the App:",
    "Time and Task Management": "Time and Task Management",
    "• Create daily and weekly schedules for tasks and classes.":
        "• Create daily and weekly schedules for tasks and classes.",
    "• Add, edit, and delete tasks easily.":
        "• Add, edit, and delete tasks easily.",
    "• Smart reminders for upcoming tasks and deadlines.":
        "• Smart reminders for upcoming tasks and deadlines.",
    "• AI-powered analysis of time usage to suggest ways to improve productivity.":
        "• AI-powered analysis of time usage to suggest ways to improve productivity.",
    "Personal Expense Management": "Personal Expense Management",
    "• Record daily expenses and income.":
        "• Record daily expenses and income.",
    "• Categorize expenses (food, transport, books, etc.)":
        "• Categorize expenses (food, transport, books, etc.)",
    "• Display visual reports and charts of spending patterns.":
        "• Display visual reports and charts of spending patterns.",
    "• Provide intelligent financial tips to reduce expenses and manage budgets better.":
        "• Provide intelligent financial tips to reduce expenses and manage budgets better.",
    "Smart Reminder System": "Smart Reminder System",
    "• Custom notifications for tasks, expenses, and bills.":
        "• Custom notifications for tasks, expenses, and bills.",
    "• Suggest suitable times for study, rest, or focus based on user schedule.":
        "• Suggest suitable times for study, rest, or focus based on user schedule.",
    "AI-Based Insights and Recommendations 🤖":
        "AI-Based Insights and Recommendations 🤖",
    "• Analyze user behavior and habits.":
        "• Analyze user behavior and habits.",
    "• Offer personalized suggestions to improve time and money management.":
        "• Offer personalized suggestions to improve time and money management.",
    "Close": "Close",
    "Contact Us": "Contact Us",
    "Settings": "Settings",
    "Sign Out": "Sign Out",
    "Task & Time Management": "Task & Time Management",
    "Income & Expenses": "Income & Expenses",
    "AI Assistant": "AI Assistant",
    "Tasks": "Tasks",
    "Pending": "Pending",
    "Income": "Income",
    "Expenses": "Expenses",
    "Source:": "Source:",
    "Amount:": "Amount:",
    "Date:": "Date:",
    "Category:": "Category:",
    "Expenses vs Income": "Expenses vs Income",
    "No data available": "No data available",
    "Add Task": "Add Task",
    "Add Income": "Add Income",
    "Add Expense": "Add Expense",
    "تم انجاز المهمة": "Task Completed",
    "choose your Language:": "choose your Language:",
    "change password": "change password",
    "Calendar": "Calendar",
    "There are no tasks currently": "There are no tasks currently",
    "Deadline:": "Deadline:",
    "Task Today": "Task Today",
    "Smart Insights for you": "Smart Insights for you",
    "based on your recent tasks and spending , here are personalized tips: ":
        "based on your recent tasks and spending , here are personalized tips: ",
    "Get New Suggestions": "Get New Suggestions",
    "No summary found": "No summary found",
    "💰Total Income:": "💰Total Income:",
    "📉 Total Expenses:": "📉 Total Expenses:",
    "Your financial report:": "Your financial report:",
    "📝 Summary:": "📝 Summary:",
    "⚖️ Balance:": "⚖️ Balance:",
    "💸 Saving Opportunity:": "💸 Saving Opportunity:",
    "💡 Main Insight:": "💡 Main Insight:",
    "📊Financial Score:": "📊Financial Score:",
    "Unknown": "Unknown",
    "no income data available.": "no income data available.",
    "Risk": "Risk",
    "You have no income recorded for this month.":
        "You have no income recorded for this month.",
    "Excellent": "Excellent",
    "Moderate": "Moderate",
    "High risk": "High risk",
    "No expense category data.": "No expense category data.",
    "Your monthly financial health is good.":
        "Your monthly financial health is good.",
    "Your financial situation is moderate and needs monitoring.":
        "Your financial situation is moderate and needs monitoring.",
    "Your expenses are high and need control.":
        "Your expenses are high and need control.",
    ".ما قدرنا نستخرج جدول واضح من الصورة":
        "We were unable to extract a clear table from the image.",
    ' ما قدرنا نطلع جدول واضح': "We couldn't come up with a clear schedule",
    'Import Study Schedule': 'Import Study Schedule',

    'Choose a table image': 'Choose a table image',
    'اختاري صورة جدولك وشوفي النص هون':
        'Choose a picture of your schedule and see the text here',
    "Add to Tasks": "Add to Tasks",
  },
};
final Map<String, Map<String, String>> taskTranslations = {
  "ar": {
    "Task Management": "إدارة المهام",
    "Task Title": "عنوان المهمة",
    "Enter task title": "أدخل عنوان المهمة",
    "Field is empty": "الحقل فارغ",
    "Task Type": "نوع المهمة",
    "Please select a type": "الرجاء اختيار نوع",
    "Due Date": "تاريخ الاستحقاق",
    "Select date & time": "اختر التاريخ والوقت",
    "Add Task": "إضافة مهمة",
    "Edit Task": "تعديل المهمة",
    "Description": "الوصف",
    "Save": "حفظ",
    "Cancel": "إلغاء",
    "Delete": "حذف",
    "تم إنجاز المهمة": "تم إنجاز المهمة",
    "Task Title:": ":عنوان المهمة",
    "Task Type:": ":نوع المهمة",
  },
  "en": {
    "Task Management": "Task Management",
    "Task Title": "Task Title",
    "Enter task title": "Enter task title",
    "Field is empty": "Field is empty",
    "Task Type": "Task Type",
    "Please select a type": "Please select a type",
    "Due Date": "Due Date",
    "Select date & time": "Select date & time",
    "Add Task": "Add Task",
    "Edit Task": "Edit Task",
    "Description": "Description",
    "Save": "Save",
    "Cancel": "Cancel",
    "Delete": "Delete",
    "تم إنجاز المهمة": "Task Done",
    "Task Title:": "Task Title:",
    "Task Type:": "Task Type:",
  },
};
Map<String, Map<String, String>> incomeexpensesTranslation = {
  "ar": {
    "Income & Expenses": "الدخل والمصاريف",
    "Income": "الدخل",
    "Expenses": "المصاريف",
  },
  "en": {
    "Income & Expenses": "Income & Expenses",
    "Income": "Income",
    "Expenses": "Expenses",
  },
};
final Map<String, Map<String, String>> incomeTranslation = {
  "ar": {
    "Source": "المصدر",
    "Amount": "المبلغ",
    "Date": "التاريخ",
    "Add Income": "إضافة دخل",
    "Recent Income": "الدخل الأخير",
    "Edit Income": "تعديل الدخل",
    "Delete": "حذف",
    "Cancel": "إلغاء",
    "Save": "حفظ",
    "Please select a type": "يرجى اختيار النوع",
    "Field is empty": "الحقل فارغ",
    "cannot be empty": "لا يمكن أن يكون فارغًا",
    "A negative value cannot be entered": "لا يجوز ادخال قيمة سالبة",
  },
  "en": {
    "Source": "Source",
    "Amount": "Amount",
    "Date": "Date",
    "Add Income": "Add Income",
    "Recent Income": "Recent Income",
    "Edit Income": "Edit Income",
    "Delete": "Delete",
    "Cancel": "Cancel",
    "Save": "Save",
    "Please select a type": "Please select a type",
    "Field is empty": "Field is empty",
    "cannot be empty": "Cannot be empty",
    "A negative value cannot be entered": "A negative value cannot be entered",
  },
};

final Map<String, Map<String, String>> expTranslations = {
  'en': {
    "Category": "Category",
    "Amount": "Amount",
    "Date": "Date",
    "Add Expense": "Add Expense",
    "Recent Expenses": "Recent Expenses",
    "Please select a category": "Please select a category",
    "Field is empty": "Field is empty",
    " cannot be empty": " cannot be empty",
    "Edit Expense": "Edit Expense",
    "Delete": "Delete",
    "Cancel": "Cancel",
    "Save": "Save",
  },
  'ar': {
    "Category": "الفئة",
    "Amount": "المبلغ",
    "Date": "التاريخ",
    "Add Expense": "إضافة مصروف",
    "Recent Expenses": "المصروفات الأخيرة",
    "Please select a category": "الرجاء اختيار فئة",
    "Field is empty": "الحقل فارغ",
    " cannot be empty": "لا يمكن أن يكون فارغًا",
    "Edit Expense": "تعديل المصروف",
    "Delete": "حذف",
    "Cancel": "إلغاء",
    "Save": "حفظ",
  },
};
Map<String, String> taskTypeMap = {
  "العمل": "Work",
  "الدراسة": "Study",
  "شخصي": "Personal",
  "وقت الفراغ": "Free time",
  "المناسبات الاجتماعية": "Social occasions",
  "حضور المحاضرات": "Attend lectures",
  "إنجاز الواجبات": "Complete assignments",
  "تحضير العروض التقديمية": "Prepare presentations",
  "تسليم التقارير": "Submit reports",
  "جلسات دراسة جماعية": "Group study sessions",
  "بحث المشروع": "Project research",
  "اجتماعات الفريق": "Team meetings",
  "التمارين اليومية": "Daily exercise",
  "تخطيط الجدول الأسبوعي": "Plan weekly schedule",
  "الاتصال بالعائلة/الأصدقاء": "Call family/friends",
  "مراجعة رسائل العمل": "Review work emails",
  "العمل على مهام التدريب": "Work on internship tasks",
};
Map<String, String> taskTypeMapEnToAr = {
  "Work": "العمل",
  "Study": "الدراسة",
  "Personal": "شخصي",
  "Free time": "وقت الفراغ",
  "Social occasions": "المناسبات الاجتماعية",
  "Attend lectures": "حضور المحاضرات",
  "Complete assignments": "إنجاز الواجبات",
  "Prepare presentations": "تحضير العروض التقديمية",
  "Submit reports": "تسليم التقارير",
  "Group study sessions": "جلسات دراسة جماعية",
  "Project research": "بحث المشروع",
  "Team meetings": "اجتماعات الفريق",
  "Daily exercise": "التمارين اليومية",
  "Plan weekly schedule": "تخطيط الجدول الأسبوعي",
  "Call family/friends": "الاتصال بالعائلة/الأصدقاء",
  "Review work emails": "مراجعة رسائل العمل",
  "Work on internship tasks": "العمل على مهام التدريب",
};
Map<String, String> sourceTypeMapArToEn = {
  "الراتب الشهري": "month salary",
  "العمل الحر": "freelance",
  "منح التفوق": "Granting excellence",
  "منح الحاجة المالية": "Financial need grants",
  "التداول": "trading",
  "الاستثمار": "investment",
  "الأعمال التجارية": "business",
  "المكافآت والبدلات": "Bonuses & Allowances",
  "الدعم العائلي": "Family support",
};
Map<String, String> sourceTypeMapEnToAr = {
  "month salary": "الراتب الشهري",
  "freelance": "العمل الحر",
  "trading": "التداول",
  "Granting excellence": "منح التفوق",
  "Financial need grants": "منح الحاجة المالية",
  "Bonuses & Allowances": "المكافآت والبدلات",
  "investment": "الاستثمار",
  "Family support": "الدعم العائلي",
  "business": "الأعمال التجارية",
};
Map<String, String> categoryTypeMapArToEn = {
  "المواصلات": "Transportation",
  "الطعام": "Food",
  "الكهرباء": "Electricity",
  "الإيجار": "Rent",
  "القرض": "Loan",
  "رسوم الدراسة والمواد": "Tuition fees and materials",
  "شخصي": "Personal",
  "المناسبات الاجتماعية": "Social occasions",
};
Map<String, String> categoryTypeMapEnToAr = {
  "Transportation": "المواصلات",
  "Tuition fees and materials": "رسوم الدراسة والمواد",
  "Food": "الطعام",
  "Electricity": "الكهرباء",
  "Rent": "الإيجار",
  "Loan": "القرض",
  "Personal": "شخصي",
  "Social occasions": "المناسبات الاجتماعية",
};
