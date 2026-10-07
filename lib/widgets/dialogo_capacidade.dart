import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

// AlertDialog com TextField para alterar a capacidade máxima.
// Devolve o novo valor ou null se o usuário cancelar.
class DialogoCapacidade extends StatefulWidget {
  final int capacidadeAtual;

  const DialogoCapacidade({super.key, required this.capacidadeAtual});

  @override
  State<DialogoCapacidade> createState() => _DialogoCapacidadeState();
}

class _DialogoCapacidadeState extends State<DialogoCapacidade> {
  late final TextEditingController _capacidadeController =
      TextEditingController(text: widget.capacidadeAtual.toString());

  @override
  void dispose() {
    _capacidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    Navigator.pop(context, int.tryParse(_capacidadeController.text));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.tune, color: AppColors.destaque, size: 40),
      title: Text("Capacidade máxima", style: AppTheme.titulo(fontSize: 28)),
      content: TextField(
        controller: _capacidadeController,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _salvar(),
        decoration: const InputDecoration(
          labelText: "Quantidade de pessoas",
          prefixIcon: Icon(Icons.groups),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "CANCELAR",
            style: TextStyle(color: AppColors.textoSecundario),
          ),
        ),
        TextButton(
          onPressed: _salvar,
          child: const Text(
            "SALVAR",
            style: TextStyle(
              color: AppColors.destaque,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
