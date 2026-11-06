import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';

class ResetPasswordPage extends StatefulWidget {
  final AuthController controller;

  const ResetPasswordPage({super.key, required this.controller});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.controller.resetPassword(
        _otpController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('تم التحديث بنجاح'),
              ],
            ),
            content: const Text('تم تحديث كلمة المرور بنجاح. سيتم توجيهك إلى شاشة تسجيل الدخول.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('تسجيل الدخول'),
              ),
            ],
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.controller.errorMessage ?? 'رمز التحقق غير صحيح.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحديث كلمة المرور')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.controller.generatedResetCode != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Text(
                          'رمز التحقق المرسل: ${widget.controller.generatedResetCode}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'رمز التحقق (OTP)',
                        prefixIcon: Icon(Icons.pin),
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      validator: FormValidators.validateOTP,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        helperText: '8 أحرف على الأقل، مع رقم وحرف كبير.',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: FormValidators.validateStrongPassword,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور الجديدة',
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => FormValidators.validateConfirmPassword(val, _passwordController.text),
                    ),
                    const SizedBox(height: 24),
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
                          : const Text('تحديث كلمة المرور', style: TextStyle(fontSize: 16)),
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
