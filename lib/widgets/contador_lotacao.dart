import 'package:flutter/material.dart';

import '../models/academia.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

// Painel com a lotação atual (ex.: 12 / 50), a barra de ocupação
// e a mensagem de situação vinda da classe Academia.
class ContadorLotacao extends StatelessWidget {
  final Academia academia;
  final VoidCallback onEditarCapacidade;

  const ContadorLotacao({
    super.key,
    required this.academia,
    required this.onEditarCapacidade,
  });

  //Cor da mensagem de situacao muda conforme a lotacao
  Color get _corDaSituacao {
    if (academia.estaLotada) {
      return AppColors.perigo;
    } else if (academia.estaQuaseCheia) {
      return AppColors.alerta;
    } else {
      return AppColors.sucesso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = _corDaSituacao;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.superficie.withAlpha(230),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.groups, color: AppColors.destaque),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "PESSOAS NO AMBIENTE",
                  style: AppTheme.titulo(
                    fontSize: 20,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ),
              IconButton(
                tooltip: "Alterar capacidade",
                onPressed: onEditarCapacidade,
                icon: const Icon(Icons.tune, color: AppColors.textoSecundario),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${academia.pessoasNoLocal}",
                style: AppTheme.titulo(fontSize: 72, color: cor),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14, left: 6),
                child: Text(
                  "/ ${academia.capacidadeMaxima}",
                  style: AppTheme.titulo(
                    fontSize: 32,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: academia.ocupacao,
              minHeight: 10,
              color: cor,
              backgroundColor: AppColors.borda,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: cor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  academia.situacao,
                  style: TextStyle(color: cor, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                "Vagas: ${academia.vagasDisponiveis}",
                style: const TextStyle(color: AppColors.textoSecundario),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
