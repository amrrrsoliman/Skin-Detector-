import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  Customtextfield(
      {super.key,
      this.hinttext,
      this.onchanged,
      required this.obscuretext,
      required this.icon});
  String? hinttext;
  bool obscuretext = false;
  Function(String)? onchanged;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        obscureText: obscuretext,
        onChanged: onchanged,
        validator: (data) {
          if (data!.isEmpty) {
            return ("required");
          }
          return null;
        },
        decoration: InputDecoration(
          icon: icon,
          hintText: hinttext,
        ),
      ),
    );
  }
}
