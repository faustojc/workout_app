import 'package:flutter/material.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class TopNavigation extends StatelessWidget {
  final MaterialPageRoute? registerRoute;
  final MaterialPageRoute? loginRoute;

  const TopNavigation({super.key, this.registerRoute, this.loginRoute});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: loginRoute == null ? const Border(bottom: BorderSide(width: 2, color: ThemeColor.primary)) : null,
            ),
            child: TextButton(
                onPressed: loginRoute == null
                    ? () {}
                    : () {
                        FocusScope.of(context).unfocus();
                        Navigator.pushAndRemoveUntil(context, loginRoute!, (route) => false);
                      },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 17))),
          ),
          const SizedBox(width: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: registerRoute == null ? const Border(bottom: BorderSide(width: 2, color: ThemeColor.primary)) : null,
            ),
            child: TextButton(
              onPressed: registerRoute == null
                  ? () {}
                  : () {
                      FocusScope.of(context).unfocus();
                      Navigator.pushAndRemoveUntil(context, registerRoute!, (route) => false);
                    },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(10),
              ),
              child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
