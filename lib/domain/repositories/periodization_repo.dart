import 'package:workout_routine/data/models/day.dart';
import 'package:workout_routine/data/models/mixin/query_builder.dart';
import 'package:workout_routine/data/models/periodization.dart';
import 'package:workout_routine/data/models/week.dart';

class PeriodizationRepo {
  final List<Periodization> periodizations = [];
  final List<Week> weeks = [];
  final List<Day> days = [];

  Periodization? _periodization;
  Week? _week;
  Day? _day;

  Periodization get periodization => _periodization ?? Periodization();

  Week get week => _week ?? Week();

  Day get day => _day ?? Day();

  set periodization(Periodization value) => _periodization = value;

  set week(Week value) => _week = value;

  set day(Day value) => _day = value;

  Future<void> fetchPeriodization() async {
    final results = await Periodization()
        .query //
        .getAll()
        .then((e) => e.map((e) => Periodization.fromJson(e)));

    periodizations.addAll(results);
  }

  Future<void> fetchDates(String periodizationId) async {
    Set<String> columns = {
      'days.id AS day_id',
      'days.title as day_title',
      'weeks.id AS week_id',
      'weeks.title AS week_title',
    };

    weeks.clear();
    days.clear();

    final results = await QueryBuilder() //
        .select(columns: columns)
        .from('weeks')
        .join('days', 'days.weeks_id = weeks.id', type: 'FULL')
        .where('weeks.periodization_id', '=', periodizationId)
        .getAll();

    for (final result in results) {
      final existingWeek = weeks.any((week) => week.id == result['week_id']);
      final existingDay = days.any((day) => day.id == result['day_id']);

      if (!existingWeek && result['week_id'] != null) {
        weeks.add(Week.fromJson({
          'id': result['week_id'],
          'periodization_id': periodizationId,
          'title': result['week_title'],
        }));
      }

      if (!existingDay && result['day_id'] != null) {
        days.add(Day.fromJson({
          'id': result['day_id'],
          'weeks_id': result['week_id'],
          'title': result['day_title'],
        }));
      }
    }
  }
}
