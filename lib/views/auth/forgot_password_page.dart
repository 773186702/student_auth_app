import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController controller;

  const ForgotPasswordPage({super.key, required this.controller});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.controller.sendPasswordResetCode(
        _identifierController.text.trim(),
      );

      if (success && mounted) {
        final code = widget.controller.generatedResetCode ?? '000000';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إرسال رمز التحقق بنجاح: $code'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(controller: widget.controller),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة المرور')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 0,
                      color: Colors.indigo.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.indigo.shade100),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.indigo, size: 30),
                            SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'أدخل البريد الإلكتروني أو الرقم الأكاديمي الخاص بك، ثم سنرسل لك رمز تحقق مكوّن من 6 أرقام لإعادة تعيين كلمة المرور.',
                                style: TextStyle(color: Colors.indigo, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _identifierController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني أو الرقم الأكاديمي',
                        prefixIcon: Icon(Icons.person_search),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormValidators.validateIdentifier,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: widget.controller.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: widget.controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('إرسال رمز التحقق', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('العودة لتسجيل الدخول'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
