import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}


class Academia {
  final String _nome;
  int _capacidadeMaxima;
  int _pessoasNoLocal;

  Academia.nova({required String nome, required int capacidadeMaxima})
    : _nome = nome,
      _capacidadeMaxima = capacidadeMaxima,
      _pessoasNoLocal = 0;

  // Getters
  String get nome => _nome;
  int get capacidadeMaxima => _capacidadeMaxima;
  int get pessoasNoLocal => _pessoasNoLocal;

  int get vagasDisponiveis => _capacidadeMaxima - _pessoasNoLocal;

  bool get estaVazia => _pessoasNoLocal == 0;
  bool get estaLotada => _pessoasNoLocal >= _capacidadeMaxima;

  //Quase cheia
  bool get estaQuaseCheia =>
      !estaLotada && _pessoasNoLocal >= (_capacidadeMaxima * 0.8);

  String get situacao {
    if (estaLotada) {
      return "Academia lotada";
    } else if (estaQuaseCheia) {
      return "Atenção: ambiente quase cheio";
    } else {
      return "Pode entrar";
    }
  }

  // Setter
  set capacidadeMaxima(int novaCapacidade) {
    if (novaCapacidade >= _pessoasNoLocal && novaCapacidade > 0) {
      _capacidadeMaxima = novaCapacidade;
    }
  }

  // Método: registra a entrada de uma pessoa 
  void entrar() {
    if (!estaLotada) {
      _pessoasNoLocal++;
    }
  }

  // Método: registra a saída de uma pessoa
  void sair() {
    if (!estaVazia) {
      _pessoasNoLocal--;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Oculta o banner de debug
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Academia academia = Academia.nova(
    nome: "Academia FIAP Fit",
    capacidadeMaxima: 50,
  );

  void decrement() {
    setState(() {
      academia.sair();
    });
    print("Pessoas no local: ${academia.pessoasNoLocal}");
  }

  void increment() {
    setState(() => academia.entrar());
    print("Pessoas no local: ${academia.pessoasNoLocal}");
  }

  bool get isEmpty => academia.estaVazia;
  bool get isFull => academia.estaLotada;

  //Cor da mensagem de situacao muda conforme a lotacao
  Color get corDaSituacao {
    if (academia.estaLotada) {
      return Colors.red;
    } else if (academia.estaQuaseCheia) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Controle de Lotação",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white
            ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/academia_fundo.jpg"),
            fit: BoxFit.cover,
            //Escurece a foto para o texto branco ficar legivel
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(150),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              academia.nome,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),

            //Capacidade maxima do ambiente
            Text(
              "Capacidade máxima: ${academia.capacidadeMaxima} pessoas",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            //4. Mensagem de situacao (vem do getter da classe)
            Text(
              academia.situacao,
              style: TextStyle(
                fontSize: 26,
                color: corDaSituacao,
                fontWeight: FontWeight.w700,
              ),
            ),

            //Contador de pessoas no local
            Text(
              academia.pessoasNoLocal.toString(),
              style: TextStyle(fontSize: 100, color: Colors.white),
            ),
            Text(
              "Vagas disponíveis: ${academia.vagasDisponiveis}",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //3. Regra de saida: desabilitado quando o ambiente esta vazio
                TextButton(
                  onPressed: isEmpty?null:decrement,
                  style: TextButton.styleFrom(
                    backgroundColor: isEmpty?Colors.white.withAlpha(90):Colors.white,
                    fixedSize: Size(100, 20),
                  ),
                  child: Text(
                    "Saiu",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),

                //Regra de entrada: desabilitado quando esta lotada
                TextButton(
                  onPressed: isFull?null:increment,
                  style: TextButton.styleFrom(
                    backgroundColor: isFull?Colors.white.withAlpha(90):Colors.white,
                    fixedSize: Size(100, 20),
                  ),
                  child: Text(
                    "Entrou",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
