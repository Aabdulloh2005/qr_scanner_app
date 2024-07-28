import 'package:flutter_bloc/flutter_bloc.dart';

class ResultCubit extends Cubit<bool> {
  ResultCubit() : super(true);

  void onResult() {
    emit(!state);
  }
}
