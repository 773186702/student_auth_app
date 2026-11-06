import 'dart:async';
import 'dart:math';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  String? _generatedResetCode;

  @override
  String? get generatedResetCode => _generatedResetCode;

  String _generateResetCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: 'usr_101',
      fullName: 'أحمد محمد',
      academicId: request.identifier,
      email: '${request.identifier}@univ.edu',
    );
  }

  @override
  Future<bool> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<bool> sendPasswordResetCode(String identifier) async {
    await Future.delayed(const Duration(seconds: 2));
    _generatedResetCode = _generateResetCode();
    return true;
  }

  @override
  Future<bool> resetPassword(String otp, String newPassword) async {
    await Future.delayed(const Duration(seconds: 2));
    if (_generatedResetCode == null) {
      return false;
    }
    if (otp.trim() != _generatedResetCode) {
      return false;
    }
    _generatedResetCode = null;
    return true;
  }
}
