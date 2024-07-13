import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_routine/domain/repositories/form_repo.dart';

part 'form_input_state.dart';

class FormInputCubit extends Cubit<FormInputState> {
  final FormRepo _formRepo;

  FormInputCubit({required FormRepo formRepo})
      : _formRepo = formRepo,
        super(FormInitial());

  void onInputChanged({required String key, required dynamic value}) {
    _formRepo.update(key: key, value: value);

    emit(FormInputChanged(repo: _formRepo));
  }

  void onFormSubmit() {
    emit(FormSubmitting(data: _formRepo.data));
  }

  void onFormSuccess() {
    _formRepo.clear();
    emit(FormSuccess());
  }

  void onFormError({required String message}) {
    emit(FormFailure(message: message));
  }
}
