import 'package:aerion_dashboard/features/auth/presentation/widgets/button.dart';
import 'package:aerion_dashboard/features/auth/presentation/widgets/form_field.dart';
import 'package:aerion_dashboard/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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

      // Cek sukses untuk navigasi
      if (authState.user != null && authState.error == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final role = authState.user!.role;
          if (role == 'spv') {
            context.go('/cluster');
            return;
          } else if (role == 'pic') {
            context.go('/sites');
            return;
          }
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
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Memanggil method signIn dari Notifier menggunakan context.read
      context.read<AuthNotifier>().signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
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
                      'assets/images/logo/aerion-logo.png',
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
                      // const SizedBox(height: 10),
                      // // forget password text button
                      // TextLink(
                      //   label: 'Forgot password ? ',
                      //   linkLabel: 'Click Here',
                      //   onPressed: () {
                      //     context.go('/forgot-password');
                      //   },
                      // ),
                      const SizedBox(height: 32),
                      // use button widget
                      LoginButton(
                        label: 'Login',
                        onPressed: _login,
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
