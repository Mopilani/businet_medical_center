import 'package:businet_medical_center/models/sale_unit_model.dart';
import 'package:businet_medical_center/models/system_config.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:businet_medical_center/utils/enums.dart';
import 'package:businet_medical_center/views/mangment_views/stocks_views/stock_view.dart';
import 'package:businet_medical_center/views/mangment_views/stocks_views/stocks_view.dart';
import 'package:businet_medical_center/views/mangment_views/suppliers_views/suppliers_view.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:date_time_picker/date_time_picker.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:updater/updater.dart' as updater;

import '../../../models/bill_model.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/point_of_sale_model.dart';
import '../../../models/sku_model.dart';
import '../../../models/stock_model.dart';
import '../../../models/supplier_model.dart';
import 'bill_form_printer.dart';
import 'bills_control_page_view_model.dart';
import 'widgets.dart';

class BillsControle extends StatefulWidget {
  const BillsControle({
    Key? key,
    this.model,
    this.editMode = false,
  }) : super(key: key);
  final BillModel? model;
  final bool editMode;

  @override
  State<BillsControle> createState() => _BillsControleState();
}

class _BillsControleState extends State<BillsControle> {
  late FocusNode idNode = FocusNode();
  late FocusNode supplierSearchNode = FocusNode();
  late FocusNode stockSearchNode = FocusNode();
  late FocusNode payedNode = FocusNode();
  late FocusNode wantedNode = FocusNode();

  late FocusNode skuSearchNode = FocusNode();
  late FocusNode skuCostPriceNode = FocusNode();
  late FocusNode skuMaxPriceNode = FocusNode();
  late FocusNode skuSalePriceNode = FocusNode();
  late FocusNode skuQuantityNode = FocusNode();
  late FocusNode skuFreeQuantityNode = FocusNode();
  late FocusNode skuDiscNode = FocusNode();
  late FocusNode skuTaxNode = FocusNode();
  late FocusNode skuTotalNode = FocusNode();
  late FocusNode skuNoteNode = FocusNode();

  late FocusNode expierMonthNode = FocusNode();
  late FocusNode expierYearNode = FocusNode();

  late TextEditingController idController;
  late TextEditingController supplierSearchController;
  late TextEditingController stockSearchController;
  late TextEditingController totalController;
  late TextEditingController noteController;
  late TextEditingController payedController;
  late TextEditingController wantedController;

  @override
  void initState() {
    super.initState();
    initStateShared();
  }

  void initStateShared() {
    BillPageViewModel();
    if (widget.editMode && !canceling) {
      BillPageViewModel().id = widget.model!.id; // number
      BillPageViewModel().note = widget.model!.note; // String Note
      BillPageViewModel().totalValuePrice = widget.model!.total; // value
      BillPageViewModel().totalPayed = widget.model!.payed; // value
      BillPageViewModel().totalQuantity = widget.model!.quantity; // value
      BillPageViewModel().totalWanted = widget.model!.wanted; // value
      BillPageViewModel().createDate = widget.model!.createDate; // Selector
      BillPageViewModel().incomingDate = widget.model!.incomingDate; // Selector
      BillPageViewModel().expierDate = widget.model!.expierDate; // Selector
      BillPageViewModel().returnDate = widget.model!.returnDate; // Invisable
      BillPageViewModel().cancelDate = widget.model!.cancelDate; // Invisable
      BillPageViewModel().userModel = widget.model!.userModel;
      BillPageViewModel().stockModel = widget.model!.stockModel;
      BillPageViewModel().deliveryModel = widget.model!.deliveryModel;
      BillPageViewModel().pointOfSaleModel = widget.model!.pointOfSaleModel;
      BillPageViewModel().billPaymentMethods = widget.model!.billPaymentMethods;
      BillPageViewModel().billEntries = widget.model!.billEntries;
      BillPageViewModel().supplierModel = widget.model!.supplierModel;
      BillPageViewModel().billState = widget.model!.billState;
      BillPageViewModel().selectedBillType = widget.model!.billType!;
      if (!canceling) {
        BillPageViewModel().wasImportedToStock =
            widget.model!.wasImported ?? false;
      }
      idController =
          TextEditingController(text: BillPageViewModel().id.toString());
      totalController = TextEditingController(
          text: BillPageViewModel().totalValuePrice.toString());
      payedController = TextEditingController(
          text: BillPageViewModel().totalPayed.toString());
      payedController = TextEditingController(
          text: BillPageViewModel().totalQuantity.toString());
      wantedController = TextEditingController(
          text: BillPageViewModel().totalWanted.toString());
      BillPageViewModel().skuSearchController = TextEditingController();
      supplierSearchController = TextEditingController(
          text: BillPageViewModel().supplierModel.name.toString());
      stockSearchController = TextEditingController(
          text: BillPageViewModel().stockModel.title.toString());
      noteController = TextEditingController(text: BillPageViewModel().note);
      // BillPageViewModel().skuTotalController =
      //     TextEditingController(text: 0.0.toString());
      ready = true;
      resumTotals();
      // print(
      //     'widget.model!.billPaymentMethods: ${widget.model!.billPaymentMethods}');
      for (var paymentMethod in BillPageViewModel().billPaymentMethods) {
        BillPageViewModel().totalPayed = paymentMethod.value;
        BillPageViewModel().totalWanted =
            BillPageViewModel().totalCost - BillPageViewModel().totalPayed;
      }
      SaleUnitModel.findById(0).then((value) {
        if (value == null) {
          toast(
              'لا يوجد وحدات بيع محفوظة من قبل ليتم عرضها, قد تحتاج الى اضافة وحدات بيع قبل البدء في استخدام البرنامج');
          return;
        }
        BillPageViewModel().saleUnitModel = value;
        BillPageViewModel().containSizeController.text =
            value.quantity.toString();
      });
      PaymentMethodModel.get(0).then((value) {
        BillPageViewModel().selectedPaymentMethod = value;
      });
    } else {
      supplierSearchController = TextEditingController();
      stockSearchController = TextEditingController();
      noteController = TextEditingController();

      idController = TextEditingController();
      totalController = TextEditingController(text: 0.0.toString());
      payedController = TextEditingController(text: 0.0.toString());
      wantedController = TextEditingController(text: 0.0.toString());

      BillPageViewModel().skuCostPriceController =
          TextEditingController(text: 0.0.toString());
      BillPageViewModel().skuMaxPriceController =
          TextEditingController(text: 0.0.toString());
      BillPageViewModel().skuSalePriceController =
          TextEditingController(text: 0.0.toString());
      BillPageViewModel().skuQuantityController =
          TextEditingController(text: 0.0.toString());
      BillPageViewModel().skuFreeQUantityController =
          TextEditingController(text: 0.0.toString());
      BillPageViewModel().skuDiscController =
          TextEditingController(text: 0.0.toString());
      BillPageViewModel().skuTaxController =
          TextEditingController(text: 0.0.toString());
      // BillPageViewModel().skuTotalController =
      //     TextEditingController(text: 0.0.toString());

      BillPageViewModel().createDate = DateTime.now();
      BillPageViewModel().incomingDate = DateTime.now();
      BillPageViewModel().expierDate = DateTime.now();

      BillPageViewModel().skuSearchController = TextEditingController();
      BillPageViewModel().skuNoteController = TextEditingController();
      getAwaiters();
    }
    canceling = false;
  }

  getAwaiters() async {
    BillPageViewModel().pointOfSaleModel = PointOfSaleModel.stored!;
    BillPageViewModel().userModel = UserModel.stored!;
    SaleUnitModel.findById(0).then((value) {
      if (value == null) {
        toast(
            'لا يوجد وحدات بيع محفوظة من قبل ليتم عرضها, قد تحتاج الى اضافة وحدات بيع قبل البدء في استخدام البرنامج');
        return;
      }
      BillPageViewModel().saleUnitModel = value;
      BillPageViewModel().containSizeController.text =
          value.quantity.toString();
    });
    BillPageViewModel().supplierModel = (await SupplierModel.findById(0))!;
    BillPageViewModel().stockModel = (await StockModel.findById(0))!;
    BillPageViewModel().selectedPaymentMethod =
        (await PaymentMethodModel.get(0))!;
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.editMode) {
      cancelAny();
    }
  }

  bool loading = false;
  bool ready = false;
  bool canceling = false;

  void cancelAny() {
    canceling = true;
    loading = false;
    ready = false;
    BillPageViewModel().wasImportedToStock = false;
    BillPageViewModel().totalValuePrice = .0;
    BillPageViewModel().totalCost = .0;
    BillPageViewModel().totalDiscount = .0;
    BillPageViewModel().totalQuantity = .0;
    BillPageViewModel().totalPayed = .0;
    BillPageViewModel().totalWanted = .0;
    BillPageViewModel().note = null;
    BillPageViewModel().foundSKU = null;
    BillPageViewModel().createDate = DateTime.now();
    BillPageViewModel().incomingDate = DateTime.now();
    BillPageViewModel().expierDate = DateTime.now();
    BillPageViewModel().skuCostPriceController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().skuMaxPriceController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().skuSalePriceController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().skuQuantityController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().skuFreeQUantityController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().skuDiscController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().skuTaxController =
        TextEditingController(text: 0.0.toString());
    // BillPageViewModel().skuTotalController =
    //     TextEditingController(text: 0.0.toString());

    BillPageViewModel().containSizeController =
        TextEditingController(text: 0.0.toString());
    BillPageViewModel().expierMonthController = TextEditingController();
    BillPageViewModel().expierYearController = TextEditingController();
    // BillPageViewModel().skuSearchController = TextEditingController();

    idController.clear();
    totalController.clear();
    payedController.clear();
    wantedController.clear();
    BillPageViewModel().skuSearchController.clear();
    supplierSearchController.clear();
    stockSearchController.clear();
    noteController.clear();

    BillPageViewModel().billPaymentMethods.clear();
    BillPageViewModel().billEntries.clear();
    BillPageViewModel().billState = BillState.onWait;

    BillPageViewModel().currentSaleUnitDropDownValue = 0;
    BillPageViewModel().remake();
    initStateShared();
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    return updater.UpdaterBloc(
      updater: BillControleViewUpdater(
        init: 0,
        updateForCurrentEvent: true,
      ),
      update: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.editMode ? 'edit_bill'.tr : 'add_bill'.tr,
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: SizedBox(
                width: 250,
                child: loading
                    ? const CircularProgressIndicator()
                    : TextField(
                        controller: TextEditingController(
                          text: BillPageViewModel().pointOfSaleModel.placeName,
                        ),
                      ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: !widget.editMode
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillFormPrinter(
                              billForm: widget.model!,
                            ),
                          ),
                        );
                      },
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () {
                    writeNoteDialog(context, noteController);
                  },
                  color: Colors.grey,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'ملاحظة',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                firstBar(context),
                body(context),
                skuEntryFields(context),
                totalsViews(context),
                buttonsRow(context),
              ],
            ),
          ),
          // FutureBuilder<List<CatgoryModel>>(
          //   future: CatgoryModel.getAll(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return const Text('حدث خطأ اثناء تحميل البيانات');
          //     }
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const CircularProgressIndicator();
          //     }
          //     if (snapshot.hasData) {
          //       models.addAll(snapshot.data!);
          //     }
          //     return Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Column(
          //         children: models.map(
          //           (model) {
          //             return Text(model.catgoryName);
          //           },
          //         ).toList(),
          //       ),
          //     );
          //   },
          // ),
        );
      },
    );
  }

  Widget firstBar(context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: FocusableField(
            idController,
            idNode,
            'bill_number',
            (result) async {
              var bill = await BillModel.get(int.parse(result));
              if (bill != null) {
                showSimpleNotification(
                  const Text(
                    'هناك فاتورة مسجلة بهذا المعرف',
                    style: TextStyle(fontSize: 20),
                  ),
                  position: NotificationPosition.bottom,
                );
                idController.text = '';
                return false;
              }
              // print(bill?.id);
              ready = true;
              BillPageViewModel().id = int.parse(result);
              BillControleViewUpdater().add(0);
              return true;
            },
            supplierSearchNode,
            supplierSearchController,
            'لا يمكنك ترك معرف المورد فارغا',
            true,
          ),
        ),
        SizedBox(
          width: 200,
          child: FocusableField(
            supplierSearchController,
            supplierSearchNode,
            'supplier',
            (result) async {
              var r = await SupplierModel.findByName(result);
              if (r != null) {
              } else {
                var supplierId = int.tryParse(result);
                if (supplierId == null) {
                } else {
                  r = await SupplierModel.get(supplierId);
                  supplierSearchController.text =
                      BillPageViewModel().supplierModel.name;
                  if (r == null) {
                    // ignore: use_build_context_synchronously
                    var r = await Navigator.push<SupplierModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SuppliersView(choosing: true),
                      ),
                    ).then<bool>((value) {
                      if (value == null) return false;
                      BillPageViewModel().supplierModel = value;
                      supplierSearchController.text =
                          BillPageViewModel().supplierModel.name;
                      return true;
                    });
                    return r;
                  }
                  BillPageViewModel().supplierModel = r;
                }
              }
              supplierSearchController.text =
                  BillPageViewModel().supplierModel.name;
              return true;
            },
            stockSearchNode,
            stockSearchController,
            'لا يمكنك ترك معرف المورد فارغا',
            false,
            false,
            false,
            ready,
          ),
        ),
        // BillPageViewModel().selectedBillType == BillType.goodsReceived
        SizedBox(
          width: 200,
          child: FocusableField(
            stockSearchController,
            stockSearchNode,
            'stock',
            (result) async {
              StockModel? model = await StockModel.findByTitle(result);
              if (model != null) {
              } else {
                var stockId = int.tryParse(result);
                if (stockId == null) {
                  return false;
                } else {
                  model = await StockModel.get(stockId);
                  // supplierSearchController.text = model!.title;
                  stockSearchController.text =
                      BillPageViewModel().stockModel.title;
                  // BillPageViewModel().stockModel = r;
                  if (model == null) {
                    // ignore: use_build_context_synchronously
                    var r = await Navigator.push<StockModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StocksView(choosing: true),
                      ),
                    ).then<bool>((value) {
                      if (value == null) return false;
                      BillPageViewModel().stockModel = value;
                      stockSearchController.text =
                          BillPageViewModel().stockModel.title;
                      return true;
                    });
                    return r;
                  }
                }
              }
              BillPageViewModel().stockModel = model;
              stockSearchController.text = BillPageViewModel().stockModel.title;
              return true;
            },
            skuSearchNode,
            BillPageViewModel().skuSearchController,
            'لا يمكنك ترك معرف المخزن فارغا',
            false,
            false,
            false,
            ready,
          ),
        ),
        Row(
          children: [
            const Text('create_date'),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: DateTimePicker(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                initialValue: BillPageViewModel().createDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'create_date'.tr,
                onChanged: (val) =>
                    BillPageViewModel().createDate = (DateTime.parse(val)),
                enabled: ready,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            const Text('تاريخ التوريد'),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: DateTimePicker(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                initialValue: BillPageViewModel().incomingDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Incoming'.tr,
                onChanged: (val) =>
                    BillPageViewModel().incomingDate = (DateTime.parse(val)),
                enabled: ready,
              ),
            ),
          ],
        ),
        const Spacer(),
        DropdownButton<BillType>(
          items: BillType.values
              .map(
                (e) => DropdownMenuItem<BillType>(
                  value: e,
                  child: Text(billTypes[e.index]),
                ),
              )
              .toList(),
          value: BillPageViewModel().selectedBillType,
          onChanged: (value) {
            if (value == null) return;
            BillPageViewModel().selectedBillType = value;
            BillControleViewUpdater().add(0);
            BillControleBodyViewUpdater().add(0);
          },
        )
      ],
    );
  }

  Widget body(context) {
    // return updater.UpdaterBloc(
    //     updater: BillControleBodyViewUpdater(
    //       init: 0,
    //       updateForCurrentEvent: true,
    //     ),
    //     update: (context, state) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color:
              SystemConfig().theme == 'light' ? Colors.white70 : Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ignore: duplicate_ignore
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 25,
                    // ignore: prefer_const_constructors
                    child: BillEnteriesHeader(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: BillPageViewModel().billEntries.length,
                      itemBuilder: (context, index) {
                        return BillEntryWidget(
                          billEntry: BillPageViewModel()
                              .billEntries
                              .values
                              .toList()[index],
                          index: index,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // });
  }

  Widget skuEntryFields(context) {
    return SizedBox(
      height: BillPageViewModel().selectedBillType != BillType.goodsReceived
          ? 60
          : 100,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: FocusableField(BillPageViewModel().skuSearchController,
                      skuSearchNode, 'search', (text) async {
                    var value = int.tryParse(text);
                    SKUModel? sku;
                    if (value != null) {
                      sku = await SKUModel.get(value);
                    }
                    if (sku == null) {
                      BillPageViewModel().skuSearchController.text =
                          BillPageViewModel().supplierModel.name;
                      // ig nore: use_build_context_synchronously
                      sku = await Navigator.push<SKUModel>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const StockProductsView(choosing: true),
                        ),
                      );
                      if (sku == null) return false;
                      BillPageViewModel().skuSearchController.text =
                          BillPageViewModel().supplierModel.name;
                    }
                    BillPageViewModel().foundSKU = sku;
                    BillPageViewModel().skuSearchController.clear();
                    BillPageViewModel().skuCostPriceController.text =
                        sku.costPrice.toString();
                    BillPageViewModel().skuMaxPriceController.text =
                        sku.highestPrice.toString();
                    BillPageViewModel().skuSalePriceController.text =
                        sku.salePrice.toString();
                    BillControleViewUpdater().add(0);
                    return true;
                  },
                      skuCostPriceNode,
                      BillPageViewModel().skuCostPriceController,
                      'لا يمكنك ترك السطر فارغا',
                      false,
                      true,
                      false,
                      ready,
                      true),
                ),
                Expanded(
                  child: FocusableField(
                      BillPageViewModel().skuCostPriceController,
                      skuCostPriceNode,
                      'cost_price', (result) {
                    return true;
                  },
                      skuMaxPriceNode,
                      BillPageViewModel().skuMaxPriceController,
                      'لا يمكنك ترك السطر فارغا',
                      false,
                      true,
                      false,
                      BillPageViewModel().foundSKU != null),
                ),
                Expanded(
                  child: FocusableField(
                      BillPageViewModel().skuMaxPriceController,
                      skuMaxPriceNode,
                      'max_price', (result) {
                    return true;
                  },
                      skuSalePriceNode,
                      BillPageViewModel().skuSalePriceController,
                      'لا يمكنك ترك السطر فارغا',
                      false,
                      true,
                      false,
                      BillPageViewModel().foundSKU != null),
                ),
                Expanded(
                  child: FocusableField(
                      BillPageViewModel().skuSalePriceController,
                      skuSalePriceNode,
                      'sale_price', (result) {
                    return true;
                  },
                      skuQuantityNode,
                      BillPageViewModel().skuQuantityController,
                      'لا يمكنك ترك السطر فارغا',
                      false,
                      true,
                      false,
                      BillPageViewModel().foundSKU != null),
                ),
                Expanded(
                  child: FocusableField(
                      BillPageViewModel().skuQuantityController,
                      skuQuantityNode,
                      'quantity', (result) {
                    return true;
                  },
                      BillPageViewModel().selectedBillType ==
                              BillType.goodsReceived
                          ? expierYearNode
                          : skuNoteNode,
                      BillPageViewModel().selectedBillType ==
                              BillType.goodsReceived
                          ? BillPageViewModel().expierYearController
                          : BillPageViewModel().skuNoteController,
                      'لا يمكنك ترك السطر فارغا',
                      false,
                      true,
                      false,
                      BillPageViewModel().foundSKU != null),
                ),
                FutureBuilder<List<SaleUnitModel>>(
                  future: SaleUnitModel.getAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      BillPageViewModel().registeredSaleUnits.clear();
                      BillPageViewModel()
                          .registeredSaleUnits
                          .addAll(snapshot.data!);
                      // BillPageViewModel().saleUnitModel =
                      //     BillPageViewModel().registeredSaleUnits[0];
                      return DropdownButton<int>(
                        items: BillPageViewModel()
                            .registeredSaleUnits
                            .map((element) {
                          if (BillPageViewModel().saleUnitModel?.id ==
                              element.id) {
                            BillPageViewModel().currentSaleUnitDropDownValue =
                                BillPageViewModel()
                                    .registeredSaleUnits
                                    .indexOf(element);
                          }
                          return DropdownMenuItem<int>(
                            onTap: () {
                              BillPageViewModel().saleUnitModel = element;
                              BillPageViewModel().containSizeController.text =
                                  element.quantity.toString();
                            },
                            value: BillPageViewModel()
                                .registeredSaleUnits
                                .indexOf(element),
                            child: Row(
                              children: [
                                Text(element.name),
                                const SizedBox(width: 16),
                                Text(element.quantity.toString()),
                              ],
                            ),
                          );
                        }).toList(),
                        value: BillPageViewModel().currentSaleUnitDropDownValue,
                        onChanged: (result) {
                          setState(() {
                            BillPageViewModel().currentSaleUnitDropDownValue =
                                result!;
                          });
                        },
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text('There is no data found');
                    }
                  },
                ),
                BillPageViewModel().saleUnitModel?.containsUnknownQuantity !=
                        true
                    ? const SizedBox()
                    : SizedBox(
                        width: 80,
                        child: FocusableField(
                            BillPageViewModel().containSizeController,
                            FocusNode(),
                            'تحتوي', (result) {
                          return true;
                        },
                            BillPageViewModel().selectedBillType ==
                                    BillType.goodsReceived
                                ? expierYearNode
                                : skuNoteNode,
                            BillPageViewModel().selectedBillType ==
                                    BillType.goodsReceived
                                ? BillPageViewModel().expierYearController
                                : BillPageViewModel().skuNoteController,
                            'لا يمكنك ترك السطر فارغا',
                            false,
                            true,
                            false,
                            BillPageViewModel().foundSKU != null),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        'القيمة:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (BillPageViewModel().selectedBillEntry?.total ?? '0.0')
                            .toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          BillPageViewModel().selectedBillType != BillType.goodsReceived
              ? const SizedBox()
              : SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: FocusableField(
                            BillPageViewModel().expierYearController,
                            expierYearNode,
                            'السنة', (result) {
                          return true;
                        },
                            expierMonthNode,
                            BillPageViewModel().expierMonthController,
                            'لا يمكنك ترك السطر فارغا',
                            true,
                            false,
                            false,
                            BillPageViewModel().foundSKU != null),
                      ),
                      Expanded(
                        child: FocusableField(
                            BillPageViewModel().expierMonthController,
                            expierMonthNode,
                            'الشهر', (result) {
                          return true;
                        },
                            skuFreeQuantityNode,
                            BillPageViewModel().skuFreeQUantityController,
                            'لا يمكنك ترك السطر فارغا',
                            true,
                            false,
                            false,
                            BillPageViewModel().foundSKU != null),
                      ),
                      BillPageViewModel().selectedBillType !=
                              BillType.goodsReceived
                          ? const SizedBox()
                          : Expanded(
                              child: FocusableField(
                                  BillPageViewModel().skuFreeQUantityController,
                                  skuFreeQuantityNode,
                                  'free_quantity', (result) {
                                return true;
                              },
                                  skuDiscNode,
                                  BillPageViewModel().skuDiscController,
                                  'لا يمكنك ترك السطر فارغا',
                                  false,
                                  true,
                                  false,
                                  BillPageViewModel().foundSKU != null),
                            ),
                      BillPageViewModel().selectedBillType !=
                              BillType.goodsReceived
                          ? const SizedBox()
                          : SizedBox(
                              width: 80,
                              child: FocusableField(
                                  BillPageViewModel().skuDiscController,
                                  skuDiscNode,
                                  'discount', (result) {
                                return true;
                              },
                                  skuTaxNode,
                                  BillPageViewModel().skuTaxController,
                                  'لا يمكنك ترك السطر فارغا',
                                  false,
                                  true,
                                  false,
                                  BillPageViewModel().foundSKU != null),
                            ),
                      BillPageViewModel().selectedBillType !=
                              BillType.goodsReceived
                          ? const SizedBox()
                          : SizedBox(
                              width: 90,
                              child: FocusableField(
                                  BillPageViewModel().skuTaxController,
                                  skuTaxNode,
                                  'tax', (result) {
                                return true;
                              },
                                  skuNoteNode,
                                  BillPageViewModel().skuNoteController,
                                  'لا يمكنك ترك السطر فارغا',
                                  false,
                                  true,
                                  false,
                                  BillPageViewModel().foundSKU != null),
                            ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget totalsViews(context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الكمية الكلية:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                BillPageViewModel().totalQuantity.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                BillPageViewModel().totalValuePrice.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الضريبة:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                BillPageViewModel().totalTax.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الخصم:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                BillPageViewModel().totalDiscount.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التكلفة الاجمالية:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                BillPageViewModel().totalCost.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FocusableField(
              BillPageViewModel().skuNoteController, skuNoteNode, 'note',
              (result) {
            addBillEntry(BillPageViewModel().foundSKU!);
            resumTotals();
            BillControleViewUpdater().add(0);
            return true;
          },
              skuSearchNode,
              BillPageViewModel().skuSearchController,
              'لا يمكنك ترك السطر فارغا',
              false,
              false,
              false,
              BillPageViewModel().foundSKU != null),
        ),
      ],
    );
  }

  Widget buttonsRow(context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            flex: BillPageViewModel().wasImportedToStock ? 1 : 2,
            child: MaterialButton(
              onPressed: !ready
                  ? null
                  : BillPageViewModel().selectedBillType !=
                          BillType.goodsReceived
                      ? null
                      : () async {
                          setState(() {
                            loading = true;
                          });
                          if (BillPageViewModel().wasImportedToStock) {
                            await widget.model!.stockModel
                                .pullBill(widget.model!);
                            widget.model!.billPaymentMethods.clear();
                            widget.model!.billState = BillState.returned;
                            widget.model!.wasImported = false;
                            BillPageViewModel().wasImportedToStock = false;

                            widget.model!.supplierModel
                                .recordBill(widget.model!);
                            widget.model!.wanted = widget.model!.payed;
                            widget.model!.payed = 0;
                            await widget.model!.edit();
                            setState(() {
                              loading = false;
                            });
                            Navigator.pop(context);
                            return;
                          }
                          await getBillAgree(context).then((value) async {
                            if (BillPageViewModel().totalWanted == 0 &&
                                BillPageViewModel().totalPayed ==
                                    BillPageViewModel().totalCost) {
                              // Pass
                            } else {
                              showSimpleNotification(
                                const Text(
                                  'عليك اتمام الدفع اولا',
                                  style: TextStyle(fontSize: 20),
                                ),
                                position: NotificationPosition.bottom,
                              );
                              return;
                            }
                            await askBeforImportingToBillStock(context)
                                .then((value) async {
                              if (value == null || !value) {
                                return;
                              }
                              if (BillPageViewModel().totalValuePrice == 0) {
                                showSimpleNotification(
                                  const Text(
                                    'مجموع الفاتورة الكلي يساوي صفر, اي لا يمكن استيرادها الى المخزن',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  position: NotificationPosition.bottom,
                                );
                                return;
                              }
                              BillPageViewModel().wasImportedToStock = true;
                              BillModel billForm = createInstance();

                              if (BillPageViewModel().selectedBillType ==
                                  BillType.goodsReceived) {
                                await billForm.stockModel.pushBill(billForm);
                                await billForm.supplierModel
                                    .recordBill(billForm);
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );
                                await saveBill(
                                  billForm,
                                  widget.editMode,
                                  (widget.model ?? billForm).billType,
                                ).then((value) async {
                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );
                                  cancelAny();
                                  // await Navigator.push( context,
                                  //   MaterialPageRoute( builder: (context) =>
                                  //         BillFormPrinter(billForm: billForm),),
                                  // ).then((value) { Navigator.pop(
                                  //       context, 'go_to_bill_form_printer');});
                                });
                                // cancelAny();
                                Navigator.pop(context);
                              }
                              // print(billForm.billEntries);
                              // return;
                            });
                          });
                          return;
                        },
              padding: const EdgeInsets.all(12),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                side: BorderSide(color: Colors.green),
              ),
              color: SystemConfig().theme == 'light'
                  ? Colors.white
                  : Colors.transparent,
              child: Text(
                BillPageViewModel().wasImportedToStock
                    ? 'استرجاع'.tr
                    : 'استيراد الى المخزن'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          !ready
              ? const SizedBox()
              : BillPageViewModel().selectedBillType != BillType.goodsReceived
                  ? const SizedBox()
                  : !BillPageViewModel().wasImportedToStock
                      ? const SizedBox()
                      : Expanded(
                          flex: BillPageViewModel().wasImportedToStock ? 1 : 2,
                          child: MaterialButton(
                            onPressed: () async {
                              await getBillAgree(context, true);
                              return;
                            },
                            padding: const EdgeInsets.all(12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                              side: BorderSide(color: Colors.green),
                            ),
                            color: SystemConfig().theme == 'light'
                                ? Colors.white
                                : Colors.transparent,
                            child: const Text(
                              'مشاهدة المدفوعات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
          const SizedBox(width: 8),
          widget.editMode
              ? const SizedBox()
              : SizedBox(
                  width: 150,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(12),
                    onPressed: !ready
                        ? null
                        : () {
                            cancelAny();
                            BillControleViewUpdater().add('');
                          },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: SystemConfig().theme == 'light'
                        ? Colors.white
                        : Colors.transparent,
                    child: Text(
                      'cancel_bill'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          const SizedBox(width: 8),
          SizedBox(
            width: 150,
            child: MaterialButton(
              padding: const EdgeInsets.all(12),
              onPressed: !ready
                  ? null
                  : BillPageViewModel().selectedBillEntry == null
                      ? null
                      : () {
                          deleteLine(BillPageViewModel()
                              .selectedBillEntry!
                              .skuModel
                              .id);
                          BillPageViewModel().selectedBillEntry = null;
                          BillControleViewUpdater().add('');
                        },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                side: BorderSide(color: Colors.red),
              ),
              color: SystemConfig().theme == 'light'
                  ? Colors.white
                  : Colors.transparent,
              child: const Text(
                'الغاء السطر',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MaterialButton(
              padding: const EdgeInsets.all(12),
              onPressed: !ready
                  ? null
                  : (BillPageViewModel().selectedBillEntry == null)
                      ? null
                      : () {
                          updateBillEntry(
                            BillPageViewModel().selectedBillEntry!.skuModel.id,
                          );
                        },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                side: BorderSide(color: Colors.green),
              ),
              color: SystemConfig().theme == 'light'
                  ? Colors.white
                  : Colors.transparent,
              child: const Text(
                'حفظ السطر',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MaterialButton(
              padding: const EdgeInsets.all(12),
              onPressed: !ready
                  ? null
                  : BillPageViewModel().selectedBillType ==
                          BillType.goodsReceived
                      ? null
                      : () async {
                          await saveBill(null, widget.editMode)
                              .then((value) async {
                            await Future.delayed(
                              const Duration(seconds: 1),
                            );
                            cancelAny();
                            Navigator.pop(context);
                          });
                        },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                side: BorderSide(color: Colors.green),
              ),
              color: SystemConfig().theme == 'light'
                  ? Colors.white
                  : Colors.transparent,
              child: const Text(
                'حفظ الفاتورة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteLine(int id) {
    var entry = BillPageViewModel().billEntries[id.toString()];
    if (entry != null) {
      BillPageViewModel().billEntries.remove(id.toString());
      resumTotals();
      BillUpdater().add('');
      BillControleViewUpdater().add('');
    }
  }

  void addBillEntry(SKUModel skuModel) {
    var entry = BillPageViewModel().billEntries[skuModel.id.toString()];
    // If the entry is not presented then add it
    if (entry != null) {
    } else {
      var total = (double.parse(
              BillPageViewModel().skuCostPriceController.text) *
          (double.parse(BillPageViewModel().skuQuantityController.text) *
              double.parse(BillPageViewModel().containSizeController.text)));
      // (double.parse(BillPageViewModel().skuCostPriceController.text) *
      //     double.parse(BillPageViewModel().skuFreeQUantityController.text));
      // BillPageViewModel().skuTotalController.text = total.toString();
// if (entry.saleunit.containsUnknownQuantity == true) {
//         if (entry.containSize != null) {
//           if (entry.quantity ==
//               ((entry.quantity / entry.containSize!.toDouble()) *
//                   entry.containSize!.toDouble())) {
//           } else {
//             entry.quantity = entry.quantity * entry.containSize!.toDouble();
//           }
//         }
//       }
      // print('Contains Size: ${BillPageViewModel().containSizeController.text}');
      // print('SKUQuantity: ${BillPageViewModel().skuQuantityController.text}');
      BillPageViewModel().billEntries.addAll({
        skuModel.id.toString(): BillEntryModel(
          disc: double.parse(BillPageViewModel().skuDiscController.text),
          freeQuantity:
              double.parse(BillPageViewModel().skuFreeQUantityController.text),
          skuModel: SKUModel.fromMap(skuModel.toMap()),
          quantity:
              double.parse(BillPageViewModel().skuQuantityController.text) *
                  double.parse(BillPageViewModel().containSizeController.text),
          saleunit: BillPageViewModel().saleUnitModel!,
          expierDate: '${BillPageViewModel().expierMonthController.text}-'
              '${BillPageViewModel().expierYearController.text}',
          containSize:
              double.parse(BillPageViewModel().containSizeController.text),
          total: total,
          tax: double.parse(BillPageViewModel().skuTaxController.text),
          note: BillPageViewModel().skuNoteController.text,
          deliveryPrice: 0,
        )
      });
    }
    // BillPageViewModel().totalValuePrice = 0;
    // for (var rEntry in BillPageViewModel().billEntries.values) {
    //   BillPageViewModel().totalValuePrice += rEntry.total;
    // }
    resumTotals();
    BillUpdater().add('');
    BillControleViewUpdater().add('');
  }

  void updateBillEntry(int id) {
    var entry = BillPageViewModel().billEntries[id.toString()];
    // If the entry is not presented then add it
    if (entry != null) {
      if (entry.saleunit.containsUnknownQuantity == true ||
          entry.saleunit.quantity > 0) {
        // print('dsfsdgd ${entry.containSize}');
        if (entry.containSize != null) {
          if (double.parse(BillPageViewModel().skuQuantityController.text) ==
              ((entry.quantity /
                      double.parse(
                          BillPageViewModel().containSizeController.text)) *
                  entry.containSize!.toDouble())) {
            // print('====================================');
          } else {
            entry.quantity =
                double.parse(BillPageViewModel().skuQuantityController.text) *
                    entry.containSize!.toDouble();
            BillPageViewModel().skuQuantityController.text =
                entry.quantity.toString();
          }
        }
      }
      // BillPageViewModel().billEntries[id.toString()]!.skuModel. = ;
      BillPageViewModel().billEntries.addAll({
        id.toString(): BillEntryModel(
          disc: double.parse(BillPageViewModel().skuDiscController.text),
          freeQuantity:
              double.parse(BillPageViewModel().skuFreeQUantityController.text),
          skuModel: SKUModel.fromMap(
              BillPageViewModel().billEntries[id.toString()]!.skuModel.toMap()),
          quantity: entry.quantity,
          // double.parse(BillPageViewModel().skuQuantityController.text) *
          //     double.parse(BillPageViewModel().containSizeController.text),
          saleunit: BillPageViewModel().saleUnitModel!,
          containSize:
              double.parse(BillPageViewModel().containSizeController.text),
          //     BillPageViewModel().saleUnitModel?.containsUnknownQuantity == true
          //         ? double.parse(BillPageViewModel().containSizeController.text)
          //         : null,
          expierDate: '${BillPageViewModel().expierMonthController.text}-'
              '${BillPageViewModel().expierYearController.text}',
          total:
              (double.parse(BillPageViewModel().skuCostPriceController.text) *
                  double.parse(BillPageViewModel().skuQuantityController.text)),
          // (double.parse(BillPageViewModel().skuCostPriceController.text) *
          //     double.parse(
          //         BillPageViewModel().skuFreeQUantityController.text)),
          tax: double.parse(BillPageViewModel().skuTaxController.text),
          note: BillPageViewModel().skuNoteController.text,
          deliveryPrice: 0,
        )
      });
    } else {}
    resumTotals();
    BillUpdater().add('');
    BillControleViewUpdater().add('');
  }
}

resumTotals() {
  BillPageViewModel().totalValuePrice = 0.0;
  BillPageViewModel().totalCost = 0.0;
  BillPageViewModel().totalDiscount = 0.0;
  BillPageViewModel().totalQuantity = 0.0;
  BillPageViewModel().totalTax = 0.0;
  // BillPageViewModel().totalPayed = 0.0;
  BillPageViewModel().totalWanted = 0.0;
  for (var entry in BillPageViewModel().billEntries.values) {
    // if (entry.saleunit.containsUnknownQuantity == true) {
    //   if (entry.containSize != null) {
    //     entry.quantity = entry.quantity * entry.containSize!.toDouble();
    //   }
    // }
    // print(entry.quantity);
    BillPageViewModel().totalQuantity += entry.quantity + entry.freeQuantity;
    BillPageViewModel().totalTax += (((entry.total) / 100) * entry.tax);
    BillPageViewModel().totalDiscount += (((entry.total) / 100) * entry.disc);
    BillPageViewModel().totalCost +=
        (entry.quantity * entry.skuModel.costPrice!);
    BillPageViewModel().totalValuePrice +=
        ((entry.quantity + entry.freeQuantity) * entry.skuModel.costPrice!);
    // print(BillPageViewModel().totalValuePrice);
    // BillPageViewModel().totalWanted = BillPageViewModel().totalValuePrice;
  }
  BillPageViewModel().totalCost =
      BillPageViewModel().totalCost -= BillPageViewModel().totalDiscount;
  BillPageViewModel().totalCost =
      BillPageViewModel().totalCost + BillPageViewModel().totalTax;
  BillPageViewModel().totalWanted =
      BillPageViewModel().totalCost - BillPageViewModel().totalPayed;
  // print('totalTax: ${BillPageViewModel().totalTax}');
  // print('totalDiscount: ${BillPageViewModel().totalDiscount}');
  // print('totalWanted: ${BillPageViewModel().totalWanted}');
  // print('totalPayed: ${BillPageViewModel().totalPayed}');
  // print('totalCost: ${BillPageViewModel().totalCost}');
}

class BillUpdater extends updater.Updater {
  BillUpdater({
    init,
    bool updateForCurrentEvent = false,
  }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
}

class BillControleViewUpdater extends updater.Updater {
  BillControleViewUpdater({
    init,
    bool updateForCurrentEvent = false,
  }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
}

class BillControleBodyViewUpdater extends updater.Updater {
  BillControleBodyViewUpdater({
    init,
    bool updateForCurrentEvent = false,
  }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
}

// class DETtextField extends StatelessWidget {
//   const DETtextField({
//     Key? key,
//     this.dETtyp = DEType.string,
//     this.controller,
//     this.onSubmitted,
//     this.labelText,
//   }) : super(key: key);

//   final DEType dETtyp;
//   final TextEditingController? controller;
//   final void Function(String)? onSubmitted;
//   final String? labelText;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       onSubmitted: (result) {
//             if (whatToSayifIsEmpty != null) {
//               if (result.isEmpty) {
//                 showSimpleNotification(
//                   Text(whatToSayifIsEmpty!),
//                   position: NotificationPosition.bottom,
//                 );
//                 return;
//               }
//             }
//             if (isNumber) {
//               try {
//                 int.parse(result);
//               } catch (e) {
//                 showSimpleNotification(
//                   const Text(
//                       'تأكد من كتابتك للمعرف بصورة صحيحة حيث يحتوي على ارقام فقط'),
//                   position: NotificationPosition.bottom,
//                 );
//                 return;
//               }
//             }
//             onSubmited(result);
//             nextNode?.requestFocus();
//             nextController?.selection = TextSelection(
//               baseOffset: 0,
//               extentOffset: nextController!.text.length,
//             );
//           },
//       keyboardType:
//           dETtyp == DEType.string ? TextInputType.text : TextInputType.number,
//       decoration: InputDecoration(
//         labelText: labelText,
//       ),
//     );
//   }
// }

// enum DEType {
//   int,
//   double,
//   string,
// }
