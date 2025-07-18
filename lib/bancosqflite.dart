import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // <- necessário para desktop
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // <- necessário para web
import 'package:path/path.dart';
import 'dart:io';

class BancoHelper {
  static final BancoHelper _instance = BancoHelper._internal();
  Database? _database;

  factory BancoHelper() => _instance;

  BancoHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inicializarBanco();
    return _database!;
  }

  Future<Database> _inicializarBanco() async {
    late String path;
    if (kIsWeb) {
      // ✅ Web
      databaseFactory = databaseFactoryFfiWeb;
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'BancoTeste.db');
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // ✅ Desktop
      sqfliteFfiInit(); // <- necessário
      databaseFactory = databaseFactoryFfi;
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'BancoTeste.db');
    } else {
      // ✅ Android/iOS
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'BancoTeste.db');
    }

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE receitas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              tempo TEXT,
              porcoes TEXT,
              imagem TEXT,
              favorito INTEGER DEFAULT 0
            )
          ''');

          await db.execute('''
            CREATE TABLE ingredientes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              porcao REAL NOT NULL,
              unidade REAL NOT NULL,
              calorias REAL NOT NULL ,
              carboidratos REAL,
              proteinas REAL,
              gorduras_total REAL,
              gorduras_saturadas REAL,
              gorduras_trans REAL,
              fibras REAL,
              sodio REAL,
              acucares_total REAL,
              acucares_adicionados REAL
            )
          ''');

          await db.execute('''
            CREATE TABLE receitas_ingredientes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              receita_id INTEGER,
              ingrediente_id INTEGER,
              quantidade TEXT,
              FOREIGN KEY(receita_id) REFERENCES receitas(id),
              FOREIGN KEY(ingrediente_id) REFERENCES ingredientes(id)
            )
          ''');
        },
      ),
    );
  }

  Future<void> inserirDadosIngred(
      String nome,
      double calorias,
      double carboidratos,
      double proteinas,
      double gordTotal,
      double gordSat,
      double gordTrans,
      double fibras,
      double sodio,
      double acuTot,
      double acucarAdic) async {
    final db = await database;

    db.insert('ingredientes', {
      'nome': nome,
      'calorias': calorias,
      'carboidratos': carboidratos,
      'proteinas': proteinas,
      'gorduras_total': gordTotal,
      'gorduras_saturadas': gordSat,
      'gorduras_trans': gordTrans,
      'fibras': fibras,
      'sodio': sodio,
      'acucares_total': acuTot,
      'acucares_adicionados': acucarAdic,
    });
  }

  Future<void> inserirReceitas(String nome, String tempo, String porcoes,
      String imagempath, List<Map<String, dynamic>> ingredientes) async {
    final db = await database;

    // Inserir a receita e obter o ID gerado automaticamente
    final int receitaId = await db.insert('receitas', {
      'nome': nome,
      'tempo': tempo,
      'porcoes': porcoes,
      'imagem': imagempath,
    });

    for (final ingred in ingredientes) {
      await db.insert('receitas_ingredientes', {
        'receita_id': receitaId,
        'ingrediente_id': ingred['id'],
        'quantidade': ingred['quantidade']
      });
    }
  }
}
