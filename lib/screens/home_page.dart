import 'package:flutter/material.dart';

import '../models/academia.dart';
import '../models/pessoa.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/feedback.dart';
import '../widgets/contador_lotacao.dart';
import '../widgets/dialogo_capacidade.dart';
import '../widgets/dialogo_confirmacao.dart';
import '../widgets/pessoa_item.dart';
import 'cadastro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Academia academia = Academia(
    nome: "Academia FIAP Fit",
    capacidadeMaxima: 50,
  );

  // Função passada para a CadastroPage
  bool _cadastrar(String nome, String identificacao) {
    try {
      setState(() {
        academia.registrarEntrada(nome: nome, identificacao: identificacao);
      });
      mostrarMensagem(context, "Pessoa cadastrada com sucesso!");
      return true;
    } on AcademiaException catch (e) {
      mostrarMensagem(context, e.mensagem, erro: true);
      return false;
    }
  }

  void _abrirCadastro() {
    // Nem abre o formulário se não houver vaga
    if (academia.estaLotada) {
      mostrarMensagem(
        context,
        "Não é possível realizar a entrada. Ambiente lotado!",
        erro: true,
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroPage(onCadastrar: _cadastrar),
      ),
    );
  }

  Future<void> _registrarSaida(Pessoa pessoa) async {
    if (!pessoa.estaNoAmbiente) {
      mostrarMensagem(
        context,
        "${pessoa.nome} já saiu do ambiente.",
        erro: true,
      );
      return;
    }

    final confirmou = await confirmarAcao(
      context,
      titulo: "Registrar saída?",
      mensagem: "Deseja realmente registrar a saída de ${pessoa.nome}?",
      icone: Icons.logout,
      cor: AppColors.alerta,
    );
    if (!confirmou || !mounted) return;

    try {
      setState(() => academia.registrarSaida(pessoa));
      mostrarMensagem(context, "Saída registrada com sucesso!");
    } on AcademiaException catch (e) {
      mostrarMensagem(context, e.mensagem, erro: true);
    }
  }

  Future<void> _excluir(Pessoa pessoa) async {
    final confirmou = await confirmarAcao(
      context,
      titulo: "Excluir registro?",
      mensagem:
          "O registro de ${pessoa.nome} será apagado. "
          "Essa ação não pode ser desfeita.",
      icone: Icons.delete_outline,
      cor: AppColors.perigo,
    );
    if (!confirmou || !mounted) return;

    setState(() => academia.removerPessoa(pessoa));
    mostrarMensagem(context, "Registro excluído com sucesso!");
  }

  Future<void> _limparSaidas() async {
    if (!academia.temRegistrosDeSaida) {
      mostrarMensagem(
        context,
        "Não há registros de saída para limpar.",
        erro: true,
      );
      return;
    }

    final confirmou = await confirmarAcao(
      context,
      titulo: "Limpar registros?",
      mensagem: "Todos os registros de quem já saiu serão apagados.",
      icone: Icons.cleaning_services_outlined,
      cor: AppColors.perigo,
    );
    if (!confirmou || !mounted) return;

    late int removidos;
    setState(() => removidos = academia.limparSaidas());
    mostrarMensagem(context, "$removidos registro(s) removido(s).");
  }

  Future<void> _editarCapacidade() async {
    final novaCapacidade = await showDialog<int>(
      context: context,
      builder: (_) =>
          DialogoCapacidade(capacidadeAtual: academia.capacidadeMaxima),
    );
    if (novaCapacidade == null || !mounted) return;

    try {
      setState(() => academia.alterarCapacidade(novaCapacidade));
      mostrarMensagem(context, "Capacidade alterada para $novaCapacidade.");
    } on AcademiaException catch (e) {
      mostrarMensagem(context, e.mensagem, erro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pessoas = academia.pessoas;

    return Scaffold(
      appBar: AppBar(
        title: Text(academia.nome.toUpperCase()),
        actions: [
          IconButton(
            tooltip: "Limpar registros de saída",
            onPressed: _limparSaidas,
            icon: const Icon(Icons.cleaning_services_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        backgroundColor: academia.estaLotada
            ? AppColors.inativo
            : AppColors.destaque,
        foregroundColor: AppColors.texto,
        icon: const Icon(Icons.person_add_alt_1),
        label: Text("NOVA ENTRADA", style: AppTheme.titulo(fontSize: 20)),
      ),
      body: Container(
        // Foto da academia do CP1, escurecida para o texto ficar legível
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/academia_fundo.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.fundo.withAlpha(215),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContadorLotacao(
                  academia: academia,
                  onEditarCapacidade: _editarCapacidade,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.list_alt, color: AppColors.destaque),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "REGISTROS (${pessoas.length})",
                        style: AppTheme.titulo(fontSize: 22),
                      ),
                    ),
                    const Text(
                      "Deslize para ações",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: pessoas.isEmpty
                      ? const _ListaVazia()
                      : ListView.builder(
                          // Espaço extra para o FAB não cobrir o último item
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: pessoas.length,
                          itemBuilder: (context, index) {
                            final pessoa = pessoas[index];
                            return PessoaItem(
                              pessoa: pessoa,
                              onSaida: () => _registrarSaida(pessoa),
                              onExcluir: () => _excluir(pessoa),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListaVazia extends StatelessWidget {
  const _ListaVazia();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.fitness_center,
            size: 64,
            color: AppColors.textoSecundario,
          ),
          const SizedBox(height: 12),
          Text(
            "Academia vazia",
            style: AppTheme.titulo(color: AppColors.textoSecundario),
          ),
          const Text(
            "Toque em NOVA ENTRADA para registrar um aluno.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textoSecundario),
          ),
        ],
      ),
    );
  }
}
