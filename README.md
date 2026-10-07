# Academia FIAP Fit — Controle de Lotação 2.0

Aplicativo Flutter de **gerenciamento de acessos** da academia "Academia FIAP Fit".
Na versão 2.0 (Checkpoint 02) o app deixa de ser apenas um contador e passa a registrar
**quem** entra e sai do ambiente, mantendo as regras de capacidade do Checkpoint 01.

## Vídeo de demonstração

▶️ **[Assistir ao vídeo](COLE_AQUI_O_LINK_DO_VIDEO)**

## Ambiente escolhido

**Academia.** A interface segue o tema do CP1: fundo escuro com a foto da academia,
rosa como cor de destaque, tipografia de "placar" (Bebas Neue), ícones de treino e
ícone do app em formato de halter.

## Integrantes

- Luiz Felipe Kichimoto Valdevino — RM567726
- Matheus Carneiro — RM567753

## Funcionalidades

- **Cadastro de pessoas** (tela "Nova entrada") com nome, matrícula e data/hora da
  entrada registrada automaticamente, usando `TextField` + `TextEditingController`.
- **Lista de registros** com `ListView.builder`; cada item mostra nome, ID,
  data/hora de entrada (e de saída), e a situação (**No ambiente** ou **Saiu**).
- **Lotação em tempo real** (ex.: `12 / 50`) com barra de ocupação e mensagem
  de situação: *Pode entrar*, *Atenção: ambiente quase cheio* (a partir de 80%) ou
  *Academia lotada*.
- **Slidable**: ao deslizar um card aparecem as ações **SAÍDA** e **EXCLUIR**.
- **AlertDialog** de confirmação antes de registrar saída, excluir um registro e
  limpar os registros de quem já saiu.
- **SnackBar** (via `ScaffoldMessenger`) com o resultado de todas as operações.
- **Alteração da capacidade máxima** pelo botão de ajuste no painel de lotação.

### Regras de negócio

| Regra | Como o app trata |
|---|---|
| 1 — Capacidade | Com o ambiente lotado, o botão de nova entrada fica cinza e mostra *"Não é possível realizar a entrada. Ambiente lotado!"*. A capacidade também não pode ser reduzida abaixo do número de pessoas presentes. |
| 2 — Saída | Quem já saiu não pode ter a saída registrada de novo (a ação SAÍDA fica cinza e avisa o usuário). |
| 3 — Cadastro | Nome e matrícula são obrigatórios. |
| 4 — Identificação | Não é possível cadastrar uma matrícula que já está no ambiente. Depois que a pessoa sai, ela pode entrar de novo (gera um novo registro). |
| 5 — Feedback | Toda operação, com sucesso ou erro, exibe uma SnackBar. |

## Organização do projeto

```
lib/
├── main.dart                      # MaterialApp + tema
├── models/
│   ├── pessoa.dart                # classe Pessoa (entrada, saída, situação)
│   └── academia.dart              # classe Academia (lista de pessoas e regras de negócio)
├── screens/
│   ├── home_page.dart             # lotação + lista de registros
│   └── cadastro_page.dart         # formulário de nova entrada
├── widgets/
│   ├── pessoa_item.dart           # widget personalizado do item da lista (com Slidable)
│   ├── contador_lotacao.dart      # painel "Pessoas no ambiente"
│   ├── dialogo_confirmacao.dart   # AlertDialog de confirmação reutilizável
│   └── dialogo_capacidade.dart    # AlertDialog para alterar a capacidade
├── theme/
│   ├── app_colors.dart            # cores em hexadecimal
│   └── app_theme.dart             # ThemeData + Google Fonts
└── utils/
    ├── formatadores.dart          # datas com intl (dd/MM/yyyy às HH:mm)
    └── feedback.dart              # SnackBar padronizada
test/
├── academia_test.dart             # testes das regras de negócio
└── app_test.dart                  # teste do fluxo completo pela interface
```

**Widget personalizado e passagem de função:** o `PessoaItem` recebe o objeto `Pessoa`
e as funções `onSaida` e `onExcluir` pelo construtor. Quando o usuário toca em uma
ação do Slidable, o item apenas chama a função, e a `HomePage` (widget pai) faz a
operação. A `CadastroPage` funciona do mesmo jeito: ela recebe a função
`onCadastrar` e não conhece as regras da academia.

```dart
PessoaItem(
  pessoa: pessoa,
  onSaida: () => _registrarSaida(pessoa),
  onExcluir: () => _excluir(pessoa),
)
```

## Tecnologias e pacotes

- Flutter / Dart (SDK ^3.11.5), Material 3
- [`intl`](https://pub.dev/packages/intl): formatação de data e hora
- [`google_fonts`](https://pub.dev/packages/google_fonts): Bebas Neue e Poppins
- [`flutter_slidable`](https://pub.dev/packages/flutter_slidable): ações ao deslizar os itens
- [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons): ícone do app (halter)

## Como executar

Pré-requisito: Flutter instalado (`flutter doctor` sem erros) e um emulador ou celular conectado.

```bash
git clone https://github.com/luizkichimoto/Checkpoint-Mobile.git
cd Checkpoint-Mobile
flutter pub get
flutter run
```

As fontes do Google Fonts são baixadas na primeira execução, então o dispositivo precisa de internet.

Outros comandos úteis:

```bash
flutter test                       # roda os testes
dart run flutter_launcher_icons    # gera o ícone do app novamente
```
