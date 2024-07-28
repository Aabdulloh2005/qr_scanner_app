import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner/cubit/cutoutsize_cubit.dart';
import 'package:qr_scanner/cubit/screen_cubit.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/views/screens/homepage.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CutoutsizeCubit(),
        ),
        BlocProvider(
          create: (context) => ScreenCubit(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: const Color(0xff3D3D3D)),
        debugShowCheckedModeBanner: false,
        home: Homepage(),
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
