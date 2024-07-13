import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/components/auth/auth_logout_button.dart';
import 'package:workout_routine/presentation/components/home/tabs/contents/account_settings_list.dart';
import 'package:workout_routine/presentation/components/home/tabs/contents/settings_header.dart';
import 'package:workout_routine/presentation/components/home/tabs/contents/settings_policy_terms.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text("MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white)),
            SizedBox(height: 20),
            SettingsHeader(),
            SizedBox(height: 30),
            Text(
              "Account Settings",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            AccountSettingsList(),
            SizedBox(height: 20),
            SettingsPolicyTerms(),
            SizedBox(height: 40),
            AuthLogoutButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
