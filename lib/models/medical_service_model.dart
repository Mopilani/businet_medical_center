// MedicalServiceModel
import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MedicalServiceModel {
  MedicalServiceModel._();

  MedicalServiceModel(
    this.id,
    this.price,
    this.description,
  );

  late int id;
  late String description;
  late double price;

  static MedicalServiceModel fromMap(Map<String, dynamic> data) {
    MedicalServiceModel model = MedicalServiceModel._();
    model.id = data['id'];
    model.description = data['description'];
    model.price = data['price'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'price': price,
      };

  String toJson() => json.encode(toMap());

  static MedicalServiceModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<MedicalServiceModel>> getAll() {
    List<MedicalServiceModel> catgs = [];
    return SystemMDBService.db
        .collection('medical_services')
        .find()
        .transform<MedicalServiceModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(MedicalServiceModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<MedicalServiceModel>? stream() {
    return SystemMDBService.db.collection('medical_services').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(MedicalServiceModel.fromMap(data));
        },
      ),
    );
  }

  Future<MedicalServiceModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('medical_services')
        .aggregate(pipeline);

    return MedicalServiceModel.fromMap(d);
  }

  static Future<MedicalServiceModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('medical_services')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return MedicalServiceModel.fromMap(d);
  }

  static Future<MedicalServiceModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('medical_services')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return MedicalServiceModel.fromMap(d);
  }

  Future<MedicalServiceModel?> edit() async {
    var r = await SystemMDBService.db.collection('medical_services').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete() async {
    var r = await SystemMDBService.db.collection('medical_services').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('medical_services').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
