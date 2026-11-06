import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({required AuthRepository repository}) : _repository = repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  String? get generatedResetCode => _repository.generatedResetCode;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(LoginRequest request) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _repository.login(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'فشل تسجيل الدخول: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final success = await _repository.register(request);
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = 'فشل إنشاء الحساب: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetCode(String identifier) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final success = await _repository.sendPasswordResetCode(identifier);
      if (!success) {
        _errorMessage = 'تعذّر إرسال رمز التحقق.';
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = 'تعذّر إرسال رمز التحقق: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String otp, String newPassword) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      if (generatedResetCode == null) {
        _errorMessage = 'لم يتم إرسال رمز تحقق بعد.';
        _setLoading(false);
        return false;
      }

      if (otp.trim() != generatedResetCode) {
        _errorMessage = 'رمز التحقق غير صحيح.';
        _setLoading(false);
        return false;
      }

      final success = await _repository.resetPassword(otp, newPassword);
      if (!success) {
        _errorMessage = 'رمز التحقق غير صحيح أو منتهي الصلاحية.';
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = 'تعذّر تحديث كلمة المرور: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }
}
