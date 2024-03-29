import 'package:flutter/material.dart';

class AddInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const AddInfoItem({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: [
        Column(
          children: [
    SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    ),
            Icon(icon, size: 22),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(value),
          ],
        ),
      ],
    );
  }
}
