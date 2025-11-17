import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            "Settings".tr,
            style: TextStyle(fontWeight: FontWeight.bold),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  child: Text("العربية"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    i.changlang("en");
                  },
                  child: Text("English"),
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
  }
}

final Map<String, String> authAr = {
  "app_title": "Smart Plan",
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
