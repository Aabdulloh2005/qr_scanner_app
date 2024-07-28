import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenCubit extends Cubit<int> {
  ScreenCubit() : super(1);



  void onScreenChanged(int index) {

      emit(index);

  }

}