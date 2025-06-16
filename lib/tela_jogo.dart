import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaJogo extends StatefulWidget {
  final String jogador;

  const TelaJogo({super.key, required this.jogador});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  int pontos = 1000;
  int aposta = 0;
  int numero = 1;
  bool par = true;
  List<dynamic> jogadores = [];
  dynamic oponenteSelecionado;

  final TextEditingController _apostaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarJogadores();
  }

  Future<void> carregarJogadores() async {
    final url = Uri.https('par-impar.glitch.me', 'jogadores');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        jogadores = jsonDecode(response.body)['jogadores'];
      });
    }
  }

  Future<void> fazerAposta() async {
    final url = Uri.https('par-impar.glitch.me', 'aposta');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': widget.jogador,
      'valor': aposta,
      'parimpar': par ? 2 : 1,
      'numero': numero,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonDecode(response.body)['msg'])),
      );
    }
  }

  Future<void> jogar() async {
    if (oponenteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um oponente')),
      );
      return;
    }

    final url = Uri.https(
      'par-impar.glitch.me',
      'jogar/${widget.jogador}/${oponenteSelecionado['username']}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resultado = jsonDecode(response.body);
      final vencedor = resultado['vencedor'];
      final perdedor = resultado['perdedor'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Resultado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vencedor: ${vencedor['username']}'),
              Text('Número: ${vencedor['numero']}'),
              Text('Escolha: ${vencedor['parimpar'] == 2 ? 'Par' : 'Ímpar'}'),
              const SizedBox(height: 20),
              Text('Perdedor: ${perdedor['username']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                atualizarPontos();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> atualizarPontos() async {
    final url = Uri.https('par-impar.glitch.me', 'pontos/${widget.jogador}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        pontos = jsonDecode(response.body)['pontos'];
      });
    }
  }

  Widget getListaJogadores() {
    return ListView.builder(
      itemBuilder: (context, id) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            key: Key(id.toString()),
            tileColor: oponenteSelecionado == jogadores[id]
                ? Colors.green[200]
                : Colors.black12,
            title: Text(jogadores[id]['username']),
            subtitle: Text('Pontos: ${jogadores[id]['pontos']}'),
            onTap: () {
              setState(() {
                oponenteSelecionado = jogadores[id];
              });
            },
            trailing: const Icon(Icons.ads_click),
          ),
        );
      },
      itemCount: jogadores.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Par ou Ímpar - ${widget.jogador}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Seus Pontos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pontos.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Faça sua aposta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _apostaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Valor da aposta',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          aposta = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: fazerAposta,
                    child: const Text('Apostar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Escolha um número',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  final num = index + 1;
                  return ChoiceChip(
                    label: Text(num.toString()),
                    selected: numero == num,
                    onSelected: (selected) {
                      setState(() {
                        numero = num;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                'Escolha Par ou Ímpar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: const Text('Par'),
                    selected: par,
                    onSelected: (selected) {
                      setState(() {
                        par = true;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Ímpar'),
                    selected: !par,
                    onSelected: (selected) {
                      setState(() {
                        par = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Selecione um oponente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: getListaJogadores(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: jogar,
                child: const Text('Jogar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}