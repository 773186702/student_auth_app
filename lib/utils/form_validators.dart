class FormValidators {
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال المعرّف الأكاديمي أو البريد الإلكتروني.';
    }
    if (value.trim().length < 5) {
      return 'يجب أن يكون الحقل 5 أحرف على الأقل.';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور.';
    }
    if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل.';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الاسم الكامل.';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل.';
    }
    return null;
  }

  static String? validateAcademicId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الرقم الأكاديمي.';
    }
    final regex = RegExp(r'^[0-9]{9,10}$');
    if (!regex.hasMatch(value.trim())) {
      return 'الرقم الأكاديمي يجب أن يتكون من 9 إلى 10 أرقام فقط.';
    }
    return null;
  }

  static String? validateUniversityEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الجامعي.';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'صيغة البريد الإلكتروني غير صحيحة.';
    }
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور.';
    }
    if (value.length < 8) {
      return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي على رقم واحد على الأقل.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي على حرف كبير واحد على الأقل.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور.';
    }
    if (value != password) {
      return 'كلمتا المرور غير متطابقتين.';
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رمز التحقق.';
    }
    final regex = RegExp(r'^[0-9]{6}$');
    if (!regex.hasMatch(value.trim())) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام فقط.';
    }
    return null;
  }
}
