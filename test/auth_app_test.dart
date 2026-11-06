import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_app/controllers/auth_controller.dart';
import 'package:student_auth_app/models/user_model.dart';
import 'package:student_auth_app/repositories/auth_repository.dart';
import 'package:student_auth_app/views/auth/login_page.dart';

class FakeAuthRepository implements AuthRepository {
  String? _generatedResetCode;

  @override
  String? get generatedResetCode => _generatedResetCode;

  @override
  Future<UserModel> login(LoginRequest request) async => UserModel(
        id: '1',
        fullName: 'طالب',
        academicId: request.identifier,
        email: 'student@univ.edu',
      );

  @override
  Future<bool> register(RegisterRequest request) async => true;

  @override
  Future<bool> sendPasswordResetCode(String identifier) async {
    final random = Random();
    _generatedResetCode = (100000 + random.nextInt(900000)).toString();
    return true;
  }

  @override
  Future<bool> resetPassword(String otp, String newPassword) async {
    if (_generatedResetCode == null) return false;
    if (otp.trim() != _generatedResetCode) return false;
    _generatedResetCode = null;
    return true;
  }
}

void main() {
  testWidgets('login page displays Arabic labels and actions', (tester) async {
    final controller = AuthController(repository: FakeAuthRepository());

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: LoginPage(controller: controller),
      ),
    );

    expect(find.text('تسجيل الدخول'), findsAtLeastNWidgets(1));
    expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);
  });

  test('reset password code is generated and validated correctly', () async {
    final repository = FakeAuthRepository();
    final controller = AuthController(repository: repository);

    final sent = await controller.sendPasswordResetCode('student@univ.edu');

    expect(sent, isTrue);
    expect(controller.generatedResetCode, isNotNull);
    expect(controller.generatedResetCode!.length, 6);
    expect(await controller.resetPassword(controller.generatedResetCode!, 'NewPass123'), isTrue);
    expect(await controller.resetPassword('000000', 'NewPass123'), isFalse);
  });
}
