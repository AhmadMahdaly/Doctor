import 'package:doctor_app/core/cache_helper/cache_helper.dart';
import 'package:doctor_app/core/di.dart';
import 'package:doctor_app/core/responsive/responsive_config.dart';
import 'package:doctor_app/core/routing/router_generation_config.dart';
import 'package:doctor_app/core/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusScope(context),
      child: MaterialApp.router(
        builder: (context, child) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig.init(context);
              return child!;
            },
          );
        },
        title: 'Doctor',
        debugShowCheckedModeBanner: false,
        routerConfig: RouterGenerationConfig.goRouter,
        theme: Appthemes.lightTheme(),
      ),
    );
  }
}

void unfocusScope(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.unfocus();
  }
}

/// --> core/init/initializer.dart
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await setupGetIt();
  // Bloc.observer = MyBlocObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
