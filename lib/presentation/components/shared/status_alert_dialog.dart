import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class StatusAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? statusIndicator;
  final String statusMessage;
  final List<Widget>? actions;

  const StatusAlertDialog({
    required this.statusMessage,
    super.key,
    this.title,
    this.statusIndicator,
    this.actions,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          AbsorbPointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          AlertDialog(
              title: title,
              alignment: Alignment.center,
              backgroundColor: ThemeColor.grey,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    switchOutCurve: Curves.easeOut,
                    child: statusIndicator,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    switchOutCurve: Curves.easeOut,
                    child: Text(statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions ?? [const SizedBox.shrink()],
                ),
              ]),
        ],
      );
}
