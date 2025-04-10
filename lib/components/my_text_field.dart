import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String lable;
  final IconData icons;
  final TextEditingController onChanged;
  const MyTextField({super.key, required this.lable, required this.icons, required this.onChanged});

  @override 
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icons),
              fillColor: Colors.deepPurple.shade200,
              filled: true,
              hintText: lable,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}