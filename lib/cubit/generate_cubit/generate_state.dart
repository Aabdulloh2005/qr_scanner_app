import 'package:equatable/equatable.dart';

class GenerateScreenState extends Equatable {
  final String input;
  final bool isInputValid;

  const GenerateScreenState({
    required this.input,
    required this.isInputValid,
  });

  @override
  List<Object> get props => [input, isInputValid];

  GenerateScreenState copyWith({
    String? input,
    bool? isInputValid,
  }) {
    return GenerateScreenState(
      input: input ?? this.input,
      isInputValid: isInputValid ?? this.isInputValid,
    );
  }
}
