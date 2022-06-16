// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const request = "https://api.hgbrasil.com/finance?format=json&key=3aac653b";

void main() async {
  /*http.Response response = await http.get(request);
  print(json.decode(response.body)["results"]["currencies"]["USD"]); //Consumindo uma API
  */

  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Color(0xFFEC994B),
        primaryColor: Color(0xFFF1EEE9),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF15133C))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEC994B))),
          hintStyle: TextStyle(color: Color(0xFFF1EEE9)),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

/*
15133C
73777B
EC994B
F1EEE9
*/

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF73777B),
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Conversor",
                style: TextStyle(
                  color: Color(0xFFF1EEE9),
                ),
              ),
            ),
            Expanded(
              child: Icon(
                Icons.monetization_on,
                size: 40.0,
                color: Color(0xFFEC994B),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF15133C),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Color(0xFFF1EEE9),
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados :(",
                    style: TextStyle(
                      color: Color(0xFFF1EEE9),
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      /*
                      Icon(Icons.monetization_on, size: 100.0, color: Color(0xFFEC994B),
                      ),*/
                      Divider(),
                      buildTextField("Real", "R", realController, _realChanged),
                      Divider(),
                      buildTextField(
                          "Dolar", "US", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("EUR", "€", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: "$label",
      labelStyle: TextStyle(
        color: Color(0xFFF1EEE9),
        fontSize: 17.0,
      ),
      border: OutlineInputBorder(),
      prefixText: "$prefix\$",
    ),
    style: TextStyle(
      color: Color(0xFFF1EEE9),
      fontSize: 20.0,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
