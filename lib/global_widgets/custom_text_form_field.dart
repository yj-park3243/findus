import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final funValidator;
  final controller;
  final keyboardType;
  final inputFormatters;
  final changeEvent;

  const CustomTextFormField({
    this.keyboardType,
    this.inputFormatters,
    this.changeEvent,
    required this.hint,
    required this.funValidator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        onChanged: changeEvent,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14),
        controller: controller,
        inputFormatters: inputFormatters,
        validator: funValidator,
        obscureText: hint == "Password" ? true : false,
        decoration: InputDecoration(
          hintText: "$hint",
          // border: InputBorder.none,
          // focusedBorder: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
