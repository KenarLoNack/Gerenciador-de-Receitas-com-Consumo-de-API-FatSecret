import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'addingredient.dart';

class Addrecipe extends StatefulWidget {
  const Addrecipe({super.key});

  @override
  State<Addrecipe> createState() => _AddrecipeState();
}

class _AddrecipeState extends State<Addrecipe> {
  List<Map<String, dynamic>> ingredientes = [];
  List<TextEditingController> quantidadeControllers = [];
  List<String> unidadesSelecionadas = [];

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController nomeController = TextEditingController();
    final TextEditingController tempoController = TextEditingController();
    final TextEditingController porcoesController = TextEditingController();
    final TextEditingController preparoController = TextEditingController();

    final List<String> opcoesUnidade = [
      'g',
      'ml',
      'colher',
      'xícara'
    ]; // customize como quiser

    tempoController.text = "00:00";
    porcoesController.text = "1"; // valor inicial para porções

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.network(
                'https://placehold.co/600x600/png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome da Receita',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome da receita';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tempoController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Tempo de Preparo",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o tempo';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.all(
                                20), // controle o tamanho interno do botão
                            backgroundColor:
                                Colors.grey, // cor de fundo do botão (opcional)
                          ),
                          onPressed: () async {
                            Duration? duration =
                                await showModalBottomSheet<Duration>(
                              context: context,
                              builder: (BuildContext context) {
                                Duration selectedDuration =
                                    Duration(minutes: 30);
                                return SizedBox(
                                  height: 250,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CupertinoTimerPicker(
                                          mode: CupertinoTimerPickerMode.hm,
                                          initialTimerDuration:
                                              selectedDuration,
                                          onTimerDurationChanged:
                                              (Duration newDuration) {
                                            selectedDuration = newDuration;
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context, selectedDuration);
                                        },
                                        child: Text("Confirmar"),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );

                            if (duration != null) {
                              String twoDigits(int n) =>
                                  n.toString().padLeft(2, '0');
                              String formatted =
                                  "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}";
                              tempoController.text = formatted;
                            }
                          },
                          child: Icon(
                            Icons.timer_outlined,
                            size: 25,
                            color: Colors.white, // cor do ícone
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: porcoesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Porções",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            int initialPorcoes =
                                int.tryParse(porcoesController.text) ?? 1;

                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => Container(
                                height: 250,
                                color: CupertinoColors.systemBackground
                                    .resolveFrom(context),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 32,
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem:
                                                    initialPorcoes - 1),
                                        onSelectedItemChanged: (int value) {
                                          porcoesController.text =
                                              (value + 1).toString();
                                        },
                                        children: List.generate(
                                            100,
                                            (index) => Center(
                                                  child: Text('${index + 1}'),
                                                )),
                                      ),
                                    ),
                                    CupertinoButton(
                                      child: Text('Confirmar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe as porções';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    //lista de ingredientes

                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              clipBehavior: Clip.hardEdge,
                              child: ingredientes.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Adicionar ingredientes",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: ingredientes.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(ingredientes[index]
                                                    ['nome']),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                flex: 2,
                                                child: TextField(
                                                  controller:
                                                      quantidadeControllers[
                                                          index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: 'Qtd',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                flex: 2,
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: unidadesSelecionadas[
                                                      index],
                                                  onChanged: (valor) {
                                                    setState(() {
                                                      unidadesSelecionadas[
                                                          index] = valor!;
                                                    });
                                                  },
                                                  items: opcoesUnidade
                                                      .map((opcao) {
                                                    return DropdownMenuItem(
                                                      value: opcao,
                                                      child: Text(opcao),
                                                    );
                                                  }).toList(),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final List<Map<String, dynamic>> selectedIng =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Addingredient(),
                                ),
                              );

                              if (selectedIng.isNotEmpty) {
                                setState(() {
                                  ingredientes = selectedIng;
                                  quantidadeControllers = List.generate(
                                    ingredientes.length,
                                    (index) => TextEditingController(),
                                  );
                                  unidadesSelecionadas = List.generate(
                                    ingredientes.length,
                                    (index) => opcoesUnidade
                                        .first, // valor inicial: 'g'
                                  );
                                });
                              }
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: preparoController,
                      maxLines: 5,
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) {
                            return TextEditingValue(text: '');
                          }

                          final newText = newValue.text.replaceAllMapped(
                            RegExp(r'(^|\n)(?!• )'),
                            (match) => '${match.group(1)}• ',
                          );

                          final cleanedText =
                              newText.replaceAll(RegExp(r'•\s*$'), '');

                          return TextEditingValue(
                            text: cleanedText,
                            selection: TextSelection.collapsed(
                                offset: cleanedText.length),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Modo de preparo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Descreva o modo de preparo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Receita cadastrada com sucesso!'),
                            ),
                          );
                          // Aqui você pode salvar os dados, enviar para o banco, etc.
                        }
                      },
                      child: Text("Cadastrar Receita"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
