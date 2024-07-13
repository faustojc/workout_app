part of 'form_input_cubit.dart';

sealed class FormInputState {}

final class FormInitial extends FormInputState {}

final class FormInputChanged extends FormInputState {
  final FormRepo repo;

  FormInputChanged({required this.repo});
}

final class FormSubmitting extends FormInputState {
  final Map<String, dynamic> data;

  FormSubmitting({required this.data});
}

final class FormSuccess extends FormInputState {}

final class FormFailure extends FormInputState {
  final String message;

  FormFailure({required this.message});
}
