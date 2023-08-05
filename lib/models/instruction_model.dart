import 'dart:async';
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:businet_medical_center/utils/system_db.dart';

class InstructionModel {
  InstructionModel._();

  InstructionModel(
    this.id, {
    required this.content,
  });

  late int id;
  late dynamic mid;
  late String content;

  static InstructionModel fromMap(Map<String, dynamic> data) {
    InstructionModel model = InstructionModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.content = data['content'];

    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
      };

  String toJson() => json.encode(toMap());

  static InstructionModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<InstructionModel>> getAll() {
    List<InstructionModel> catgs = [];
    return SystemMDBService.db
        .collection('instructions')
        .find()
        .transform<InstructionModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(InstructionModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<InstructionModel>? stream() {
    return SystemMDBService.db.collection('instructions').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(InstructionModel.fromMap(data));
        },
      ),
    );
  }

  Future<InstructionModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('instructions')
        .aggregate(pipeline);

    return InstructionModel.fromMap(d);
  }

  static Future<InstructionModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('instructions')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return InstructionModel.fromMap(d);
  }

  static Future<InstructionModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('instructions')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return InstructionModel.fromMap(d);
  }

  Future<InstructionModel?> edit() async {
    var r = await SystemMDBService.db.collection('instructions').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete() async {
    var r = await SystemMDBService.db.collection('instructions').remove(
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
    var r = await SystemMDBService.db.collection('instructions').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
