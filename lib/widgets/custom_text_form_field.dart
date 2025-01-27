import 'package:flutter/material.dart';
import 'package:ouriduri_couple_app/utils/app_colors.dart';
import 'package:ouriduri_couple_app/widgets/input_style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType = TextInputType.text;
  final bool obscureText;
  final void Function(String?) validator;
  final String? errorMsg;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    this.errorMsg,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          cursorColor: Colors.blue,
          controller: controller,
          decoration: buildInputDecoration(hintText, icon),
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: (value) => validator(value),
        ),
        if (errorMsg != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorMsg!,
              style: const TextStyle(color: Colors.red, fontSize: 12.0),
            ),
          ),
      ],
    );
  }
}
