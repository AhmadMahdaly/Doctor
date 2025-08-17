import 'package:doctor_app/core/responsive/responsive_config.dart';
import 'package:doctor_app/core/routing/router_generation_config.dart';
import 'package:doctor_app/core/theme/app_themes.dart';
import 'package:flutter/material.dart';

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
