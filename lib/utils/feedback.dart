import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Mostra uma SnackBar padronizada para todas as operações do app.
void mostrarMensagem(
  BuildContext context,
  String mensagem, {
  bool erro = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: erro ? AppColors.perigo : AppColors.sucesso,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(
              erro ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.texto,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensagem,
                style: const TextStyle(
                  color: AppColors.texto,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
