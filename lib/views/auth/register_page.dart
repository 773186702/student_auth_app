import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/form_validators.dart';

class RegisterPage extends StatefulWidget {
  final AuthController controller;

  const RegisterPage({super.key, required this.controller});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _showTermsError = !_acceptedTerms;
    });

    if (_formKey.currentState!.validate() && _acceptedTerms) {
      final request = RegisterRequest(
        fullName: _nameController.text.trim(),
        academicId: _academicIdController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        acceptedTerms: _acceptedTerms,
      );

      final success = await widget.controller.register(request);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الحساب بنجاح! سيتم تحويلك إلى شاشة تسجيل الدخول.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
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
                    TextFormField(
                      controller: _nameController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormValidators.validateFullName,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _academicIdController,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'الرقم الأكاديمي (9-10 أرقام)',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormValidators.validateAcademicId,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'البريد الجامعي',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormValidators.validateUniversityEmail,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
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
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => FormValidators.validateConfirmPassword(val, _passwordController.text),
                    ),
                    const SizedBox(height: 14),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _acceptedTerms,
                      onChanged: (val) {
                        setState(() {
                          _acceptedTerms = val ?? false;
                          if (_acceptedTerms) _showTermsError = false;
                        });
                      },
                      title: const Text('أوافق على اللوائح والشروط الأكاديمية.'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (_showTermsError)
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Text(
                          'يجب الموافقة على اللوائح والشروط الأكاديمية.',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
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
                          : const Text('إنشاء الحساب', style: TextStyle(fontSize: 16)),
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
