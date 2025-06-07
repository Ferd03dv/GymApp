// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mongodb {
  static Db? db; // Rende il database nullable

  static Future<void> connect() async {
    db = await Db.create(
        'mongodb+srv://Ferdinando:DesertStorm3.@gymapp.qsaqp.mongodb.net/');
    await db!.open();
    debugPrint('Connessione a DB stabilita: ${db!.serverStatus()}');
  }

  static DbCollection getCollection(String collectionName) {
    if (db == null) {
      throw Exception(
          "Il database non è stato inizializzato. Chiama 'Mongodb.connect()' prima.");
    }
    return db!.collection(collectionName);
  }
}
