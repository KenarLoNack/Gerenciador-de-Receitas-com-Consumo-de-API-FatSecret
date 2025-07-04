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
      appBar: AppBar(title: Text("Criar Ingrediente"),leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),),
    body: SingleChildScrollView(
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),child: Form(key: formKey,child: Column(
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
          decoration: InputDecoration(
            labelText: 'Carboidratos',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: proteinas,
          decoration: InputDecoration(
            labelText: 'Proteina',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: gordurasTotal,
          decoration: InputDecoration(
            labelText: 'Gorduras Totais',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: gordurasSaturadas,
          decoration: InputDecoration(
            labelText: 'Gorduras Saturadas',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: gordurasTrans,
          decoration: InputDecoration(
            labelText: 'Gorduras Trans',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: fibras,
          decoration: InputDecoration(
            labelText: 'Fibras',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: sodio,
          decoration: InputDecoration(
            labelText: 'Sodio',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: acucaresTotal,
          decoration: InputDecoration(
            labelText: 'Açucares Totais',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: acucaresAdicionados,
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
      await BancoHelper().inserirDados(
        nome.text,
        double.parse(calorias.text),
        double.parse(carboidratos.text),
        double.parse(proteinas.text),
        double.parse(gordurasTotal.text),
        double.parse(gordurasSaturadas.text),
        double.parse(gordurasTrans.text),
        double.parse(fibras.text),
        double.parse(sodio.text),
        double.parse(acucaresTotal.text),
        double.parse(acucaresAdicionados.text),
      );

      if (!mounted) return;

      // Use o context antes do await para mostrar snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ingrediente cadastrada com sucesso!'),
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
    ),),),
    ),
    );
  }
}