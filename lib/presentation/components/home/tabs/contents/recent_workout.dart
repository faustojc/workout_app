import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:workout_routine/data/modules/recent_workout_details.dart';
import 'package:workout_routine/domain/providers/image_path_provider.dart';
import 'package:workout_routine/presentation/blocs/workout/workout_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class RecentWorkout extends HookWidget {
  const RecentWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutCubit = context.read<WorkoutCubit>()..onFetchRecentWorkout();

    return BlocBuilder<WorkoutCubit, WorkoutState>(
      bloc: workoutCubit,
      buildWhen: (prev, curr) => curr is WorkoutNoData || curr is WorkoutLoading || curr is WorkoutLoaded,
      builder: (context, state) {
        if (state is WorkoutNoData) {
          return Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: ThemeColor.lightGrey),
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePathProvider.noRecentWorkout, height: 300),
                  const Text(
                    'No recent workout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ThemeColor.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your recent workout will be shown here',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ));
        } else if (state is WorkoutLoaded) {
          final data = state.data as RecentWorkoutDetails;
          final playedDuration = (data.playedAt.inSeconds / data.workout.videoDuration!.inSeconds) * 100.0;

          return Container(
            padding: const EdgeInsets.all(16.0),
            constraints: const BoxConstraints(minHeight: 280, maxHeight: 280),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: FastCachedImageProvider(data.workout.thumbnailUrl!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      // TODO: Navigate to the recent workout to WorkoutPage
                    },
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              data.workout.title!,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: data.parameters //
                                  .take((data.parameters.length > 1) ? 2 : 1)
                                  .map((param) => AutoSizeText(param.value!, style: const TextStyle(color: Colors.white, fontSize: 14)))
                                  .toList(),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: playedDuration,
                            backgroundColor: ThemeColor.grey,
                            minHeight: 14,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ShimmerPro.sized(
          scaffoldBackgroundColor: ThemeColor.grey,
          duration: const Duration(seconds: 3),
          height: 280,
          width: double.infinity,
        );
      },
    );
  }
}
