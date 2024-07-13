import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepo userRepo = RepositoryProvider.of<UserRepo>(context);

    final firstName = userRepo.athlete.firstname!;
    final lastName = userRepo.athlete.lastname!;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: ThemeColor.primary,
                child: Text(
                  firstName.characters.first.toUpperCase() + lastName.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Joined", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat.yMMMMd().format(userRepo.athlete.createdAt!),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Text(
            firstName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            lastName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
