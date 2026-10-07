import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FIAP Fit",
      debugShowCheckedModeBanner: false, //Oculta o banner de debug
      theme: AppTheme.tema,
      home: const HomePage(),
    );
  }
}
