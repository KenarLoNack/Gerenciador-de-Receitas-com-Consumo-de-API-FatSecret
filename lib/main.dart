import 'package:flutter/material.dart';
import 'addrecipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ListaDeBotoes());
  }
}

class ListaDeBotoes extends StatelessWidget {
  final List<String> titulos = [
    'Bolinho de Frango com batata',
    'Página B',
    'Página C'
  ];
  final List<String> imagens = [
    'https://eu.ui-avatars.com/api/?name=John+Doe&size=250',
    'https://eu.ui-avatars.com/api/?name=John+Doe&size=250',
    'https://eu.ui-avatars.com/api/?name=John+Doe&size=250',
  ];

  ListaDeBotoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Botões Personalizados'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Addrecipe(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: titulos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaGenerica(titulo: titulos[index]),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 6,
                fixedSize: Size(double.infinity, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25, left: 25, bottom: 25),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imagens[index],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25, right: 12),
                            child: Text(
                              titulos[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.local_fire_department, size: 22),
                              SizedBox(width: 6),
                              Text('200 kcal'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.fitness_center, size: 22),
                              SizedBox(width: 6),
                              Text('30g'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 22),
                              SizedBox(width: 6),
                              Text('20 min'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.star_border_rounded,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

class PaginaGenerica extends StatelessWidget {
  final String titulo;
  const PaginaGenerica({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Text(
          'Você está na $titulo',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
