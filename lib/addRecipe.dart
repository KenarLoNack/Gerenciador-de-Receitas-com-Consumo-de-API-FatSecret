import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Addrecipe extends StatelessWidget {
  const Addrecipe({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController tempoController = TextEditingController();
    final TextEditingController porcoesController = TextEditingController();
    final TextEditingController preparoController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicione uma receita"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25, left: 25, bottom: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://placehold.co/80x80?text=Hello+World',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(
              runSpacing: 10,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Receita',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: tempoController,
                  decoration: InputDecoration(
                    labelText: "Tempo de Sono",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: porcoesController,
                  decoration: InputDecoration(
                    labelText: "Porções",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: preparoController,
                  maxLines: 5,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final newText = newValue.text.replaceAllMapped(
                        RegExp(r'(^|\n)(?!• )'),
                        (match) => '${match.group(1)}• ',
                      );
                      return TextEditingValue(
                        text: newText,
                        selection:
                            TextSelection.collapsed(offset: newText.length),
                      );
                    }),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Modo de preparo',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
