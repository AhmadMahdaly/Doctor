import 'package:doctor_app/core/cache_helper/cache_helper.dart';
import 'package:doctor_app/core/cache_helper/keys.dart';
import 'package:doctor_app/core/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc.observer = MyBlocObserver();
  await Supabase.initialize(
    url: kSupabaseUrl,
    anonKey: kAnonKey,
  );
  await CacheHelper.init();
  await setupGetIt();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
