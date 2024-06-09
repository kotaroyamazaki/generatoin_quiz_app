import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(24.0),
        //   bottomRight: Radius.circular(24.0),
        // ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Text(
                //   subtitle,
                //   style: const TextStyle(
                //     fontSize: 16,
                //     color: Colors.white70,
                //   ),
                // ),
              ],
            ),
          ),
          Image.asset(
            imagePath,
            height: 64,
            width: 64,
          ),
        ],
      ),
    );
  }
}
