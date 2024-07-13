import 'package:fast_equatable/fast_equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/data/models/periodization.dart';
import 'package:workout_routine/domain/repositories/periodization_repo.dart';

part 'periodization_state.dart';

class PeriodizationCubit extends Cubit<PeriodizationState> {
  final PeriodizationRepo _periodizationRepo;

  PeriodizationCubit({required PeriodizationRepo periodizationRepo})
      : _periodizationRepo = periodizationRepo,
        super(PeriodizationInitial());

  void onChangePage(int index, {Periodization? periodization}) {
    emit(PeriodizationChangePage(index));

    if (periodization != null) {
      _periodizationRepo.periodization = periodization;
    }

    state.periodization = periodization;
  }

  void getPeriodizations() {
    emit(PeriodizationLoading());

    if (_periodizationRepo.periodizations.isEmpty) {
      emit(PeriodizationNoData());
    } else {
      emit(PeriodizationLoaded(_periodizationRepo.periodizations));
    }
  }

  Future<void> onFetchPeriodization() async {
    emit(PeriodizationLoading());

    try {
      await _periodizationRepo.fetchPeriodization();

      if (_periodizationRepo.periodizations.isEmpty) {
        emit(PeriodizationNoData());
      } else {
        emit(PeriodizationLoaded(_periodizationRepo.periodizations));
      }
    } catch (err) {
      emit(PeriodizationError(err.toString()));
    }
  }
}
