import 'package:flutter/material.dart';

class Addingredient extends StatefulWidget {
 const Addingredient({super.key});

  @override
  State<Addingredient> createState() => _AddingredientState();
}

class _AddingredientState extends State<Addingredient> {
  final List ingredientes = ["item 1","item 1","item 1","item 1","item 1",];
  final TextEditingController searchIng = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
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
                Expanded(child: TextField(
              autofocus: true,
              controller: searchIng,
              decoration: InputDecoration(
              labelText: "Pesquisar Ingrediente",
              border: OutlineInputBorder(),
            ),

            ),),
            Icon(Icons.search),
              ],
            ),
            Expanded(child: ListView.builder(itemCount: ingredientes.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(ingredientes[index]),);
            },),),
          ],
        ),
    );
  }
}