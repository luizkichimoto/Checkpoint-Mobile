import 'package:flutter_test/flutter_test.dart';

import 'package:academia_cp/models/academia.dart';

void main() {
  late Academia academia;

  setUp(() {
    academia = Academia(nome: "Academia FIAP Fit", capacidadeMaxima: 2);
  });

  test("cadastro registra a entrada e atualiza a lotação", () {
    final pessoa = academia.registrarEntrada(
      nome: "  Maria Silva ",
      identificacao: "123456",
    );

    expect(pessoa.nome, "Maria Silva");
    expect(pessoa.situacao, "No ambiente");
    expect(academia.pessoasNoLocal, 1);
    expect(academia.vagasDisponiveis, 1);
  });

  test("regra 1: não permite entrada com o ambiente lotado", () {
    academia.registrarEntrada(nome: "Maria", identificacao: "1");
    academia.registrarEntrada(nome: "João", identificacao: "2");

    expect(academia.estaLotada, isTrue);
    expect(
      () => academia.registrarEntrada(nome: "Ana", identificacao: "3"),
      throwsA(isA<AcademiaException>()),
    );
    expect(academia.pessoasNoLocal, 2);
  });

  test("regra 2: não registra a saída duas vezes", () {
    final pessoa = academia.registrarEntrada(nome: "Maria", identificacao: "1");

    academia.registrarSaida(pessoa);
    expect(pessoa.situacao, "Saiu");
    expect(pessoa.dataSaida, isNotNull);
    expect(academia.pessoasNoLocal, 0);

    expect(
      () => academia.registrarSaida(pessoa),
      throwsA(isA<AcademiaException>()),
    );
  });

  test("regra 3: não cadastra com campos vazios", () {
    expect(
      () => academia.registrarEntrada(nome: "  ", identificacao: "1"),
      throwsA(isA<AcademiaException>()),
    );
    expect(
      () => academia.registrarEntrada(nome: "Maria", identificacao: ""),
      throwsA(isA<AcademiaException>()),
    );
    expect(academia.pessoas, isEmpty);
  });

  test("regra 4: não repete matrícula de quem está no ambiente", () {
    final pessoa = academia.registrarEntrada(nome: "Maria", identificacao: "RM1");

    expect(
      () => academia.registrarEntrada(nome: "Outra", identificacao: "rm1"),
      throwsA(isA<AcademiaException>()),
    );

    // Depois que a pessoa sai, a mesma matrícula pode entrar de novo
    academia.registrarSaida(pessoa);
    academia.registrarEntrada(nome: "Maria", identificacao: "RM1");
    expect(academia.pessoasNoLocal, 1);
  });

  test("excluir e limpar registros atualizam a lotação", () {
    final maria = academia.registrarEntrada(nome: "Maria", identificacao: "1");
    final joao = academia.registrarEntrada(nome: "João", identificacao: "2");

    academia.removerPessoa(maria);
    expect(academia.pessoasNoLocal, 1);

    academia.registrarSaida(joao);
    expect(academia.limparSaidas(), 1);
    expect(academia.pessoas, isEmpty);
  });

  test("capacidade não pode ficar abaixo de quem está no ambiente", () {
    academia.registrarEntrada(nome: "Maria", identificacao: "1");
    academia.registrarEntrada(nome: "João", identificacao: "2");

    expect(
      () => academia.alterarCapacidade(1),
      throwsA(isA<AcademiaException>()),
    );
    academia.alterarCapacidade(50);
    expect(academia.capacidadeMaxima, 50);
  });
}
