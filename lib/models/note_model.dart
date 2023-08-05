import 'dart:async';
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:businet_medical_center/utils/system_db.dart';

class NoteModel {
  NoteModel._();

  NoteModel(
    this.id, {
    required this.content,
  });

  late int id;
  late String content;

  static NoteModel fromMap(Map<String, dynamic> data) {
    NoteModel model = NoteModel._();
    model.id = data['id'];
    model.content = data['content'];

    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
      };

  String toJson() => json.encode(toMap());

  static NoteModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<NoteModel>> getAll() {
    List<NoteModel> catgs = [];
    return SystemMDBService.db
        .collection('notes')
        .find()
        .transform<NoteModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(NoteModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<NoteModel>? stream() {
    return SystemMDBService.db.collection('notes').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(NoteModel.fromMap(data));
        },
      ),
    );
  }

  Future<NoteModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db.collection('notes').aggregate(pipeline);

    return NoteModel.fromMap(d);
  }

  static Future<NoteModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('notes')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return NoteModel.fromMap(d);
  }

  static Future<NoteModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('notes')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return NoteModel.fromMap(d);
  }

  Future<NoteModel?> edit() async {
    var r = await SystemMDBService.db.collection('notes').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete() async {
    var r = await SystemMDBService.db.collection('notes').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('notes').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
