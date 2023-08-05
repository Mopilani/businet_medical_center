import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'dosing_model.dart';
import 'pharmaceutical_group_model.dart';

class PharmaceuticalModel {
  PharmaceuticalModel._();

  PharmaceuticalModel(
    this.id, {
    required this.group,
    required this.description,
  });

  late int id;
  late dynamic mid;
  late PharmaceuticalGroupModel group;
  late String description;

  static PharmaceuticalModel fromMap(Map<String, dynamic> data) {
    PharmaceuticalModel model = PharmaceuticalModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.group = PharmaceuticalGroupModel.fromMap(data['group']);
    model.description = data['description'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'group': group.toMap(),
        'description': description,
      };

  String toJson() => json.encode(toMap());

  static PharmaceuticalModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<PharmaceuticalModel>> getAll() {
    List<PharmaceuticalModel> catgs = [];
    return SystemMDBService.db
        .collection('pharmaceuticals')
        .find()
        .transform<PharmaceuticalModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(PharmaceuticalModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<PharmaceuticalModel> stream() {
    return SystemMDBService.db.collection('pharmaceuticals').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(PharmaceuticalModel.fromMap(data));
        },
      ),
    );
  }

  Future<PharmaceuticalModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticals')
        .aggregate(pipeline);

    return PharmaceuticalModel.fromMap(d);
  }

  static Future<PharmaceuticalModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticals')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PharmaceuticalModel.fromMap(d);
  }

  static Future<PharmaceuticalModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticals')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PharmaceuticalModel.fromMap(d);
  }

  Future<PharmaceuticalModel?> edit() async {
    var r = await SystemMDBService.db.collection('pharmaceuticals').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('pharmaceuticals').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('pharmaceuticals').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('pharmaceuticals').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}

class Treatment {
  Treatment(this.pharmaceutical, this.dose);
  DoseModel dose;
  PharmaceuticalModel pharmaceutical;

 static Treatment fromMap(Map<String, dynamic> data) {
    return Treatment(PharmaceuticalModel.fromMap(data['pharmaceutical']),
        DoseModel.fromMap(data['dose']));
  }

  Map<String, dynamic> toMap() => {
        'dose': dose.toMap(),
        'pharmaceutical': pharmaceutical.toMap(),
      };
}
