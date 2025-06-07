// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/services.dart';

class Exercise {
  late String? bodyPart;
  late String? equipment;
  late String? gifFilename;
  late String? id;
  late String? name;
  late String? target;
  late List<String>? secondaryMuscles;
  late List<String>? instructions;
  String? reps;
  String? sets;
  String? timer;
  String? note;
  Map<String, dynamic>? superserie;

  Exercise({
    this.bodyPart,
    this.equipment,
    this.gifFilename,
    this.id,
    this.name,
    this.target,
    this.secondaryMuscles,
    this.instructions,
    reps = '',
    sets = '',
    timer = '',
    note = '',
    superserie = const {},
  });

  Exercise.fromJson(Map<String, dynamic> json) {
    bodyPart = json['bodyPart'];
    equipment = json['equipment'];
    gifFilename = json['gifFilename'];
    id = json['id'];
    name = json['name'];
    target = json['target'];
    secondaryMuscles = (json['secondaryMuscles'] ?? []).cast<String>();
    instructions = (json['instructions'] ?? []).cast<String>();
    reps = json['num_reps'];
    sets = json['num_sets'];
    timer = json['timer'];
    note = json['note'];
    superserie = json['superserie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bodyPart'] = bodyPart;
    data['equipment'] = equipment;
    data['gifFilename'] = gifFilename;
    data['id'] = id;
    data['name'] = name;
    data['target'] = target;
    data['secondaryMuscles'] = secondaryMuscles;
    data['instructions'] = instructions;
    data['num_reps'] = reps;
    data['num_sets'] = sets;
    data['timer'] = timer;
    data['note'] = note;
    data['superserie'] = superserie;
    return data;
  }

  Future<List<Exercise>> loadExercisesFromJson() async {
    // Carica il contenuto del file JSON
    String jsonContent = await rootBundle.loadString('assets/esercizi2.json');

    // Analizza il JSON
    List<dynamic> jsonList = jsonDecode(jsonContent);

    // Crea la lista di esercizi
    List<Exercise> exercises =
        jsonList.map((json) => Exercise.fromJson(json)).toList();

    return exercises;
  }
}
