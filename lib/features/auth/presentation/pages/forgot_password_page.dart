import 'package:flutter/material.dart';
import 'package:aerion_dashboard/features/auth/presentation/widgets/button.dart';
import 'package:aerion_dashboard/features/auth/presentation/widgets/text_link.dart';
import 'package:aerion_dashboard/features/auth/presentation/widgets/form_field.dart';
import 'package:aerion_dashboard/features/auth/presentation/providers/auth_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      final authNotifier = context.read<AuthNotifier>();
      final authState = authNotifier.state;

      // Cek error untuk menampilkan SnackBar
      if (authState.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.error!),
              backgroundColor: Colors.red,
            ),
          );
          // Reset error state setelah ditampilkan
          authNotifier.resetError();
        });
      }

      // Cek jika reset password berhasil
      if (!authState.isLoading && authState.error == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset link has been sent to your email.'),
              backgroundColor: Colors.green,
            ),
          );
          // Kembali ke halaman login setelah reset password berhasil
          context.go('/login');
        });
      }
    };

    // Tambahkan listener segera setelah widget dibuat
    context.read<AuthNotifier>().addListener(_listener);
  }

  @override
  void dispose() {
    context.read<AuthNotifier>().removeListener(_listener);
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Memanggil method signIn dari Notifier menggunakan context.read
      context.read<AuthNotifier>().resetPassword(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF4F4F5);
    final authState = context.watch<AuthNotifier>().state;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Column(
                  children: [
                    // Image.asset
                    Image.asset(
                      'assets/images/icons/aerion-logo.png',
                      height: 80,
                      width: 80,
                      // Jika asset tidak ada, gunakan placeholder
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[300],
                          child: const Center(child: Text('Aerion\nLogo')),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'AERION',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF364153),
                        fontFamily: 'ZenDots',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'SUPER APPS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.1),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Forgot Password',
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
                        label: 'Email',
                        hintText: 'Input your email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // forget password text button
                      TextLink(
                        label: 'Remember your password ? ',
                        linkLabel: 'Login',
                        onPressed: () {
                          // Handle forgot password action
                          context.go('/login');
                        },
                      ),
                      const SizedBox(height: 32),
                      // use button widget
                      LoginButton(
                        label: 'Reset Password',
                        onPressed: _resetPassword,
                        isLoading: authState.isLoading,
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Jarak aman di bagian bawah
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
