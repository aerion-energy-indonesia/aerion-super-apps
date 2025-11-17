import 'package:flutter/material.dart';
import '../../../../themes/app_colors.dart';

class FormFieldWidget extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const FormFieldWidget({
    super.key,
    required this.label,
    this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'GeistRegular',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors
                .white, // Warna background field yang sangat terang/putih keabu-abuan
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
            enabledBorder: Color(AppColors.border.value) != Colors.transparent
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border),
                  )
                : null,
            focusedBorder: OutlineInputBorder(
              // Border saat field dalam kondisi fokus
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors
                    .buttonBackground, // Contoh warna saat fokus (opsional)
                width: 1.0,
              ),
            ),
            focusColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: AppColors.border != Colors.transparent
                  ? BorderSide(color: AppColors.border)
                  : BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    color: AppColors.textSecondary,
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
