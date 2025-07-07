import 'package:flutter/material.dart';
import 'package:recipes_app_api/bancosqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'createingredient.dart';

//variavel global para persistencia de dados
List<Map<String, dynamic>> selecionados = [];

class Addingredient extends StatefulWidget {
  const Addingredient({super.key});

  @override
  State<Addingredient> createState() => _AddingredientState();
}

class _AddingredientState extends State<Addingredient> {
  late Database db;
  List<Map<String, dynamic>> ingredientes = [];
  Map<int, TextEditingController> quantidadeControllers = {};
  Map<int, String> unidadesSelecionadas = {};

  final List<String> opcoesUnidade = [' g', ' ml', ' colher', ' xícara'];

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
                final int id = ingrediente['id'];
                final String nome = ingrediente['nome'];
                final isSelected = selecionados.any((item) => item['id'] == id);

                // Garante que o controller existe
                final controller = quantidadeControllers.putIfAbsent(
                    id, () => TextEditingController());

                // Se já estiver selecionado, recupera dados
                if (isSelected) {
                  final itemSelecionado =
                      selecionados.firstWhere((item) => item['id'] == id);

                  // Atualiza texto se for diferente do atual
                  if (controller.text != itemSelecionado['quantidade']) {
                    controller.text = itemSelecionado['quantidade'] ?? '';
                  }

                  // Garante que unidade está setada
                  unidadesSelecionadas[id] ??=
                      itemSelecionado['unidade'] ?? opcoesUnidade.first;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Checkbox com nome do ingrediente
                      Expanded(
                        flex: 3,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(nome),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selecionados.add({
                                  ...ingrediente,
                                  'quantidade': '',
                                  'unidade': opcoesUnidade.first,
                                });
                                quantidadeControllers[id] =
                                    TextEditingController();
                                unidadesSelecionadas[id] = opcoesUnidade.first;
                              } else {
                                selecionados
                                    .removeWhere((item) => item['id'] == id);
                                quantidadeControllers.remove(id);
                                unidadesSelecionadas.remove(id);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),

                      // Campo de quantidade
                      if (isSelected)
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextField(
                              controller: quantidadeControllers[id],
                              keyboardType: TextInputType.number,
                              onChanged: (valor) {
                                final indexSelecionado =
                                    selecionados.indexWhere((item) =>
                                        item['id'] == ingrediente['id']);
                                if (indexSelecionado != -1) {
                                  setState(() {
                                    selecionados[indexSelecionado]
                                        ['quantidade'] = valor;
                                  });
                                }
                              },
                              readOnly: false,
                              decoration: InputDecoration(
                                labelText: 'Qtd',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),

                      // Dropdown de unidades
                      if (isSelected)
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: DropdownButtonFormField<String>(
                              value: unidadesSelecionadas[id],
                              onChanged: (valor) {
                                final indexSelecionado =
                                    selecionados.indexWhere((item) =>
                                        item['id'] == ingrediente['id']);
                                if (indexSelecionado != -1 && valor != null) {
                                  setState(() {
                                    selecionados[indexSelecionado]['unidade'] =
                                        valor;
                                  });
                                }
                              },
                              items: opcoesUnidade.map((opcao) {
                                return DropdownMenuItem(
                                  value: opcao,
                                  child: Text(opcao),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
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
                        Navigator.pop(context);
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
