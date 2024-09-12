import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _inputCepController = TextEditingController();
  String _resultado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: const Text('Consumindo Serviço - CEP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
              ),
              controller: _inputCepController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[600],
              ),
              onPressed: _recuperarCep,
              child: const Text('Buscar Cep', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Text(
              _resultado,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _recuperarCep() async {
    String cep = _inputCepController.text;
    if (cep.isEmpty || cep.length < 8 || cep.length > 8) {
      setState(() {
        _resultado = 'CEP inválido';
      });
      return;
    }

    var url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    var response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);
    var logradouro = retorno['logradouro'];
    var bairro = retorno['bairro'];
    var localidade = retorno['localidade'];
    var uf = retorno['uf'];

    if (response.statusCode == 200) {
      setState(() {
        _resultado = '• Logradouro: $logradouro \n• Bairro: $bairro \n• Localidade: $localidade \n• UF: $uf';
      });
    }
  }
}
