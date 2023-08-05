import 'package:businet_medical_center/models/payment_method_model.dart';
import 'package:businet_medical_center/models/sale_unit_model.dart';
import 'package:businet_medical_center/models/sku_model.dart';
import 'package:businet_medical_center/utils/enums.dart';
import 'package:flutter/material.dart';

import '../../../models/bill_model.dart';
import '../../../models/delivery_model.dart';
import '../../../models/point_of_sale_model.dart';
import '../../../models/receipt_and_bill_payment_method_entry_model.dart';
import '../../../models/stock_model.dart';
import '../../../models/supplier_model.dart';
import '../../../models/user_model.dart';

class BillPageViewModel {
  factory BillPageViewModel() =>
      _billPageViewModelInstance ??
      () {
        _billPageViewModelInstance = BillPageViewModel._();
        return _billPageViewModelInstance!;
      }();
  BillPageViewModel._();

  PaymentMethodModel? selectedPaymentMethod;
  BillEntryModel? selectedBillEntry;
  late UserModel userModel;
  late DateTime createDate = DateTime.now();
  late DateTime incomingDate = DateTime.now();
  late DateTime? expierDate;
  late DateTime? returnDate;
  late DateTime? cancelDate;
  late StockModel stockModel;
  DeliveryModel? deliveryModel;
  late PointOfSaleModel pointOfSaleModel;
  BillState billState = BillState.onWait;
  late Map<String, BillEntryModel> billEntries = {};
  late List<BillPaymentMethodEntryModel> billPaymentMethods = [];
  late SupplierModel supplierModel;
  // BillPageViewModel viewModel = _;
  SaleUnitModel? saleUnitModel;

  late int id;
  String? note;
  SKUModel? foundSKU;
  double totalValuePrice = 0.0; // القيمة الاجمالية
  double totalTax = 0.0; // الضريبة الاجمالية
  double totalCost = 0.0; // التكلفة الكلية
  double totalDiscount = 0.0; // الحسم الكلي
  double totalQuantity = 0.0; //  الكمية الكلية
  double totalPayed = 0.0; // القيمة الكلية المدفوعة
  double totalWanted = 0.0; // القيمة الكلية المطلوبة

  int currentSaleUnitDropDownValue = 0;
  final List<SaleUnitModel> registeredSaleUnits = [];

  bool wasImportedToStock = false;

  var enterWasPressedAndHasentReturned = false;
  BillType selectedBillType = BillType.purchaseOrder;
  List<PaymentMethodModel> registeredPaymentMethods = [];

  void dispose() => _billPageViewModelInstance = null;

  void remake() {
    dispose();
    BillPageViewModel();
  }

  TextEditingController skuSearchController = TextEditingController();
  TextEditingController skuCostPriceController = TextEditingController();
  TextEditingController skuMaxPriceController = TextEditingController();
  TextEditingController skuSalePriceController = TextEditingController();
  TextEditingController skuQuantityController = TextEditingController();
  TextEditingController skuFreeQUantityController = TextEditingController();
  TextEditingController skuDiscController = TextEditingController();
  TextEditingController skuTaxController = TextEditingController();
  // TextEditingController skuTotalController = TextEditingController();
  TextEditingController skuNoteController = TextEditingController();

  TextEditingController containSizeController =
      TextEditingController(text: '0.0');
  TextEditingController expierMonthController = TextEditingController();
  TextEditingController expierYearController = TextEditingController();
}

BillPageViewModel? _billPageViewModelInstance;

final List<String> billTypes = [
  'طلب شراء',
  'استلام بضاعة',
  'امر بيع',
];

