import 'package:flutter/material.dart';

class Lives extends StatelessWidget {
  final int lives;

  const Lives({super.key, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < lives ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 30,
        );
      }),
    );
  }
}
