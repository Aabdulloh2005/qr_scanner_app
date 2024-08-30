import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qr_scanner/cubit/cutoutsize_cubit.dart';
import 'package:qr_scanner/cubit/screen_cubit.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/views/screens/splash/splash_screen.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QrCodeModelAdapter());
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
        theme: ThemeData.dark().copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColor.yellow,
          ),
          scaffoldBackgroundColor: const Color(0xff3D3D3D),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
