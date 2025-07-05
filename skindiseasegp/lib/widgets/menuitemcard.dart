import 'package:flutter/material.dart';

class Menuitemcard extends StatelessWidget {
  const Menuitemcard({
    super.key,
    required this.onTab,
    required this.color,
    required this.text,
    required this.icon,
  });

  final VoidCallback onTab;
  final Color color;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        height: 120, //  الارتفاع مساوي للعرض ليكون مربع
        width: 120, // العرض مساوي للارتفاع
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 75, color: color),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 30,
                // fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
