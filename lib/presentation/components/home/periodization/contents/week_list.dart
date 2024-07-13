import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:workout_routine/domain/providers/image_path_provider.dart';
import 'package:workout_routine/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:workout_routine/presentation/components/home/periodization/contents/week_card.dart';
import 'package:workout_routine/presentation/components/shared/empty_content.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class WeekList extends HookWidget {
  const WeekList({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);

    useEffect(() {
      scheduleBloc.add(ScheduleFetchData());
      return () {};
    }, const []);

    return BlocProvider.value(
        value: scheduleBloc,
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          buildWhen: (prev, curr) => prev != curr,
          builder: (context, state) {
            if (state is ScheduleNoData) {
              return const EmptyContent(
                imagePath: ImagePathProvider.noDates,
                imgScale: 1.5,
                title: "No week schedule yet",
                subtitle: "The coach hasn't set the weeks yet. Please wait for the coach to set the weeks.",
              );
            } else if (state is ScheduleLoaded<List<Map<String, dynamic>>>) {
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.data.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) => WeekCard(
                  week: state.data[index]['week'],
                  days: state.data[index]['days'],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator(color: ThemeColor.primary));
          },
        ));
  }
}
