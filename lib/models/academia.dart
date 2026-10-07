import 'pessoa.dart';

// Erro lançado quando uma operação quebra alguma regra de negócio.
// A mensagem é exibida para o usuário em uma SnackBar.
class AcademiaException implements Exception {
  final String mensagem;

  const AcademiaException(this.mensagem);

  @override
  String toString() => mensagem;
}

// Evolução da classe do Checkpoint 01: agora a lotação é calculada
// a partir da lista de pessoas registradas.
class Academia {
  final String _nome;
  int _capacidadeMaxima;
  final List<Pessoa> _pessoas = [];

  Academia({required String nome, required int capacidadeMaxima})
    : _nome = nome,
      _capacidadeMaxima = capacidadeMaxima;

  // Getters
  String get nome => _nome;
  int get capacidadeMaxima => _capacidadeMaxima;

  // Lista somente leitura: alterações passam pelos métodos da classe
  List<Pessoa> get pessoas => List.unmodifiable(_pessoas);

  int get pessoasNoLocal => _pessoas.where((p) => p.estaNoAmbiente).length;

  int get vagasDisponiveis => _capacidadeMaxima - pessoasNoLocal;

  double get ocupacao => pessoasNoLocal / _capacidadeMaxima;

  bool get estaVazia => pessoasNoLocal == 0;
  bool get estaLotada => pessoasNoLocal >= _capacidadeMaxima;

  //Quase cheia
  bool get estaQuaseCheia =>
      !estaLotada && pessoasNoLocal >= (_capacidadeMaxima * 0.8);

  bool get temRegistrosDeSaida => _pessoas.any((p) => !p.estaNoAmbiente);

  String get situacao {
    if (estaLotada) {
      return "Academia lotada";
    } else if (estaQuaseCheia) {
      return "Atenção: ambiente quase cheio";
    } else {
      return "Pode entrar";
    }
  }

  bool _identificacaoEmUso(String identificacao) {
    return _pessoas.any(
      (p) =>
          p.estaNoAmbiente &&
          p.identificacao.toLowerCase() == identificacao.toLowerCase(),
    );
  }

  // Método: cadastra uma pessoa e registra sua entrada
  Pessoa registrarEntrada({
    required String nome,
    required String identificacao,
  }) {
    final nomeLimpo = nome.trim();
    final identificacaoLimpa = identificacao.trim();

    // Regra 3 - Cadastro
    if (nomeLimpo.isEmpty || identificacaoLimpa.isEmpty) {
      throw const AcademiaException("Preencha o nome e a matrícula.");
    }

    // Regra 1 - Capacidade
    if (estaLotada) {
      throw const AcademiaException(
        "Não é possível realizar a entrada. Ambiente lotado!",
      );
    }

    // Regra 4 - Identificação
    if (_identificacaoEmUso(identificacaoLimpa)) {
      throw AcademiaException(
        "A matrícula $identificacaoLimpa já está no ambiente.",
      );
    }

    final pessoa = Pessoa(
      nome: nomeLimpo,
      identificacao: identificacaoLimpa,
      dataEntrada: DateTime.now(),
    );
    // Mais recentes aparecem no topo da lista
    _pessoas.insert(0, pessoa);
    return pessoa;
  }

  // Método: registra a saída de uma pessoa
  void registrarSaida(Pessoa pessoa) {
    // Regra 2 - Saída
    if (!pessoa.estaNoAmbiente) {
      throw AcademiaException("${pessoa.nome} já saiu do ambiente.");
    }
    pessoa.registrarSaida();
  }

  // Método: exclui o registro da pessoa
  void removerPessoa(Pessoa pessoa) {
    _pessoas.remove(pessoa);
  }

  // Método: remove todos os registros de quem já saiu.
  // Retorna quantos registros foram apagados.
  int limparSaidas() {
    final quantidadeAntes = _pessoas.length;
    _pessoas.removeWhere((p) => !p.estaNoAmbiente);
    return quantidadeAntes - _pessoas.length;
  }

  // Método: altera a capacidade sem deixar ninguém "sobrando" no ambiente
  void alterarCapacidade(int novaCapacidade) {
    if (novaCapacidade <= 0) {
      throw const AcademiaException("A capacidade deve ser maior que zero.");
    }
    if (novaCapacidade < pessoasNoLocal) {
      throw AcademiaException(
        "Já existem $pessoasNoLocal pessoas no ambiente. "
        "A capacidade não pode ser menor que isso.",
      );
    }
    _capacidadeMaxima = novaCapacidade;
  }
}
