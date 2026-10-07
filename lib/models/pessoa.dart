// Representa uma pessoa que entrou na academia.
class Pessoa {
  final String nome;
  final String identificacao;
  final DateTime dataEntrada;
  DateTime? _dataSaida;

  Pessoa({
    required this.nome,
    required this.identificacao,
    required this.dataEntrada,
  });

  // Getters
  DateTime? get dataSaida => _dataSaida;

  bool get estaNoAmbiente => _dataSaida == null;

  String get situacao => estaNoAmbiente ? "No ambiente" : "Saiu";

  // Iniciais exibidas no avatar do card (ex.: "Maria Silva" -> "MS")
  String get iniciais {
    final partes = nome.trim().split(RegExp(r"\s+"));
    if (partes.length == 1) {
      return partes.first[0].toUpperCase();
    }
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  // Método: marca o horário de saída da pessoa
  void registrarSaida() {
    _dataSaida = DateTime.now();
  }
}
