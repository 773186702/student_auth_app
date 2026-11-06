import "package:flutter/material.dart";
import "controllers/auth_controller.dart";
import "repositories/auth_repository_impl.dart";
import "views/auth/login_page.dart";

void main() {
  runApp(const UniversityAuthApp());
}

class UniversityAuthApp extends StatefulWidget {
  const UniversityAuthApp({super.key});

  @override
  State<UniversityAuthApp> createState() => _UniversityAuthAppState();
}

class _UniversityAuthAppState extends State<UniversityAuthApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepositoryImpl();
    _authController = AuthController(repository: authRepository);
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "University Auth App",
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: LoginPage(controller: _authController),
    );
  }
}
