import 'package:flutter/material.dart';
import 'tela_principal.dart';

void main() async {
  runApp(const ParOuImparApp());
}

class ParOuImparApp extends StatelessWidget {
  const ParOuImparApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Par ou Ímpar',
      home: TelaPrincipal(),
    );
  }
}