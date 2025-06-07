// ignore_for_file: file_names

/*import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

Future<void> uploadGif(String assetPath, String filename) async {
    try {
      final Uri uri = Uri.parse('http://192.168.1.77:3000/upload-gif');

      // Carica il file dai tuoi asset
      final ByteData byteData = await rootBundle.load(assetPath);
      final Uint8List bytes = byteData.buffer.asUint8List();

      // Crea una richiesta multipart
      final request = http.MultipartRequest('POST', uri)
        ..fields['filename'] = filename
        ..files.add(http.MultipartFile.fromBytes(
          'gif',
          bytes,
          filename: filename,
          contentType: MediaType('image', 'webp'),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('✅ Caricato: $filename');
      } else {
        print('❌ Errore nel caricamento: $filename');
      }
    } catch (e) {
      print('❌ Eccezione: $e');
    }
  }

  Future<List<String>> loadGifPathsFromJson() async {
    final String jsonString =
        await rootBundle.loadString('assets/esercizi2.json');
    final List<dynamic> exercises = json.decode(jsonString);

    return exercises.map<String>((e) => e['gifUrl'] as String).toList();
  }

   final List<String> gifPaths =
                                                await authProvider
                                                    .loadGifPathsFromJson();

                                            for (final path in gifPaths) {
                                              final filename =
                                                  path.split('/').last;
                                              await authProvider.uploadGif(
                                                  path, filename);
                                            }
*/