import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/pessoa.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatadores.dart';

// Widget personalizado que representa uma pessoa na lista.
// Recebe o objeto Pessoa e as funções que avisam o widget pai
// quando o usuário pede a saída ou a exclusão do registro.
class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final noAmbiente = pessoa.estaNoAmbiente;
    final corSituacao = noAmbiente ? AppColors.sucesso : AppColors.inativo;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          key: ObjectKey(pessoa),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.55,
            children: [
              SlidableAction(
                onPressed: (_) => onSaida(),
                // Cinza quando a pessoa já saiu (regra 2)
                backgroundColor: noAmbiente
                    ? AppColors.alerta
                    : AppColors.inativo,
                foregroundColor: AppColors.texto,
                icon: Icons.logout,
                label: "SAÍDA",
              ),
              SlidableAction(
                onPressed: (_) => onExcluir(),
                backgroundColor: AppColors.perigo,
                foregroundColor: AppColors.texto,
                icon: Icons.delete_outline,
                label: "EXCLUIR",
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.superficie,
              border: Border(left: BorderSide(color: corSituacao, width: 5)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: corSituacao.withAlpha(40),
                  child: Text(
                    pessoa.iniciais,
                    style: AppTheme.titulo(fontSize: 24, color: corSituacao),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pessoa.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _Linha(
                        icone: Icons.badge_outlined,
                        texto: "ID: ${pessoa.identificacao}",
                      ),
                      _Linha(
                        icone: Icons.login,
                        texto:
                            "Entrada: ${formatarDataHora(pessoa.dataEntrada)}",
                      ),
                      if (pessoa.dataSaida != null)
                        _Linha(
                          icone: Icons.logout,
                          texto:
                              "Saída: ${formatarDataHora(pessoa.dataSaida!)}",
                        ),
                      const SizedBox(height: 6),
                      _SituacaoChip(texto: pessoa.situacao, cor: corSituacao),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textoSecundario,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _Linha({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icone, size: 14, color: AppColors.textoSecundario),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textoSecundario,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SituacaoChip extends StatelessWidget {
  final String texto;
  final Color cor;

  const _SituacaoChip({required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: cor.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Situação: $texto",
        style: TextStyle(
          fontSize: 12,
          color: cor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
