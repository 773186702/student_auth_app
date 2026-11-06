import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);
  Future<bool> register(RegisterRequest request);
  Future<bool> sendPasswordResetCode(String identifier);
  Future<bool> resetPassword(String otp, String newPassword);
  String? get generatedResetCode;
}
