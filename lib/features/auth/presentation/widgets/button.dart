import 'package:flutter/material.dart';
import '../../../../themes/app_colors.dart';

class LoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LoginButton({Key? key, required this.label, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'GeistMedium',
        ),
      ),
    );
  }
}
