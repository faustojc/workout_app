import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class SettingsPolicyTerms extends StatelessWidget {
  const SettingsPolicyTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            // TODO: route to privacy policy page
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          tileColor: ThemeColor.grey,
          splashColor: ThemeColor.primary.withAlpha(20),
          leading: const Icon(Icons.privacy_tip, color: Colors.white),
          title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: ThemeColor.primary),
        ),
        ListTile(
          onTap: () {
            // TODO: route to terms and conditions page
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          tileColor: ThemeColor.grey,
          splashColor: ThemeColor.primary.withAlpha(20),
          leading: const Icon(Icons.gavel, color: Colors.white),
          title: const Text("Terms & Conditions", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: ThemeColor.primary),
        ),
      ],
    );
  }
}
