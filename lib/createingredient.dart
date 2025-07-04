import 'package:flutter/material.dart';
import 'bancosqflite.dart';

class Createingredient extends StatefulWidget {
  const Createingredient({super.key});

  @override
  State<Createingredient> createState() => _CreateingredientState();
}

class _CreateingredientState extends State<Createingredient> {
  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  final TextEditingController nome = TextEditingController();

  final TextEditingController calorias = TextEditingController();

  final TextEditingController carboidratos = TextEditingController();

  final TextEditingController proteinas = TextEditingController();

  final TextEditingController gordurasTotal = TextEditingController();

  final TextEditingController gordurasSaturadas = TextEditingController();

  final TextEditingController gordurasTrans = TextEditingController();

  final TextEditingController fibras = TextEditingController();

  final TextEditingController sodio = TextEditingController();

  final TextEditingController acucaresTotal = TextEditingController();

  final TextEditingController acucaresAdicionados = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Ingrediente"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 16),
                TextFormField(
                  controller: nome,
                  decoration: InputDecoration(
                    labelText: 'Nome do Ingrediente',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome do Ingrediente';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: calorias,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Calorias',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe as Calorias';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: carboidratos,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Carboidratos',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: proteinas,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Proteina',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: gordurasTotal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gorduras Totais',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: gordurasSaturadas,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gorduras Saturadas',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: gordurasTrans,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gorduras Trans',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: fibras,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Fibras',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: sodio,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Sodio',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: acucaresTotal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Açucares Totais',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: acucaresAdicionados,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Açucares Adicionados',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    try {
                      await BancoHelper().inserirDadosIngred(
                        nome.text,
                        parseDouble(calorias.text),
                        parseDouble(carboidratos.text),
                        parseDouble(proteinas.text),
                        parseDouble(gordurasTotal.text),
                        parseDouble(gordurasSaturadas.text),
                        parseDouble(gordurasTrans.text),
                        parseDouble(fibras.text),
                        parseDouble(sodio.text),
                        parseDouble(acucaresTotal.text),
                        parseDouble(acucaresAdicionados.text),
                      );

                      if (!mounted) return;

                      // Use o context antes do await para mostrar snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ingrediente cadastrado com sucesso!'),
                        ),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro: $e')),
                      );
                    }
                  },
                  child: Text("Cadastrar Ingrediente"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double parseDouble(String? text) {
  if (text == null || text.trim().isEmpty) return 0.0;
  return double.tryParse(text.replaceAll(',', '.')) ?? 0.0;
}
