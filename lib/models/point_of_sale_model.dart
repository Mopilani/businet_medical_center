import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_cache.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';



class PointOfSaleModel {
  PointOfSaleModel._();

  PointOfSaleModel(
    this.id, {
    this.number,
    this.groupId,
    this.placeName,
    this.area,
    this.country,
    this.managerPhoneNumber,
    this.state,
    this.town,
    this.deviceName,
    this.printerName,
    this.metadata = const {
      'recordShiftSANDT': true,
      'recordDaySANDT': true,
      'recordSuppliersTraffic': true,
      'recordCategoriesTraffic': true,
      'recordSubCategoriesTraffic': true,
      'recordSaleUnitsTraffic': true,
      'recordStocksTraffic': true,
      'recordPaymentMethodsTraffic': true,
      'recordSKUsTraffic': true,
      'recordBillsTraffic': true,
      'recordReceiptsTraffic': true,
      'recordReportsTraffic': true,
      'recordInvoicesTraffic': true,
      'recordUsersTraffic': true,
    },
  }) {
    setPos(this);
  }

  late int id;
  int? number;
  String? placeName;
  // late String catgoryName;
  String? managerPhoneNumber;
  String? town;
  String? area;
  String? state;
  String? country;
  double? balance;
  String? deviceName;
  String? printerName;
  String? groupId;
  Map<String, dynamic>? metadata;

  // Actions Recording Options
  bool? recordShiftSANDT = true;
  bool? recordDaySANDT = true;
  bool? recordSuppliersTraffic = true;
  bool? recordCategoriesTraffic = true;
  bool? recordSubCategoriesTraffic = true;
  bool? recordSaleUnitsTraffic = true;
  bool? recordStocksTraffic = true;
  bool? recordPaymentMethodsTraffic = true;
  bool? recordSKUsTraffic = true;
  bool? recordBillsTraffic = true;
  bool? recordReceiptsTraffic = true;
  bool? recordReportsTraffic = true;
  bool? recordInvoicesTraffic = true;
  bool? recordUsersTraffic = true;
  // bool recordTraffic = true;

  static PointOfSaleModel fromMap(Map<String, dynamic> data) {
    PointOfSaleModel model = PointOfSaleModel._();
    model.id = data['id'];
    model.number = data['number'];
    // model.catgoryName = data['catgoryName'];
    model.managerPhoneNumber = data['managerPhoneNumber'];
    model.town = data['town'];
    model.placeName = data['placeName'];
    model.area = data['area'];
    model.state = data['state'];
    model.country = data['country'];
    model.balance = data['balance'];
    model.deviceName = data['deviceName'];
    model.metadata = data['metadata'];
    model.printerName = data['printerName'];
    model.groupId = data['groupId'];

    model.recordShiftSANDT = model.metadata?['recordShiftSANDT'];
    model.recordDaySANDT = model.metadata?['recordDaySANDT'];
    model.recordSuppliersTraffic = model.metadata?['recordSuppliersTraffic'];
    model.recordCategoriesTraffic = model.metadata?['recordCategoriesTraffic'];
    model.recordSubCategoriesTraffic =
        model.metadata?['recordSubCategoriesTraffic'];
    model.recordSaleUnitsTraffic = model.metadata?['recordSaleUnitsTraffic'];
    model.recordStocksTraffic = model.metadata?['recordStocksTraffic'];
    model.recordPaymentMethodsTraffic =
        model.metadata?['recordPaymentMethodsTraffic'];
    model.recordSKUsTraffic = model.metadata?['recordSKUsTraffic'];
    model.recordBillsTraffic = model.metadata?['recordBillsTraffic'];
    model.recordReceiptsTraffic = model.metadata?['recordReceiptsTraffic'];
    model.recordReportsTraffic = model.metadata?['recordReportsTraffic'];
    model.recordInvoicesTraffic = model.metadata?['recordInvoicesTraffic'];
    model.recordUsersTraffic = model.metadata?['recordUsersTraffic'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'number': number,
        'placeName': placeName,
        // 'catgoryName': catgoryName,
        'managerPhoneNumber': managerPhoneNumber,
        'town': town,
        'area': area,
        'state': state,
        'country': country,
        'balance': balance,
        'deviceName': deviceName,
        'metadata': metadata,
        'printerName': printerName,
        'groupId': groupId,
      };

  String toJson() => json.encode(toMap());

  static PointOfSaleModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static PointOfSaleModel? get stored => SystemCache.get('pos');
  void _setPosd(PointOfSaleModel pos) => SystemCache.set('pos', pos);
  static void setPos(PointOfSaleModel? pos) => SystemCache.set('pos', pos);

  // static void _deleteUser() => SystemCache.remove('pos');

  static Future<List<PointOfSaleModel>> getAll() {
    List<PointOfSaleModel> models = [];
    return SystemMDBService.db
        .collection('systemFile')
        .find()
        .transform<PointOfSaleModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(PointOfSaleModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          models.add(subCatg);
        })
        .asFuture()
        .then((value) => models);
  }

  Stream<PointOfSaleModel>? stream() {
    return SystemMDBService.db.collection('systemFile').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(PointOfSaleModel.fromMap(data));
        },
      ),
    );
  }

  Future<PointOfSaleModel?> aggregate(List<dynamic> pipeline) async {
    var d =
        await SystemMDBService.db.collection('systemFile').aggregate(pipeline);

    return PointOfSaleModel.fromMap(d);
  }

  static Future<PointOfSaleModel?> init() async {
    var pos = await get(0);
    if (pos == null) {
      return null;
    }
    setPos(pos);
    return pos;
  }

  static Future<PointOfSaleModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('systemFile')
        .findOne(where.eq('id', id));
    // print(d);
    if (d == null) {
      return null;
    }

    return PointOfSaleModel.fromMap(d);
  }

  Future<PointOfSaleModel?> findByName(String name) async {
    var d = await SystemMDBService.db
        .collection('systemFile')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PointOfSaleModel.fromMap(d);
  }

  Future<PointOfSaleModel?> edit() async {
    var r = await SystemMDBService.db.collection('systemFile').update(
          where.eq('id', id),
          toMap(),
        );
    await init();

    print(r);
    return await init();
  }

  Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('systemFile').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('systemFile').insert(
          toMap(),
        );

    await init();
    print(r);
    return 1;
  }
}
