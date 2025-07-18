import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'bancosqflite.dart';
import 'addingredient.dart';

Map<String, dynamic> dadosformreceita = {};

class Addrecipe extends StatefulWidget {
  const Addrecipe({super.key});

  @override
  State<Addrecipe> createState() => _AddrecipeState();
}

class _AddrecipeState extends State<Addrecipe> {
  List<Map<String, dynamic>> ingredientes = [];
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController tempoController = TextEditingController();
  final TextEditingController porcoesController = TextEditingController();
  final TextEditingController preparoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomeController.text = dadosformreceita['nome'] ?? '';
    tempoController.text = dadosformreceita['tempo'] ?? '';
    porcoesController.text = dadosformreceita['porcoes'] ?? '';
    preparoController.text = dadosformreceita['preparo'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    tempoController.text = "00:00";
    porcoesController.text = "1"; // valor inicial para porções

    return Scaffold(
      appBar: AppBar(
        title: Text("Adicione uma receita"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            dadosformreceita.clear();
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            color: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Adicionar ingredientes",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    dadosformreceita['nome'] =
                                        nomeController.text;
                                    dadosformreceita['tempo'] =
                                        tempoController.text;
                                    dadosformreceita['porcoes'] =
                                        porcoesController.text;
                                    dadosformreceita['preparo'] =
                                        preparoController.text;
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Addingredient(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 150),
                            child: Material(
                              color: Colors.transparent,
                              clipBehavior: Clip.hardEdge,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListView.builder(
                                  itemCount: selecionados.length,
                                  itemBuilder: (context, index) {
                                    return Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selecionados[index]['nome'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            selecionados[index]['quantidade'] +
                                                selecionados[index]['unidade'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await BancoHelper().inserirReceitas(
                              nomeController.text,
                              tempoController.text,
                              porcoesController.text,
                              '',
                              selecionados);

                          selecionados = [];

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Receita cadastrada com sucesso!'),
                            ),
                          );
                          dadosformreceita.clear();
                          Navigator.pop(context);
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
