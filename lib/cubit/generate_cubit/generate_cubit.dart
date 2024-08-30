import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner/cubit/generate_cubit/generate_state.dart';

class GenerateScreenCubit extends Cubit<GenerateScreenState> {
  final String icon;

  GenerateScreenCubit(this.icon)
      : super(const GenerateScreenState(input: '', isInputValid: false));

  void updateInput(String input) {
    emit(state.copyWith(
      input: input,
      isInputValid: _isValidInput(input),
    ));
  }

  bool _isValidInput(String input) {
    switch (icon) {
      case 'telegram':
        return input.isNotEmpty;
      case 'instagram':
        return input.isNotEmpty;
      case 'twitter':
        return RegExp(r'^[a-zA-Z0-9_]{1,15}$').hasMatch(input);
      case 'email':
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
      case 'location':
        return input.isNotEmpty;
      case 'wathsApp':
        return input.isNotEmpty;
      case 'telephone':
        return RegExp(r'^\+?[0-9]{10,14}$').hasMatch(input);
      case 'website':
        return Uri.tryParse(input)?.hasAbsolutePath ?? false;
      case 'text':
        return input.isNotEmpty;
      default:
        return false;
    }
  }
}
