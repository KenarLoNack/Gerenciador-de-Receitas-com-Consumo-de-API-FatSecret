import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

Future<Database> inicializarBanco() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'seubanco.db');

  // Verifica se o banco já existe
  final exists = await databaseExists(path);

  if (!exists) {
    // Copia o banco do assets
    final data = await rootBundle.load('assets/banco/seubanco.db');
    final bytes = data.buffer.asUint8List();

    await File(path).writeAsBytes(bytes, flush: true);
    print('Banco copiado com sucesso!');
  } else {
    print('Banco já existe!');
  }

  // Abre o banco
  return openDatabase(path);
}
