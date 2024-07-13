import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';
import 'package:workout_routine/presentation/components/home/tabs/contents/recent_workout.dart';
import 'package:workout_routine/presentation/components/home/tabs/contents/records_grid.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class HomeOverviewTab extends StatelessWidget {
  const HomeOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = RepositoryProvider.of<UserRepo>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: const Text(
              'WELCOME,',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              userRepo.athlete.firstname!.toUpperCase(),
              style: const TextStyle(
                color: ThemeColor.primary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            trailing: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userRepo.athlete.firstname!.characters.first.toUpperCase() + userRepo.athlete.lastname!.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: ThemeColor.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'RECENT WORKOUT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          const RecentWorkout(),
          const SizedBox(height: 30),
          const Text(
            'RECENT PERSONAL RECORDS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          const RecordsGrid(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
