import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class AccountSettingsList extends StatelessWidget {
  const AccountSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            // TODO: route to the personal details page
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          tileColor: ThemeColor.grey,
          splashColor: ThemeColor.primary.withAlpha(20),
          leading: const Icon(Icons.person, color: Colors.white),
          title: const Text("Personal Details", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: ThemeColor.primary),
        ),
        ListTile(
          onTap: () {
            // TODO: route to the email and password page
          },
          tileColor: ThemeColor.grey,
          splashColor: ThemeColor.primary.withAlpha(20),
          leading: const Icon(Icons.lock, color: Colors.white),
          title: const Text("Email and Password", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: ThemeColor.primary),
        ),
        ListTile(
          onTap: () {
            // TODO: route to the settings page
          },
          tileColor: ThemeColor.grey,
          splashColor: ThemeColor.primary.withAlpha(20),
          leading: const Icon(Icons.settings, color: Colors.white),
          title: const Text("Settings", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: ThemeColor.primary),
        ),
        ListTile(
          onTap: () {
            // TODO: route to the units of measure page
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          tileColor: ThemeColor.grey,
          splashColor: ThemeColor.primary.withAlpha(20),
          leading: const Icon(Icons.straighten, color: Colors.white),
          title: const Text("Units of Measure", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: ThemeColor.primary),
        ),
      ],
    );
  }
}
