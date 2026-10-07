import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academia_cp/main.dart';

Future<void> cadastrar(WidgetTester tester, String nome, String id) async {
  await tester.tap(find.text("NOVA ENTRADA").last);
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), nome);
  await tester.enterText(find.byType(TextField).at(1), id);
  await tester.tap(find.text("REGISTRAR ENTRADA"));
  await tester.pumpAndSettle();
}

Future<void> deslizarETocar(WidgetTester tester, String nome, String acao) async {
  await tester.drag(find.text(nome), const Offset(-500, 0));
  await tester.pumpAndSettle();
  await tester.tap(find.text(acao));
  await tester.pumpAndSettle();
}

void main() {
  // Nos testes não há internet: usa a fonte padrão no lugar das Google Fonts
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets("fluxo completo de entrada, saída e exclusão", (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    expect(find.text("Academia vazia"), findsOneWidget);
    expect(find.text("0"), findsOneWidget);

    // Cadastro
    await cadastrar(tester, "Maria Silva", "123456");
    expect(find.text("Pessoa cadastrada com sucesso!"), findsOneWidget);
    expect(find.text("Maria Silva"), findsOneWidget);
    expect(find.text("ID: 123456"), findsOneWidget);
    expect(find.text("Situação: No ambiente"), findsOneWidget);
    expect(find.text("1"), findsOneWidget);

    // Regra 4: matrícula repetida mantém o usuário no formulário
    await cadastrar(tester, "Outra Pessoa", "123456");
    expect(find.text("A matrícula 123456 já está no ambiente."), findsOneWidget);
    expect(find.text("REGISTRAR ENTRADA"), findsOneWidget);

    // Regra 3: campos vazios
    await tester.enterText(find.byType(TextField).at(0), "");
    await tester.tap(find.text("REGISTRAR ENTRADA"));
    await tester.pumpAndSettle();
    expect(find.text("Preencha o nome e a matrícula."), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Saída pelo Slidable + AlertDialog
    await deslizarETocar(tester, "Maria Silva", "SAÍDA");
    expect(find.text("Registrar saída?"), findsOneWidget);
    expect(
      find.text("Deseja realmente registrar a saída de Maria Silva?"),
      findsOneWidget,
    );
    await tester.tap(find.text("CONFIRMAR"));
    await tester.pumpAndSettle();
    expect(find.text("Saída registrada com sucesso!"), findsOneWidget);
    expect(find.text("Situação: Saiu"), findsOneWidget);
    expect(find.text("0"), findsOneWidget);

    // Regra 2: não sai duas vezes
    await deslizarETocar(tester, "Maria Silva", "SAÍDA");
    expect(find.text("Maria Silva já saiu do ambiente."), findsOneWidget);
    expect(find.text("Registrar saída?"), findsNothing);

    // Exclusão
    await tester.drag(find.text("Maria Silva"), const Offset(500, 0));
    await tester.pumpAndSettle();
    await deslizarETocar(tester, "Maria Silva", "EXCLUIR");
    await tester.tap(find.text("CONFIRMAR"));
    await tester.pumpAndSettle();
    expect(find.text("Registro excluído com sucesso!"), findsOneWidget);
    expect(find.text("Academia vazia"), findsOneWidget);

    // Regra 1: capacidade
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "1");
    await tester.tap(find.text("SALVAR"));
    await tester.pumpAndSettle();
    expect(find.text("/ 1"), findsOneWidget);

    await cadastrar(tester, "João Santos", "987654");
    expect(find.text("Academia lotada"), findsOneWidget);
    await tester.tap(find.text("NOVA ENTRADA").last);
    await tester.pumpAndSettle();
    expect(
      find.text("Não é possível realizar a entrada. Ambiente lotado!"),
      findsOneWidget,
    );
    expect(find.text("REGISTRAR ENTRADA"), findsNothing);

    // Deixa a última SnackBar terminar
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
