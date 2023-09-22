import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: Consumo(),
  ));
}

class Consumo extends StatefulWidget {
  const Consumo({Key? key});

  @override
  State<Consumo> createState() => _ConsumoState();
}

class _ConsumoState extends State<Consumo> {
  String rua = "";
  String bairro = "";
  TextEditingController cepController = TextEditingController();

  _recuperarCep() async {
    String cep = cepController.text;
    String url = "https://api.postmon.com.br/v1/cep/${cep}";//api alternativa pois o viacep não rodou no cotuca
    //String url = "https://viacep.com.br/ws/${cep}/json/";
    final uri = Uri.parse(url);

    http.Response response;
    response = await http.get(uri);
    print(response.statusCode.toString());
    print(response.body);

    Map<String, dynamic> retorno = json.decode(response.body);
    print(retorno["logradouro"]);
    print(retorno["bairro"]);
    setState(() {
      rua = retorno["logradouro"];
      bairro = retorno["bairro"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("consumo de serviço Web"),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              const Text("Consumo ..."),
              const SizedBox(height: 10), 
              TextField(
                controller: cepController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  labelText: "CEP",
                  hintText: "Digite o CEP",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text("Pesquisar"),
                onPressed: () {
                  _recuperarCep();
                },
              ),
              const SizedBox(height: 20),
              Text(rua),
              Text(bairro),
            ],
          )),
    );
  }
}
