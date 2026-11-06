class UserModel {
  final String id;
  final String fullName;
  final String academicId;
  final String email;

  UserModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    required this.email,
  });
}

class LoginRequest {
  final String identifier;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });
}

class RegisterRequest {
  final String fullName;
  final String academicId;
  final String email;
  final String password;
  final bool acceptedTerms;

  RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
    required this.acceptedTerms,
  });
}
