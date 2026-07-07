import 'package:flutter/material.dart';
import 'package:triply/app/app.dart';
import 'package:triply/app/bootstrap/app_bootstrap.dart';

Future<void> main() async {
  await AppBootstrap.initialize();
  runApp(const App());
}
