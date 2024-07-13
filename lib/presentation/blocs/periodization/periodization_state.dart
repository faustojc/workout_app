part of 'periodization_cubit.dart';

sealed class PeriodizationState with FastEquatable {
  late Periodization? periodization;

  PeriodizationState({this.periodization});

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [periodization];
}

final class PeriodizationInitial extends PeriodizationState {
  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [];
  }
}

final class PeriodizationNoData extends PeriodizationState {
  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [];
  }
}

final class PeriodizationChangePage extends PeriodizationState {
  final int index;

  PeriodizationChangePage(this.index);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [index];
  }
}

final class PeriodizationLoading extends PeriodizationState {
  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [];
  }
}

final class PeriodizationLoaded<T> extends PeriodizationState {
  final T data;

  PeriodizationLoaded(this.data);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [data];
  }
}

final class PeriodizationError extends PeriodizationState {
  final String message;

  PeriodizationError(this.message);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [message];
  }
}
