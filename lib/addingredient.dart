import 'package:flutter/material.dart';
import 'package:recipes_app_api/bancosqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'createingredient.dart';

class Addingredient extends StatefulWidget {
  const Addingredient({super.key});

  @override
  State<Addingredient> createState() => _AddingredientState();
}

class _AddingredientState extends State<Addingredient> {
  late Database db;
  List<Map<String, dynamic>> ingredientes = [];
  List<Map<String, dynamic>> selecionados = [];
  List<TextEditingController> quantidadeControllers = [];
  List<String> unidadesSelecionadas = [];

  final List<String> opcoesUnidade = ['g', 'ml', 'colher', 'xícara'];

  @override
  void initState() {
    super.initState();
    carregarIngredientes();
  }

  Future<void> carregarIngredientes() async {
    db = await BancoHelper().database;
    final resultado = await db.query('ingredientes', columns: ['id', 'nome']);

    setState(() {
      ingredientes = resultado;
    });
  }

  final TextEditingController searchIng = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Createingredient(),
                  ),
                );

                await carregarIngredientes();
              },
              icon: Icon(Icons.add)),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, <Map<String, dynamic>>[]);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: searchIng,
                  decoration: InputDecoration(
                    labelText: "Pesquisar Ingrediente",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Icon(Icons.search),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ingredientes.length,
              itemBuilder: (context, index) {
                final ingrediente = ingredientes[index];
                final nome = ingrediente['nome'] as String;
                final isSelected =
                    selecionados.any((item) => item['id'] == ingrediente['id']);

                return Row(
                  children: [
                    CheckboxListTile(
                      title: Text(nome),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selecionados.add(ingrediente);
                          } else {
                            selecionados.remove(ingrediente);
                          }
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: quantidadeControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Qtd',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: unidadesSelecionadas[index],
                        onChanged: (valor) {
                          setState(() {
                            unidadesSelecionadas[index] = valor!;
                          });
                        },
                        items: opcoesUnidade.map((opcao) {
                          return DropdownMenuItem(
                            value: opcao,
                            child: Text(opcao),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: ElevatedButton(
                      onPressed: () {
                        if (selecionados.isNotEmpty) {
                          Navigator.pop(context, selecionados);
                        } else {
                          Navigator.pop(context, <Map<String, dynamic>>[]);
                        }
                      },
                      child: Icon(Icons.check)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
