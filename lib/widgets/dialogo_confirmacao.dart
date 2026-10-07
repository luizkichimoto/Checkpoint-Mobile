import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

// AlertDialog reutilizado nas operações importantes (saída, exclusão,
// limpeza de registros). Retorna true quando o usuário confirma.
Future<bool> confirmarAcao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  required IconData icone,
  Color cor = AppColors.destaque,
}) async {
  final confirmou = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(icone, color: cor, size: 40),
      title: Text(titulo, style: AppTheme.titulo(fontSize: 28)),
      content: Text(mensagem, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            "CANCELAR",
            style: TextStyle(color: AppColors.textoSecundario),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            "CONFIRMAR",
            style: TextStyle(color: cor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
  // Fechar o diálogo tocando fora conta como "cancelar"
  return confirmou ?? false;
}
