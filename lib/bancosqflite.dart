import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class BancoHelper {
  static final BancoHelper _instance = BancoHelper._internal();
  Database? _database;

  factory BancoHelper() {
    return _instance;
  }

  BancoHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inicializarBanco();
    return _database!;
  }

  Future<Database> _inicializarBanco() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      print("object");
      return openDatabase('BancoTeste.db');
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'BancoTeste.db');

      final exists = await databaseExists(path);
      if (!exists) {
        final data = await rootBundle.load('assets/banco/BancoTeste.db');
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes, flush: true);
        print('Banco copiado!');
      } else {
        print('Banco já existe!');
      }

      return openDatabase(path);
    }
  }
}
