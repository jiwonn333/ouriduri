import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.black54),
    border: outlineInputBorder(),
    fillColor: Colors.grey.withOpacity(0.1),
    filled: true,
    prefixIcon: icon,
    prefixIconColor: Colors.black54,
  );
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );
}
