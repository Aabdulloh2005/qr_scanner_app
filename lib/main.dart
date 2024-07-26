import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner/cubit/cutoutsize_cubit.dart';
import 'package:qr_scanner/views/screens/homepage.dart';

void main(List<String> args) {
  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CutoutsizeCubit(),
      child: MaterialApp(
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: const Color(0xff333333)),
        debugShowCheckedModeBanner: false,
        home: const Homepage(),
      ),
    );
  }
}
