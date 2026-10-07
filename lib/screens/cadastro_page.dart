import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatadores.dart';

// Tela de cadastro. Não conhece as regras da academia: só lê os campos
// e chama a função recebida do widget pai, que devolve true em caso de sucesso.
class CadastroPage extends StatefulWidget {
  final bool Function(String nome, String identificacao) onCadastrar;

  const CadastroPage({super.key, required this.onCadastrar});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _identificacaoController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _identificacaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    final cadastrou = widget.onCadastrar(
      _nomeController.text,
      _identificacaoController.text,
    );
    if (cadastrou) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NOVA ENTRADA")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.destaque.withAlpha(40),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 44,
                    color: AppColors.destaque,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Bora treinar!",
                textAlign: TextAlign.center,
                style: AppTheme.titulo(fontSize: 36),
              ),
              const Text(
                "Preencha os dados do aluno para liberar a catraca.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textoSecundario),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Nome do aluno",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _identificacaoController,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _salvar(),
                decoration: const InputDecoration(
                  labelText: "Matrícula / RM",
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 18,
                    color: AppColors.textoSecundario,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Entrada: ${formatarDataHora(DateTime.now())}",
                      style: const TextStyle(color: AppColors.textoSecundario),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.login),
                label: const Text("REGISTRAR ENTRADA"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
