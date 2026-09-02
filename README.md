# Academia CP — Controle de Lotação

Aplicativo Flutter que simula o controle de lotação de uma academia em tempo real.

## Integrantes

- Luiz Felipe Kichimoto Valdevino RM567726 
- Matheus Carneiro RM567753

## Sobre o projeto

O app exibe a situação atual da "Academia FIAP Fit", com capacidade máxima de 50 pessoas,
e permite registrar a entrada e a saída de alunos por meio dos botões **Entrou** e **Saiu**.

A regra de negócio fica encapsulada na classe `Academia`, que usa atributos privados,
getters, setters e métodos:

- `entrar()` / `sair()` — registram a movimentação de pessoas no local;
- `vagasDisponiveis` — calcula quantas vagas ainda existem;
- `estaVazia` / `estaLotada` / `estaQuaseCheia` — indicam o estado do ambiente
  (quase cheia a partir de 80% da capacidade);
- `situacao` — devolve a mensagem exibida na tela ("Pode entrar",
  "Atenção: ambiente quase cheio" ou "Academia lotada").

A interface reage a esses estados: a mensagem de situação muda de cor
(verde, laranja ou vermelho) conforme a ocupação, o botão **Saiu** é desabilitado
quando a academia está vazia e o botão **Entrou** é desabilitado quando está lotada.

## Tecnologias

- Flutter / Dart (SDK ^3.11.5)
- Material Design

## Como executar

```bash
flutter pub get
flutter run
```
