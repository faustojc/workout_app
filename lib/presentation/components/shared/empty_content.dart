import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String? subtitle;
  final double? imgScale;
  final double? imgWidth;
  final double? imgHeight;

  const EmptyContent({required this.title, super.key, this.subtitle, this.imagePath, this.imgWidth, this.imgHeight, this.imgScale});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (imagePath != null) //
              ? Image.asset(
                  imagePath!,
                  scale: imgScale ?? 1.0,
                  width: imgWidth,
                  height: imgHeight,
                )
              : Image.asset(
                  'assets/images/icons/empty-content.png',
                  scale: imgScale ?? 1.0,
                  color: ThemeColor.primary,
                  width: imgWidth,
                  height: imgHeight,
                ),
          const SizedBox(height: 10),
          AutoSizeText(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 6),
          (subtitle != null)
              ? AutoSizeText(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
