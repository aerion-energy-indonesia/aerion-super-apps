import 'package:aerion_dashboard/features/auth/presentation/widgets/forgot_link.dart';
import 'package:flutter/material.dart';
import '../widgets/button.dart';
import '../widgets/form_field.dart';
import '../widgets/forgot_link.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Validasi form
    if (_formKey.currentState!.validate()) {
      // Redirect ke onboarding page setelah login sukses
      Navigator.pushReplacementNamed(context, '/onboarding');
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Login successful')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF4F4F5);
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icons/hres.png',
                          height: 80,
                          width: 80,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'HRES',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF364153),
                            fontFamily: 'Michroma',
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Super App',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF364153),
                  fontFamily: 'Michroma',
                ),
              ),
            ),

            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // use form field widget
                  FormFieldWidget(
                    controller: _emailController,
                    label: 'Username or Email',
                    hintText: 'Input your username or email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // use form field widget
                  FormFieldWidget(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Input your password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // forget password text button
                  ForgotPasswordLink(
                    onPressed: () {
                      // Handle forgot password action
                    },
                  ),
                  const SizedBox(height: 24),
                  // use button widget
                  LoginButton(label: 'Login', onPressed: _login),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
