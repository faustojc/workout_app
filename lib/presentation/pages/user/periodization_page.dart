import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:workout_routine/data/models/periodization.dart';
import 'package:workout_routine/domain/routes/routes.dart';
import 'package:workout_routine/presentation/blocs/periodization/periodization_cubit.dart';
import 'package:workout_routine/presentation/components/shared/empty_content.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class PeriodizationPage extends StatelessWidget {
  final List<AssetImage> backgrounds = const [
    AssetImage('assets/images/backgrounds/periodization0.png'),
    AssetImage('assets/images/backgrounds/periodization1.png'),
    AssetImage('assets/images/backgrounds/periodization2.png'),
    AssetImage('assets/images/backgrounds/periodization3.png'),
  ];

  const PeriodizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final perioCubit = BlocProvider.of<PeriodizationCubit>(context)..getPeriodizations();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.black,
        elevation: 0,
        leading: Hero(
          tag: 'periodization',
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: ThemeColor.primary),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Start Workout',
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Center(
                  child: BlocBuilder<PeriodizationCubit, PeriodizationState>(
                    bloc: perioCubit,
                    buildWhen: (prev, curr) => curr is PeriodizationLoading || curr is PeriodizationLoaded || curr is PeriodizationNoData,
                    builder: (context, state) {
                      if (state is PeriodizationLoading) {
                        return ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) => ShimmerPro.sized(
                                  width: double.infinity,
                                  height: 140,
                                  scaffoldBackgroundColor: ThemeColor.grey,
                                ));
                      } else if (state is PeriodizationLoaded) {
                        final data = state.data as List<Periodization>;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: data.indexed
                              .map(((int, Periodization) record) => GestureDetector(
                                    onTap: () {
                                      perioCubit.onChangePage(1, periodization: record.$2);
                                      Navigator.push(context, Routes.workoutSchedule);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      constraints: const BoxConstraints(minHeight: 150),
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: backgrounds[record.$1],
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            AutoSizeText(
                                              record.$2.acronym ?? record.$2.name!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: ThemeColor.primary, fontSize: 28, fontWeight: FontWeight.bold),
                                            ),
                                            AutoSizeText(
                                              record.$2.name!,
                                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      }

                      return const EmptyContent(
                        title: "Empty periodization",
                        subtitle: "The coach hasn't set the periodization yet. Please wait for the coach to set the periodization.",
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
