import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

// Bebas Neue nos títulos e números (estilo placar de academia)
// e Poppins nos textos comuns.
class AppTheme {
  static TextStyle titulo({double fontSize = 28, Color? color}) {
    return GoogleFonts.bebasNeue(
      fontSize: fontSize,
      color: color ?? AppColors.texto,
      letterSpacing: 1.2,
    );
  }

  static ThemeData get tema {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.fundo,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.destaque,
        onPrimary: AppColors.texto,
        secondary: AppColors.sucesso,
        surface: AppColors.superficie,
        onSurface: AppColors.texto,
        error: AppColors.perigo,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.texto,
        displayColor: AppColors.texto,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.fundo,
        foregroundColor: AppColors.texto,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: titulo(fontSize: 30, color: AppColors.destaque),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        labelStyle: GoogleFonts.poppins(color: AppColors.textoSecundario),
        prefixIconColor: AppColors.destaque,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.destaque, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.destaque,
          foregroundColor: AppColors.texto,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: titulo(fontSize: 22),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
