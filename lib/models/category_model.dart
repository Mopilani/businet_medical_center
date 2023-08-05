import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'sku_model.dart';

class CatgoryModel {
  CatgoryModel._();
  CatgoryModel(this.id, this.catgoryName, this.catgoryDescription);
  dynamic id;
  late String catgoryName;
  late String catgoryDescription;

  static CatgoryModel fromMap(Map<String, dynamic> data) {
    CatgoryModel model = CatgoryModel._();
    model.id = data['id'];
    model.catgoryName = data['catgoryName'];
    model.catgoryDescription = data['catgoryDescription'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'catgoryName': catgoryName,
        'catgoryDescription': catgoryDescription,
      };

  String toJson() => json.encode(toMap());

  static CatgoryModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<CatgoryModel>> getAll() {
    List<CatgoryModel> catgs = [];
    return SystemMDBService.db
        .collection('categories')
        .find()
        .transform<CatgoryModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(CatgoryModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  Stream<CatgoryModel>? stream() {
    return SystemMDBService.db.collection('categories').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(CatgoryModel.fromMap(data));
        },
      ),
    );
  }

  Future<CatgoryModel?> aggregate(List<dynamic> pipeline) async {
    var d =
        await SystemMDBService.db.collection('categories').aggregate(pipeline);

    return CatgoryModel.fromMap(d);
  }

  static Future<CatgoryModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('categories')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return CatgoryModel.fromMap(d);
  }

  static Future<CatgoryModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('categories')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return CatgoryModel.fromMap(d);
  }

  Future<CatgoryModel?> edit() async {
    var r = await SystemMDBService.db.collection('categories').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete() async {
    var skuStream = SKUModel.stream();
    bool canBeDeleted = true;
    skuStream.listen((sku) {
      if (sku.catgoryModel!.catgoryName == catgoryName) {
        canBeDeleted = false;
      }
    });
    if (!canBeDeleted) {
      return -1;
    }
    var r = await SystemMDBService.db.collection('categories').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('categories').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
