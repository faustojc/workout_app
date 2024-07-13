import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/data/models/personal_record.dart';
import 'package:workout_routine/presentation/blocs/user/user_cubit.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class RecordsGrid extends StatelessWidget {
  const RecordsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>()..onFetchRecentRecords();

    return BlocBuilder<UserCubit, UserState>(
      bloc: userCubit,
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserDataLoaded) {
          final records = state.data as List<PersonalRecord>;

          return GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: records.map((record) {
              final historyRecord = userCubit.getHistoryRecord(record.id!);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: ThemeColor.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          record.title!,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        FittedBox(
                          child: IconButton(
                            color: ThemeColor.primary,
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              // TODO: Implement navigate to the selected records to the details page
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AutoSizeText(
                          historyRecord!.weight!.toString(),
                          style: const TextStyle(
                            color: ThemeColor.primary,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'lbs',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat.yMMMd().format(historyRecord.createdAt!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }

        return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/icons/empty-content.png', height: 100),
                const Text(
                  'Empty personal records',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start adding personal records to tract it here',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ));
      },
    );
  }
}
