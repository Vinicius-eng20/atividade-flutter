import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget {
  final Function? iniciarJogoOnClick;

  const TelaCadastro({super.key, this.iniciarJogoOnClick});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final txtNome = TextEditingController();

  Widget getTxtNome() {
    return Container(
      margin: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Informe seu nome',
        ),
        controller: txtNome,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Par ou Ímpar')),
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Cadastro do Jogador',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          getTxtNome(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (txtNome.text.isNotEmpty) {
                widget.iniciarJogoOnClick!(txtNome.text);
              }
            },
            child: const Text('Iniciar Jogo'),
          ),
        ],
      ),
    );
  }
}