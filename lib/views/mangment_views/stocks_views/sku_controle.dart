import 'package:businet_medical_center/models/category_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/sale_unit_model.dart';
import 'package:businet_medical_center/models/sku_model.dart';
import 'package:businet_medical_center/models/stock_model.dart';
import 'package:businet_medical_center/models/subcatgory_model.dart';
import 'package:businet_medical_center/models/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:overlay_support/overlay_support.dart' as ovrs;

class ProductsControle extends StatefulWidget {
  const ProductsControle({
    Key? key,
    this.skuModel,
    this.editMode = false,
  }) : super(key: key);
  final SKUModel? skuModel;
  final bool editMode;

  @override
  State<ProductsControle> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<ProductsControle> {
  // late TextEditingController titleCont;
  // late TextEditingController descriptionCont;
  // late Firestore store;

  late FocusNode idNode;
  late FocusNode descriptionNode;
  late FocusNode costPriceNode;
  late FocusNode salePercentNode;
  late FocusNode discountPercentNode;
  late FocusNode salePriceNode;
  late FocusNode lowestPriceNode;
  late FocusNode quantityNode;
  late FocusNode discountableNode;
  late FocusNode inactiveNode;
  late FocusNode openRateNode;
  late FocusNode productionDateNode;
  late FocusNode expierDateNode;
  late FocusNode inactiveAfterNode;
  late FocusNode barcodeNode;
  late TextEditingController idController;
  late TextEditingController descriptionController;
  late TextEditingController costPriceController;
  late TextEditingController salePercentController;
  late TextEditingController discountPercentController;
  late TextEditingController salePriceController;
  late TextEditingController lowestPriceController;
  late TextEditingController quantityController;
  late TextEditingController productionDateController;
  late TextEditingController expierDateController;
  late TextEditingController inactiveAfterController;
  late TextEditingController barcodeController;

  @override
  void initState() {
    super.initState();
    // store = Firestore.initialize('');
    idNode = FocusNode();
    descriptionNode = FocusNode();
    costPriceNode = FocusNode();
    salePercentNode = FocusNode();
    inactiveNode = FocusNode();
    openRateNode = FocusNode();
    discountableNode = FocusNode();
    discountPercentNode = FocusNode();
    salePriceNode = FocusNode();
    lowestPriceNode = FocusNode();
    quantityNode = FocusNode();
    barcodeNode = FocusNode();
    productionDateNode = FocusNode();
    expierDateNode = FocusNode();
    inactiveAfterNode = FocusNode();
    if (widget.editMode) {
      id = widget.skuModel!.id;
      barcode = widget.skuModel!.barcode;
      costPrice = widget.skuModel!.costPrice!;
      salePercent = widget.skuModel!.salePercent;
      description = widget.skuModel!.description!;
      inactiveAfter = widget.skuModel!.inactiveAfter;
      expierDate = widget.skuModel!.expierDate ?? DateTime.now();
      productionDate = widget.skuModel!.productionDate!;
      saleUnitModel = widget.skuModel!.saleUnitModel!;
      stockModel = widget.skuModel!.stockModel!;
      subCatgModel = widget.skuModel!.subCatgModel!;
      catgoryModel = widget.skuModel!.catgoryModel!;
      supplierModel = widget.skuModel!.supplierModel!;

      disPer = widget.skuModel!.disPer;
      quantity = widget.skuModel!.quantity;
      salePrice = widget.skuModel!.salePrice;
      createDate = widget.skuModel!.createDate;
      lastUpdate = widget.skuModel!.lastUpdate;
      lowestPrice = widget.skuModel!.lowestPrice;
      highestPrice = widget.skuModel!.highestPrice;
      inactive = widget.skuModel!.inactive;
      openRate = widget.skuModel!.openRate;
      discountable = widget.skuModel!.discountable;
    } else {
      getAwaiters();
    }

    idController = TextEditingController(text: (id ?? '').toString());
    descriptionController = TextEditingController(text: description);
    costPriceController = TextEditingController(text: costPrice.toString());
    salePercentController = TextEditingController(text: salePercent.toString());
    discountPercentController = TextEditingController(text: disPer.toString());
    salePriceController = TextEditingController(text: salePrice.toString());
    lowestPriceController = TextEditingController(text: lowestPrice.toString());
    quantityController = TextEditingController(text: quantity.toString());
    productionDateController =
        TextEditingController(text: productionDate.toString());
    expierDateController = TextEditingController(text: expierDate.toString());
    inactiveAfterController =
        TextEditingController(text: inactiveAfter.toString());
    barcodeController = TextEditingController(text: barcode);
  }

  getAwaiters() async {
    saleUnitModel = (await SaleUnitModel.findById(0))!;
    subCatgModel = (await SubCatgModel.findById(0))!;
    catgoryModel = (await CatgoryModel.findById(0))!;
    supplierModel = (await SupplierModel.findById(0))!;
    stockModel = (await StockModel.findById(0))!;
  }

  @override
  void dispose() {
    super.dispose();
    idNode.dispose();
    descriptionNode.dispose();
    costPriceNode.dispose();
    salePercentNode.dispose();
    inactiveNode.dispose();
    openRateNode.dispose();
    discountableNode.dispose();
    discountPercentNode.dispose();
    salePriceNode.dispose();
    lowestPriceNode.dispose();
    quantityNode.dispose();
    barcodeNode.dispose();
    productionDateNode.dispose();
    expierDateNode.dispose();
    idController.dispose();
    descriptionController.dispose();
    costPriceController.dispose();
    salePercentController.dispose();
    discountPercentController.dispose();
    salePriceController.dispose();
    lowestPriceController.dispose();
    quantityController.dispose();
    productionDateController.dispose();
    expierDateController.dispose();
    barcodeController.dispose();
  }

  bool loading = false;

  final List<SaleUnitModel> _registeredSaleUnits = [];
  final List<SubCatgModel> _registeredSubCatgs = [];
  final List<CatgoryModel> _registeredCatgs = [];
  final List<SupplierModel> _registeredSuppliers = [];
  final List<StockModel> _registeredStocks = [];

  DateTime productionDate = DateTime.now();
  DateTime expierDate = DateTime.now();
  DateTime? inactiveAfter;
  bool discountable = false;
  DateTime? createDate;
  DateTime? lastUpdate;
  bool openRate = false;
  SaleUnitModel? saleUnitModel;
  SubCatgModel? subCatgModel;
  CatgoryModel? catgoryModel;
  SupplierModel? supplierModel;
  StockModel? stockModel;
  bool inactive = false;
  double lowestPrice = 0.0;
  double? highestPrice = 0.0;
  double disPer = 0.0;
  double salePrice = 0.0;
  double salePercent = 0.0;
  double quantity = 0.0;
  double costPrice = 0.0;
  String? barcode;
  int? id;
  String description = '';

  int currentSaleUnitDropDownValue = 0;
  int currentSubCatgDropDownValue = 0;
  int currentCatgDropDownValue = 0;
  int currentSupplierDropDownValue = 0;
  int currentStockDropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    // _registeredSaleUnits.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editMode ? 'edit_product'.tr : 'add_new_product'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
        actions: [
          Container(
            alignment: Alignment.center,
            child: Text(
              'Last ID: ${ProcessesModel.stored!.lastSKUId.toString()}',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () async {
              if (widget.editMode) {
                await widget.skuModel!.delete().then((value) {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                  controller: idController,
                  // controller: titleCont,
                  autofocus: !widget.editMode,
                  enabled: !widget.editMode,
                  focusNode: idNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: 'id'.tr,
                  ),
                  onSubmitted: (result) {
                    if (result.isEmpty) {
                      ovrs.showSimpleNotification(
                        const Text('لا يمكنك ترك معرف المنتج فارغا'),
                        position: NotificationPosition.bottom,
                      );
                      return;
                    }
                    if (int.tryParse(result) == null) {
                      ovrs.showSimpleNotification(
                        const Text('لا يمكنك ترك معرف المنتج فارغا'),
                        position: NotificationPosition.bottom,
                      );
                      return;
                    }
                    id = int.tryParse(result)!;
                    descriptionNode.requestFocus();
                    descriptionController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: descriptionController.text.length,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              child: TextField(
                focusNode: descriptionNode,
                controller: descriptionController,
                autofocus: widget.editMode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'description'.tr,
                ),
                onSubmitted: (result) {
                  if (result.isEmpty) {
                    ovrs.showSimpleNotification(
                      const Text('لا يمكنك ترك الوصف فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  description = result;
                  costPriceNode.requestFocus();
                  costPriceController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: costPriceController.text.length,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        const Text(''),
                        TextField(
                          focusNode: costPriceNode,
                          controller: costPriceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'cost_price'.tr,
                          ),
                          // inputFormatters: [
                          //   TextInputFormatter.withFunction(
                          //       (oldValue, newValue) {
                          //     StringBuffer buffer = StringBuffer();
                          //     for (var char in oldValue.text.characters
                          //         .toList()
                          //         // .reversed
                          //         .toList()) {
                          //       switch (char) {
                          //         case '0':
                          //           buffer.write(char);
                          //           break;
                          //         case '1':
                          //           buffer.write(char);
                          //           break;
                          //         case '2':
                          //           buffer.write(char);
                          //           break;
                          //         case '3':
                          //           buffer.write(char);
                          //           break;
                          //         case '4':
                          //           buffer.write(char);
                          //           break;
                          //         case '5':
                          //           buffer.write(char);
                          //           break;
                          //         case '6':
                          //           buffer.write(char);
                          //           break;
                          //         case '7':
                          //           buffer.write(char);
                          //           break;
                          //         case '8':
                          //           buffer.write(char);
                          //           break;
                          //         case '9':
                          //           buffer.write(char);
                          //           break;
                          //         default:
                          //       }
                          //       // if (char == '0' || '1' ||'2' )
                          //     }
                          //     // costPriceController.text = buffer.toString();
                          //     return newValue.copyWith(text: buffer.toString());
                          //   })
                          // ],
                          keyboardType: TextInputType.number,
                          // onChanged: (text) {},
                          onSubmitted: (result) {
                            costPrice = double.parse(result);
                            salePercentNode.requestFocus();
                            salePercentController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: salePercentController.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('sale_percent'.tr),
                        TextField(
                          focusNode: salePercentNode,
                          controller: salePercentController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            // labelText: 'sale_percent'.tr,
                          ),
                          onSubmitted: (result) {
                            salePercent = double.parse(result);
                            salePriceController.text =
                                (((costPrice / 100) * salePercent) + costPrice)
                                    .toString();
                            discountPercentNode.requestFocus();
                            discountPercentController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  discountPercentController.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  // height: 80,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('discount'.tr),
                        TextField(
                          focusNode: discountPercentNode,
                          controller: discountPercentController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            // labelText: 'discount_percentage'.tr,
                          ),
                          onSubmitted: (result) {
                            disPer = double.parse(result);
                            salePriceController.text =
                                ((((costPrice / 100) * salePercent)) +
                                        costPrice -
                                        ((costPrice / 100) * disPer))
                                    .toString();
                            salePriceNode.requestFocus();
                            salePriceController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: salePriceController.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        const Text(''),
                        TextField(
                          focusNode: salePriceNode,
                          controller: salePriceController,
                          // TextEditingController(text: ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'sale_price'.tr,
                          ),
                          onSubmitted: (result) {
                            salePrice = double.parse(result);
                            lowestPriceNode.requestFocus();
                            lowestPriceController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: lowestPriceController.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        const Text(''),
                        TextField(
                          focusNode: lowestPriceNode,
                          controller: lowestPriceController,
                          // TextEditingController(text: ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'lowestPrice'.tr,
                          ),
                          onSubmitted: (result) {
                            lowestPrice = double.parse(result);
                            quantityNode.requestFocus();
                            quantityController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: quantityController.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        const Text(''),
                        TextField(
                          focusNode: quantityNode,
                          controller: quantityController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'quantity'.tr,
                          ),
                          onSubmitted: (result) {
                            quantity = double.parse(result);
                            productionDateNode.requestFocus();
                            productionDateController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  productionDateController.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: [
                    Text('discountable'.tr),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: discountable,
                      onChanged: (r) {
                        setState(() {
                          discountable = !discountable;
                        });
                        inactiveNode.requestFocus();
                      },
                      focusNode: discountableNode,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text('inactive'.tr),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: inactive,
                      onChanged: (r) {
                        setState(() {
                          inactive = !inactive;
                        });
                        openRateNode.requestFocus();
                      },
                      focusNode: inactiveNode,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text('openRate'.tr),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: openRate,
                      onChanged: (r) {
                        setState(() {
                          openRate = !openRate;
                        });
                      },
                      focusNode: openRateNode,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: TextField(
                      focusNode: productionDateNode,
                      controller: productionDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'productionDate'.tr,
                      ),
                      onSubmitted: (result) {
                        try {
                          productionDate = DateTime.parse(result);
                        } catch (e) {
                          ovrs.showSimpleNotification(
                            const Text('هناك خطأ في ادخال التاريخ'),
                            position: NotificationPosition.bottom,
                          );
                          return;
                        }
                        expierDateNode.requestFocus();
                        expierDateController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: expierDateController.text.length,
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: TextField(
                      focusNode: expierDateNode,
                      controller: expierDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'expierDate'.tr,
                      ),
                      onSubmitted: (result) {
                        try {
                          expierDate = DateTime.parse(result);
                        } catch (e) {
                          ovrs.showSimpleNotification(
                            const Text('هناك خطأ في ادخال التاريخ'),
                            position: NotificationPosition.bottom,
                          );
                          return;
                        }
                        expierDate = DateTime.parse(result);
                        inactiveAfterNode.requestFocus();
                        inactiveAfterController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: inactiveAfterController.text.length,
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: TextField(
                      focusNode: inactiveAfterNode,
                      controller: inactiveAfterController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'inactiveAfter'.tr,
                      ),
                      onSubmitted: (result) {
                        inactiveAfter = DateTime.tryParse(result);
                        barcodeNode.requestFocus();
                        barcodeController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: barcodeController.text.length,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الشريحة الرئيسية'),
                    const SizedBox(width: 16),
                    FutureBuilder<List<CatgoryModel>>(
                      future: CatgoryModel.getAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _registeredCatgs.clear();
                          _registeredCatgs.addAll(snapshot.data!);
                          return DropdownButton<int>(
                            items: _registeredCatgs.map(
                              (element) {
                                if (catgoryModel?.id == element.id) {
                                  currentCatgDropDownValue =
                                      _registeredCatgs.indexOf(element);
                                }
                                return DropdownMenuItem<int>(
                                  onTap: () {
                                    catgoryModel = element;
                                  },
                                  value: _registeredCatgs.indexOf(element),
                                  child: Row(
                                    children: [
                                      Text(element.catgoryName),
                                      const SizedBox(width: 16),
                                      Text(element.catgoryDescription
                                          .toString()),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                            value: currentCatgDropDownValue,
                            onChanged: (result) {
                              setState(() {
                                currentCatgDropDownValue = result!;
                              });
                            },
                          );
                        }
                        if (snapshot.hasError) {
                          return Container(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text(
                              'There is no sale units, try add one');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الشريحة الفرعية'),
                    const SizedBox(width: 16),
                    FutureBuilder<List<SubCatgModel>>(
                      future: SubCatgModel.getAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _registeredSubCatgs.clear();
                          _registeredSubCatgs.addAll(snapshot.data!);
                          return DropdownButton<int>(
                            items: _registeredSubCatgs.map(
                              (element) {
                                if (subCatgModel?.id == element.id) {
                                  currentSubCatgDropDownValue =
                                      _registeredSubCatgs.indexOf(element);
                                }
                                return DropdownMenuItem<int>(
                                  onTap: () {
                                    subCatgModel = element;
                                  },
                                  value: _registeredSubCatgs.indexOf(element),
                                  child: Row(
                                    children: [
                                      Text(element.subcatgoryName),
                                      const SizedBox(width: 16),
                                      Text(
                                        element.subcatgoryDescription
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                            value: currentSubCatgDropDownValue,
                            onChanged: (result) {
                              setState(() {
                                currentSubCatgDropDownValue = result!;
                              });
                            },
                          );
                        }
                        if (snapshot.hasError) {
                          return Container(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text(
                              'There is no sale units, try add one');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('وحدة البيع'),
                    const SizedBox(width: 16),
                    FutureBuilder<List<SaleUnitModel>>(
                      future: SaleUnitModel.getAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _registeredSaleUnits.clear();
                          _registeredSaleUnits.addAll(snapshot.data!);
                          return DropdownButton<int>(
                            items: _registeredSaleUnits.map((element) {
                              if (saleUnitModel?.id == element.id) {
                                currentSaleUnitDropDownValue =
                                    _registeredSaleUnits.indexOf(element);
                              }
                              return DropdownMenuItem<int>(
                                onTap: () {
                                  saleUnitModel = element;
                                },
                                value: _registeredSaleUnits.indexOf(element),
                                child: Row(
                                  children: [
                                    Text(element.name),
                                    const SizedBox(width: 16),
                                    Text(element.quantity.toString()),
                                  ],
                                ),
                              );
                            }).toList(),
                            value: currentSaleUnitDropDownValue,
                            onChanged: (result) {
                              setState(() {
                                currentSaleUnitDropDownValue = result!;
                              });
                            },
                          );
                        }
                        if (snapshot.hasError) {
                          return Container(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text(
                              'There is no sale units, try add one');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المورد'),
                    const SizedBox(width: 16),
                    FutureBuilder<List<SupplierModel>>(
                        future: SupplierModel.getAll(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _registeredSuppliers.clear();
                            _registeredSuppliers.addAll(snapshot.data!);
                            return DropdownButton<int>(
                              items: _registeredSuppliers.map(
                                (element) {
                                  if (supplierModel?.id == element.id) {
                                    currentSupplierDropDownValue =
                                        _registeredSuppliers.indexOf(element);
                                  }
                                  return DropdownMenuItem<int>(
                                    onTap: () {
                                      supplierModel = element;
                                    },
                                    value:
                                        _registeredSuppliers.indexOf(element),
                                    child: Row(
                                      children: [
                                        Text(element.name),
                                        const SizedBox(width: 16),
                                        Text(element.area.toString()),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                              value: currentSupplierDropDownValue,
                              onChanged: (result) {
                                setState(() {
                                  currentSupplierDropDownValue = result!;
                                });
                              },
                            );
                          }
                          if (snapshot.hasError) {
                            return Container(
                              child: Text(
                                snapshot.error.toString(),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            return const Text(
                                'There is no sale units, try add one');
                          }
                        }),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المخزن'),
                    const SizedBox(width: 16),
                    FutureBuilder<List<StockModel>>(
                        future: StockModel.getAll(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _registeredStocks.clear();
                            _registeredStocks.addAll(snapshot.data!);
                            return DropdownButton<int>(
                              items: _registeredStocks.map(
                                (element) {
                                  if (stockModel?.id == element.id) {
                                    currentStockDropDownValue =
                                        _registeredStocks.indexOf(element);
                                  }
                                  return DropdownMenuItem<int>(
                                    onTap: () {
                                      stockModel = element;
                                    },
                                    value: _registeredStocks.indexOf(element),
                                    child: Row(
                                      children: [
                                        Text(element.title),
                                        const SizedBox(width: 16),
                                        Text(element.area.toString()),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                              value: currentStockDropDownValue,
                              onChanged: (result) {
                                setState(() {
                                  currentStockDropDownValue = result!;
                                });
                              },
                            );
                          }
                          if (snapshot.hasError) {
                            return Container(
                              child: Text(
                                snapshot.error.toString(),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            return const Text(
                                'There is no sale units, try add one');
                          }
                        }),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: TextField(
                      focusNode: barcodeNode,
                      controller: barcodeController,
                      decoration: InputDecoration(
                        labelText: 'barcode'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onSubmitted: (result) {
                        barcode = result;
                      },
                    ),
                  ),
                ),
                // const SizedBox(height: 16),
              ],
            ),
            const Spacer(),
            MaterialButton(
              child: Text('حفظ'.tr),
              onPressed: () async {
                setState(() {
                  loading = true;
                });

                if (widget.editMode) {
                  await SKUModel(
                    id!,
                    barcode: barcode,
                    stockModel: stockModel,
                    catgoryModel: catgoryModel,
                    costPrice: costPrice,
                    description: description,
                    productionDate: productionDate,
                    discountable: discountable,
                    disPer: disPer,
                    inactiveAfter: inactiveAfter,
                    supplierModel: supplierModel,
                    salePrice: salePrice,
                    salePercent: salePercent,
                    openRate: openRate,
                    quantity: quantity,
                    saleUnitModel: saleUnitModel,
                    subCatgModel: subCatgModel,
                    inactive: inactive,
                    expierDate: expierDate,
                  ).edit().then((value) {
                    setState(() {
                      loading = false;
                    });
                    showSimpleNotification(
                      const Text(
                        'تم بنجاح',
                        style: TextStyle(fontSize: 20),
                      ),
                      position: NotificationPosition.bottom,
                    );
                  });
                } else {
                  if (id == null) {
                    ovrs.showSimpleNotification(
                      const Text('لا يمكنك ترك معرف المنتج فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  if (description.isEmpty) {
                    ovrs.showSimpleNotification(
                      const Text('لا يمكنك ترك معرف المنتج فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  await SKUModel.get(id!).then(
                    (value) async {
                      if (value == null) {
                        (await ProcessesModel.get(0))!
                            .copyWith(lastSKUId: id)
                            .edit();
                        await SKUModel(
                          id!,
                          barcode: barcode,
                          stockModel: stockModel,
                          catgoryModel: catgoryModel,
                          costPrice: costPrice,
                          description: description,
                          productionDate: productionDate,
                          discountable: discountable,
                          disPer: disPer,
                          inactiveAfter: inactiveAfter,
                          supplierModel: supplierModel,
                          salePrice: salePrice,
                          lowestPrice: lowestPrice,
                          salePercent: salePercent,
                          openRate: openRate,
                          quantity: quantity,
                          saleUnitModel: saleUnitModel,
                          subCatgModel: subCatgModel,
                          inactive: inactive,
                          expierDate: expierDate,
                        ).add().then((value) {
                          setState(() {
                            loading = false;
                          });
                          showSimpleNotification(
                            const Text(
                              'تم بنجاح',
                              style: TextStyle(fontSize: 20),
                            ),
                            position: NotificationPosition.bottom,
                          );
                        });
                      } else {
                        toast('معرف المنتج مدرج بالفعل');
                      }
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
