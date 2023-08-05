import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class OrganModel {
  OrganModel._();

  OrganModel(
    this.id, {
    required this.description,
  });

  late int id;
  late dynamic mid;
  late String description;

  static OrganModel fromMap(Map<String, dynamic> data) {
    OrganModel model = OrganModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.description = data['description'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
      };

  String toJson() => json.encode(toMap());

  static OrganModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<OrganModel>> getAll() {
    List<OrganModel> catgs = [];
    return SystemMDBService.db
        .collection('organs')
        .find()
        .transform<OrganModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(OrganModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<OrganModel> stream() {
    return SystemMDBService.db.collection('organs').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(OrganModel.fromMap(data));
        },
      ),
    );
  }

  Future<OrganModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db.collection('organs').aggregate(pipeline);

    return OrganModel.fromMap(d);
  }

  static Future<OrganModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('organs')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return OrganModel.fromMap(d);
  }

  static Future<OrganModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('organs')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return OrganModel.fromMap(d);
  }

  Future<OrganModel?> edit() async {
    var r = await SystemMDBService.db.collection('organs').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('organs').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('organs').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('organs').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
