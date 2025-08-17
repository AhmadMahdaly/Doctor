import 'package:doctor_app/core/init/initializer.dart';
import 'package:doctor_app/my_app.dart';
import 'package:flutter/material.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}
