import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'tela_cadastro.dart';
import 'tela_jogo.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  Widget? telaAtual;

  _TelaPrincipalState() {
    telaAtual = SplashScreen(onTimeout: () => verificarJogadorExistente());
  }

  void verificarJogadorExistente() {
    exibirTelaCadastro();
  }

  void exibirTelaCadastro() {
    setState(() {
      telaAtual = TelaCadastro(
        iniciarJogoOnClick: (nome) {
          exibirTelaJogo(nome: nome);
        },
      );
    });
  }

  void exibirTelaJogo({String nome = ''}) {
    setState(() {
      telaAtual = TelaJogo(jogador: nome);
    });
  }

  @override
  Widget build(BuildContext context) {
    return telaAtual!;
  }
}