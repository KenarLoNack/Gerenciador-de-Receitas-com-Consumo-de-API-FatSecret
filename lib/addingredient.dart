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
            Navigator.pop(context);
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

                return CheckboxListTile(
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
                        Navigator.pop(context, selecionados);
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
