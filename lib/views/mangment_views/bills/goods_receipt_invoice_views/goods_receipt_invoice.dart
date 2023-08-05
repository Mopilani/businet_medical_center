// import 'package:cashier_p/views/home/stock_view.dart';
// import 'package:cashier_p/views/mangment_views/suppliers_view.dart';
// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:updater/updater.dart' as updater;

// import '../../../../models/bill_model.dart';
// import '../../../../models/payment_method_model.dart';
// import '../../../../models/point_of_sale_model.dart';
// import '../../../../models/sku_model.dart';
// import '../../../../models/stock_model.dart';
// import '../../../../models/supplier_model.dart';
// import '../../../../widgets/focusable_field.dart';
// import '../../../sales_views/male_views/widgets.dart';
// import '../bills_controle_page_view_model.dart';
// import '../widgets.dart';

// class GoodsReceiptInvoiceView extends StatefulWidget {
//   const GoodsReceiptInvoiceView({
//     Key? key,
//     this.model,
//     this.editMode = false,
//   }) : super(key: key);
//   final BillModel? model;
//   final bool editMode;

//   @override
//   State<GoodsReceiptInvoiceView> createState() => _BillsControleState();
// }

// class _BillsControleState extends State<GoodsReceiptInvoiceView> {
//   late FocusNode idNode = FocusNode();
//   late FocusNode supplierSearchNode = FocusNode();
//   late FocusNode payedNode = FocusNode();
//   late FocusNode wantedNode = FocusNode();

//   late FocusNode skuSearchNode = FocusNode();
//   late FocusNode skuCostPriceNode = FocusNode();
//   late FocusNode skuMaxPriceNode = FocusNode();
//   late FocusNode skuSalePriceNode = FocusNode();
//   late FocusNode skuQuantityNode = FocusNode();
//   late FocusNode skuFreeQuantityNode = FocusNode();
//   late FocusNode skuDiscNode = FocusNode();
//   late FocusNode skuTaxNode = FocusNode();
//   late FocusNode skuTotalNode = FocusNode();

//   late TextEditingController idController;
//   late TextEditingController supplierSearchController;
//   late TextEditingController totalController;
//   late TextEditingController noteController;
//   late TextEditingController payedController;
//   late TextEditingController wantedController;

//   SKUModel? foundSKU;

//   // late TextEditingController searchController;

//   @override
//   void initState() {
//     super.initState();
//     initStateShared();
//   }

//   void initStateShared() {
//     BillPageViewModel();
//     if (widget.editMode) {
//       BillPageViewModel().id = widget.model!.id; // number
//       BillPageViewModel().note = widget.model!.note; // String Note
//       BillPageViewModel().totalValuePrice = widget.model!.total; // value
//       BillPageViewModel().totalPayed = widget.model!.payed; // value
//       BillPageViewModel().totalQuantity = widget.model!.quantity; // value
//       BillPageViewModel().totalWanted = widget.model!.wanted; // value
//       BillPageViewModel().createDate = widget.model!.createDate; // Selector
//       BillPageViewModel().incomingDate = widget.model!.incomingDate; // Selector
//       BillPageViewModel().expierDate = widget.model!.expierDate; // Selector
//       BillPageViewModel().returnDate = widget.model!.returnDate; // Invisable
//       BillPageViewModel().cancelDate = widget.model!.cancelDate; // Invisable
//       BillPageViewModel().userModel = widget.model!.userModel;
//       BillPageViewModel().stockModel = widget.model!.stockModel;
//       BillPageViewModel().deliveryModel = widget.model!.deliveryModel;
//       BillPageViewModel().pointOfSaleModel = widget.model!.pointOfSaleModel;
//       BillPageViewModel().billPaymentMethods = widget.model!.billPaymentMethods;
//       BillPageViewModel().billEntries = widget.model!.billEntries;
//       BillPageViewModel().supplierModel = widget.model!.supplierModel;
//       BillPageViewModel().billState = widget.model!.billState;
//       idController =
//           TextEditingController(text: BillPageViewModel().id.toString());
//       totalController = TextEditingController(
//           text: BillPageViewModel().totalValuePrice.toString());
//       payedController = TextEditingController(
//           text: BillPageViewModel().totalPayed.toString());
//       payedController = TextEditingController(
//           text: BillPageViewModel().totalQuantity.toString());
//       wantedController = TextEditingController(
//           text: BillPageViewModel().totalWanted.toString());
//       BillPageViewModel().skuSearchController = TextEditingController();
//       supplierSearchController = TextEditingController(
//           text: BillPageViewModel().supplierModel.name.toString());
//       noteController = TextEditingController(text: BillPageViewModel().note);
//       BillPageViewModel().skuTotalController =
//           TextEditingController(text: 0.0.toString());
//       // searchController = TextEditingController(text: 0.0.toString());
//     } else {
//       idController = TextEditingController();
//       totalController = TextEditingController(text: 0.0.toString());
//       payedController = TextEditingController(text: 0.0.toString());
//       wantedController = TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuSearchController = TextEditingController();
//       supplierSearchController = TextEditingController();
//       noteController = TextEditingController();

//       // searchController = TextEditingController();
//       BillPageViewModel().skuCostPriceController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuMaxPriceController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuSalePriceController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuQuantityController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuFreeQUantityController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuDiscController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuTaxController =
//           TextEditingController(text: 0.0.toString());
//       BillPageViewModel().skuTotalController =
//           TextEditingController(text: 0.0.toString());

//       BillPageViewModel().createDate = DateTime.now();
//       BillPageViewModel().incomingDate = DateTime.now();
//       BillPageViewModel().expierDate = DateTime.now();
//       getAwaiters();
//     }
//   }

//   getAwaiters() async {
//     BillPageViewModel().pointOfSaleModel = PointOfSaleModel.stored!;
//     BillPageViewModel().supplierModel = (await SupplierModel.findById(0))!;
//     BillPageViewModel().stockModel = (await StockModel.findById(0))!;
//     BillPageViewModel().selectedPaymentMethod =
//         (await PaymentMethodModel.get(0))!;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   bool loading = false;

//   cancelAny() {
//     BillPageViewModel().totalValuePrice = .0;
//     BillPageViewModel().totalCost = .0;
//     BillPageViewModel().totalDiscount = .0;
//     BillPageViewModel().totalQuantity = .0;
//     BillPageViewModel().totalPayed = .0;
//     BillPageViewModel().totalWanted = .0;
//     BillPageViewModel().note = null;
//     BillPageViewModel().createDate = DateTime.now();
//     BillPageViewModel().incomingDate = DateTime.now();
//     BillPageViewModel().expierDate = DateTime.now();
//     BillPageViewModel().skuCostPriceController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuMaxPriceController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuSalePriceController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuQuantityController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuFreeQUantityController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuDiscController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuTaxController =
//         TextEditingController(text: 0.0.toString());
//     BillPageViewModel().skuTotalController =
//         TextEditingController(text: 0.0.toString());

//     idController.clear();
//     totalController.clear();
//     payedController.clear();
//     wantedController.clear();
//     BillPageViewModel().skuSearchController.clear();
//     supplierSearchController.clear();
//     noteController.clear();

//     BillPageViewModel().billPaymentMethods.clear();
//     BillPageViewModel().billEntries.clear();
//     BillPageViewModel().billState = BillState.onWait;

//     currentSaleUnitDropDownValue = 0;
//     BillPageViewModel().remake();
//     initStateShared();
//     // skuTotal = .0;
//     // skuQuantity = .0;
//     // skuSalePrice = .0;
//     // skuDiscount = .0;
//   }

//   int currentSaleUnitDropDownValue = 0;

//   // double skuTotal = 0.0;
//   // double skuQuantity = 0.0;
//   // double skuSalePrice = 0.0;
//   // double skuDiscount = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return updater.UpdaterBloc(
//         updater: BillControleViewUpdater(
//           init: 0,
//           updateForCurrentEvent: true,
//         ),
//         update: (context, state) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 widget.editMode ? 'تعديل فاتورة'.tr() : 'فاتورة جديدة'.tr(),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 centerTitle: true,
//                 title: SizedBox(
//                   width: 250,
//                   child: loading
//                       ? const CircularProgressIndicator()
//                       : TextField(
//                           controller: TextEditingController(
//                             text:
//                                 BillPageViewModel().pointOfSaleModel.placeName,
//                           ),
//                         ),
//                 ),
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: MaterialButton(
//                     color: Colors.green,
//                     onPressed: widget.editMode
//                         ? null
//                         : () async {
//                             // StockModel.findById(id);
//                             //   setState(() {
//                             //     loading = true;
//                             //   });

//                             //   if (widget.editMode) {
//                             //     await BillModel(
//                             //       id,
//                             //       categoryName,
//                             //       categoryDescription,
//                             //     ).edit().then((value) {
//                             //       setState(() {
//                             //         loading = false;
//                             //       });
//                             //       showSimpleNotification(
//                             //         const Text(
//                             //           'تم بنجاح',
//                             //           style: TextStyle(fontSize: 20),
//                             //         ),
//                             //         position: NotificationPosition.bottom,
//                             //       );
//                             //     });
//                             //   } else {
//                             //     if (idController.text.isEmpty) {
//                             //       showSimpleNotification(
//                             //         const Text('لا يمكنك ترك معرف الشريحة فارغا'),
//                             //         position: NotificationPosition.bottom,
//                             //       );
//                             //       return;
//                             //     }
//                             //     if (categoryName.isEmpty) {
//                             //       showSimpleNotification(
//                             //         const Text('لا يمكنك ترك اسم الشريحة فارغا'),
//                             //         position: NotificationPosition.bottom,
//                             //       );
//                             //       return;
//                             //     }
//                             //     await BillModel.get(id).then(
//                             //       (value) async {
//                             //         if (value == null) {
//                             //           await BillModel(
//                             //             id,
//                             //             categoryName,
//                             //             categoryDescription,
//                             //           ).add().then((value) {
//                             //             setState(() {
//                             //               loading = false;
//                             //               showSimpleNotification(
//                             //                 const Text(
//                             //                   'تم بنجاح',
//                             //                   style: TextStyle(fontSize: 20),
//                             //                 ),
//                             //                 position: NotificationPosition.bottom,
//                             //               );
//                             //             });
//                             //           });
//                             //         } else {
//                             //           toast('معرف الشريحة مدرج بالفعل');
//                             //         }
//                             //       },
//                             //     );
//                             //   }
//                           },
//                     child: const Text(
//                       'الى المخزن',
//                       style: TextStyle(
//                         fontSize: 20,
//                         // color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: MaterialButton(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     onPressed: () {
//                       writeNoteDialog(context, noteController);
//                     },
//                     color: Colors.grey,
//                     child: Row(
//                       children: const [
//                         Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'ملاحظة',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 120,
//                         child: FocusableField(
//                           idController,
//                           idNode,
//                           'رقم الفاتورة',
//                           (result) async {
//                             BillPageViewModel().id = int.parse(result);
//                           },
//                           supplierSearchNode,
//                           supplierSearchController,
//                           'لا يمكنك ترك معرف المورد فارغا',
//                           true,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 300,
//                         child: FocusableField(supplierSearchController,
//                             supplierSearchNode, 'supplier', (result) async {
//                           var r = await SupplierModel.findByName(result);
//                           if (r != null) {
//                           } else {
//                             var supplierId = int.tryParse(result);
//                             if (supplierId == null) {
//                               return;
//                             } else {
//                               r = await SupplierModel.get(supplierId);
//                               supplierSearchController.text =
//                                   BillPageViewModel().supplierModel.name;
//                               if (r == null) {
//                                 // ignore: use_build_context_synchronously
//                                 await Navigator.push<SupplierModel>(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const SuppliersView(choosing: true),
//                                   ),
//                                 ).then((value) {
//                                   BillPageViewModel().supplierModel = value!;
//                                   supplierSearchController.text =
//                                       BillPageViewModel().supplierModel.name;
//                                 });
//                                 return;
//                               }
//                             }
//                           }
//                           BillPageViewModel().supplierModel = r;
//                           supplierSearchController.text =
//                               BillPageViewModel().supplierModel.name;
//                         },
//                             skuSearchNode,
//                             BillPageViewModel().skuSearchController,
//                             'لا يمكنك ترك معرف المورد فارغا',
//                             false),
//                       ),
//                       Row(
//                         children: [
//                           const Text('تاريخ الانشاء'),
//                           const SizedBox(width: 8),
//                           SizedBox(
//                             width: 150,
//                             child: DateTimePicker(
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               initialValue:
//                                   BillPageViewModel().createDate.toString(),
//                               firstDate: DateTime(2000),
//                               lastDate: DateTime(2100),
//                               dateLabelText: 'createDate'.tr(),
//                               onChanged: (val) => BillPageViewModel()
//                                   .createDate = (DateTime.parse(val)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 8),
//                       Row(
//                         children: [
//                           const Text('تاريخ التوريد'),
//                           const SizedBox(width: 8),
//                           SizedBox(
//                             width: 150,
//                             child: DateTimePicker(
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               initialValue:
//                                   BillPageViewModel().incomingDate.toString(),
//                               firstDate: DateTime(2000),
//                               lastDate: DateTime(2100),
//                               dateLabelText: 'Incoming'.tr(),
//                               onChanged: (val) => BillPageViewModel()
//                                   .incomingDate = (DateTime.parse(val)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       DropdownButton<String>(
//                         items: billTypes
//                             .map(
//                               (e) => DropdownMenuItem<String>(
//                                 value: e,
//                                 child: Text(e),
//                               ),
//                             )
//                             .toList(),
//                         value: BillPageViewModel().selectedBillType,
//                         onChanged: (value) {
//                           if (value == null) return;
//                           BillPageViewModel().selectedBillType = value;
//                           BillControleViewUpdater().add(0);
//                         },
//                       )
//                     ],
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Container(
//                       padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
//                       margin: const EdgeInsets.all(4.0),
//                       decoration: BoxDecoration(
//                         color: Colors.black12,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 8),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 const SizedBox(
//                                   height: 25,
//                                   child: BillWid3(),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Expanded(
//                                   child: ListView.builder(
//                                     controller: ScrollController(),
//                                     itemCount:
//                                         BillPageViewModel().billEntries.length,
//                                     itemBuilder: (context, index) {
//                                       return BillWid2(
//                                         billEntry: BillPageViewModel()
//                                             .billEntries
//                                             .values
//                                             .toList()[index],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: FocusableField(
//                             BillPageViewModel().skuSearchController,
//                             skuSearchNode,
//                             'بحث',
//                             (text) async {
//                               skuSearchNode.requestFocus();
//                               var value = int.tryParse(text);
//                               SKUModel? sku;
//                               if (value != null) {
//                                 sku = await SKUModel.get(value);
//                               }
//                               if (sku == null) {
//                                 BillPageViewModel().skuSearchController.text =
//                                     BillPageViewModel().supplierModel.name;
//                                 // ig nore: use_build_context_synchronously
//                                 sku = await Navigator.push<SKUModel>(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const StockProductsView(choosing: true),
//                                   ),
//                                 );
//                                 if (sku == null) return;
//                                 BillPageViewModel().skuSearchController.text =
//                                     BillPageViewModel().supplierModel.name;
//                               }
//                               foundSKU = sku;
//                               BillPageViewModel().skuSearchController.clear();
//                               BillPageViewModel().skuCostPriceController.text =
//                                   sku.costPrice.toString();
//                               BillPageViewModel().skuMaxPriceController.text =
//                                   sku.highestPrice.toString();
//                               BillPageViewModel().skuSalePriceController.text =
//                                   sku.salePrice.toString();
//                               BillControleViewUpdater().add(0);
//                             },
//                             skuCostPriceNode,
//                             BillPageViewModel().skuCostPriceController,
//                             'لا يمكنك ترك السطر فارغا',
//                             false,
//                           ),
//                         ),
//                         Expanded(
//                           child: FocusableField(
//                               BillPageViewModel().skuCostPriceController,
//                               skuCostPriceNode,
//                               'التكلفة', (result) {
//                             double.parse(result);
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuMaxPriceNode,
//                               BillPageViewModel().skuMaxPriceController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         Expanded(
//                           child: FocusableField(
//                               BillPageViewModel().skuMaxPriceController,
//                               skuMaxPriceNode,
//                               'اقصى سعر', (result) {
//                             double.parse(result);
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuSalePriceNode,
//                               BillPageViewModel().skuSalePriceController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         Expanded(
//                           child: FocusableField(
//                               BillPageViewModel().skuSalePriceController,
//                               skuSalePriceNode,
//                               'سعر البيع', (result) {
//                             double.parse(result);
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuQuantityNode,
//                               BillPageViewModel().skuQuantityController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         Expanded(
//                           child: FocusableField(
//                               BillPageViewModel().skuQuantityController,
//                               skuQuantityNode,
//                               'الكمية', (result) {
//                             double.parse(result);
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuFreeQuantityNode,
//                               BillPageViewModel().skuFreeQUantityController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         Expanded(
//                           child: FocusableField(
//                               BillPageViewModel().skuFreeQUantityController,
//                               skuFreeQuantityNode,
//                               'الكمية المجانية', (result) {
//                             double.parse(result);
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuDiscNode,
//                               BillPageViewModel().skuDiscController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         SizedBox(
//                           width: 80,
//                           child: FocusableField(
//                               BillPageViewModel().skuDiscController,
//                               skuDiscNode,
//                               'الخصم', (result) {
//                             double.parse(result);
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuTaxNode,
//                               BillPageViewModel().skuTaxController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         SizedBox(
//                           width: 90,
//                           child: FocusableField(
//                               BillPageViewModel().skuTaxController,
//                               skuTaxNode,
//                               'الضريبة', (result) {
//                             addBillEntry(foundSKU!);
//                             resumTotals();
//                             BillControleViewUpdater().add(0);
//                           },
//                               skuSearchNode,
//                               BillPageViewModel().skuTotalController,
//                               'لا يمكنك ترك السطر فارغا',
//                               false,
//                               true,
//                               false,
//                               foundSKU != null),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               const Text(
//                                 'القيمة:',
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 BillPageViewModel()
//                                     .skuTotalController
//                                     .text
//                                     .toString(),
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8),

//                         // const SizedBox(width: 8),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(bottom: 8.0),
//                         //   child: SizedBox(
//                         //     width: 100,
//                         //     child: DateTimePicker(
//                         //       decoration: InputDecoration(
//                         //         border: OutlineInputBorder(
//                         //           borderRadius: BorderRadius.circular(15),
//                         //         ),
//                         //       ),
//                         //       initialValue: expierDate.toString(),
//                         //       firstDate: DateTime(2000),
//                         //       lastDate: DateTime(2100),
//                         //       dateLabelText: 'expierDate'.tr(),
//                         //       onChanged: (val) =>
//                         //           expierDate = (DateTime.parse(val)),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'الكمية الكلية:',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               BillPageViewModel().totalQuantity.toString(),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'المجموع:',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               BillPageViewModel().totalCost.toString(),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'الضريبة:',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               BillPageViewModel().totalTax.toString(),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'الخصم:',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               BillPageViewModel().totalDiscount.toString(),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'القيمة الاجمالية:',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               BillPageViewModel().totalValuePrice.toString(),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 40,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: MaterialButton(
//                             onPressed: () {
//                               if (BillPageViewModel().totalValuePrice == 0) {
//                                 return;
//                               }
//                               getBillAgree(context);
//                             },
//                             padding: const EdgeInsets.all(12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             color: Colors.green,
//                             child: const Text(
//                               'bill',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ).tr(),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         SizedBox(
//                           width: 150,
//                           child: MaterialButton(
//                             padding: const EdgeInsets.all(12),
//                             onPressed: () {
//                               cancelAny();
//                               BillControleViewUpdater().add('');
//                             },
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             color: Colors.red,
//                             child: const Text(
//                               'cancel_bill',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ).tr(),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         SizedBox(
//                           width: 150,
//                           child: MaterialButton(
//                             padding: const EdgeInsets.all(12),
//                             onPressed: () {
//                               BillControleViewUpdater().add('');
//                               deleteLine(BillPageViewModel()
//                                   .selectedBillEntry!
//                                   .skuModel
//                                   .id);
//                             },
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             color: Colors.red,
//                             child: const Text(
//                               'الغاء السطر',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: MaterialButton(
//                             padding: const EdgeInsets.all(12),
//                             onPressed: () {
//                               updateBillEntry(BillPageViewModel()
//                                   .selectedBillEntry!
//                                   .skuModel
//                                   .id);
//                             },
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             color: Colors.green,
//                             child: const Text(
//                               'حفظ السطر',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: MaterialButton(
//                             padding: const EdgeInsets.all(12),
//                             onPressed: () {
//                               // implement Save
//                             },
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             color: Colors.green,
//                             child: const Text(
//                               'حفظ الفاتورة',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ), // const Spacer(),
//                 ],
//               ),
//             ),
//             // FutureBuilder<List<CatgoryModel>>(
//             //   future: CatgoryModel.getAll(),
//             //   builder: (context, snapshot) {
//             //     if (snapshot.hasError) {
//             //       return const Text('حدث خطأ اثناء تحميل البيانات');
//             //     }
//             //     if (snapshot.connectionState == ConnectionState.waiting) {
//             //       return const CircularProgressIndicator();
//             //     }
//             //     if (snapshot.hasData) {
//             //       models.addAll(snapshot.data!);
//             //     }
//             //     return Padding(
//             //       padding: const EdgeInsets.all(16.0),
//             //       child: Column(
//             //         children: models.map(
//             //           (model) {
//             //             return Text(model.catgoryName);
//             //           },
//             //         ).toList(),
//             //       ),
//             //     );
//             //   },
//             // ),
//           );
//         });
//   }

//   void deleteLine(int id) {
//     var entry = BillPageViewModel().billEntries[id.toString()];
//     if (entry != null) {
//       BillPageViewModel().billEntries.remove(id.toString());
//       resumTotals();
//       BillUpdater().add('');
//       BillControleViewUpdater().add('');
//     }
//   }

//   void addBillEntry(SKUModel skuModel) {
//     var entry = BillPageViewModel().billEntries[skuModel.id.toString()];
//     // If the entry is not presented then add it
//     if (entry != null) {
//     } else {
//       var total = (double.parse(
//                   BillPageViewModel().skuCostPriceController.text) *
//               double.parse(BillPageViewModel().skuQuantityController.text)) +
//           (double.parse(BillPageViewModel().skuCostPriceController.text) *
//               double.parse(BillPageViewModel().skuFreeQUantityController.text));
//       BillPageViewModel().skuTotalController.text = total.toString();

//       BillPageViewModel().billEntries.addAll({
//         skuModel.id.toString(): BillEntryModel(
//           disc: double.parse(BillPageViewModel().skuDiscController.text),
//           freeQuantity:
//               double.parse(BillPageViewModel().skuFreeQUantityController.text),
//           skuModel: SKUModel.fromMap(skuModel.toMap()),
//           quantity:
//               double.parse(BillPageViewModel().skuQuantityController.text),
//           total: total,
//           tax: double.parse(BillPageViewModel().skuTaxController.text),
//           deliveryPrice: 0,
//         )
//       });
//     }
//     // BillPageViewModel().totalValuePrice = 0;
//     // for (var rEntry in BillPageViewModel().billEntries.values) {
//     //   BillPageViewModel().totalValuePrice += rEntry.total;
//     // }
//     resumTotals();
//     BillUpdater().add('');
//     BillControleViewUpdater().add('');
//   }

//   void updateBillEntry(int id) {
//     var entry = BillPageViewModel().billEntries[id.toString()];
//     // If the entry is not presented then add it
//     if (entry != null) {
//       // BillPageViewModel().billEntries[id.toString()]!.skuModel. = ;
//       BillPageViewModel().billEntries.addAll({
//         id.toString(): BillEntryModel(
//           disc: double.parse(BillPageViewModel().skuDiscController.text),
//           freeQuantity:
//               double.parse(BillPageViewModel().skuFreeQUantityController.text),
//           skuModel: SKUModel.fromMap(
//               BillPageViewModel().billEntries[id.toString()]!.skuModel.toMap()),
//           quantity:
//               double.parse(BillPageViewModel().skuQuantityController.text),
//           total: (double.parse(
//                       BillPageViewModel().skuCostPriceController.text) *
//                   double.parse(
//                       BillPageViewModel().skuQuantityController.text)) +
//               (double.parse(BillPageViewModel().skuCostPriceController.text) *
//                   double.parse(
//                       BillPageViewModel().skuFreeQUantityController.text)),
//           tax: double.parse(BillPageViewModel().skuTaxController.text),
//           deliveryPrice: 0,
//         )
//       });
//     } else {}
//     resumTotals();
//     BillUpdater().add('');
//     BillControleViewUpdater().add('');
//   }

//   resumTotals() {
//     BillPageViewModel().totalValuePrice = 0.0;
//     BillPageViewModel().totalCost = 0.0;
//     BillPageViewModel().totalDiscount = 0.0;
//     BillPageViewModel().totalQuantity = 0.0;
//     BillPageViewModel().totalTax = 0.0;
//     BillPageViewModel().totalPayed = 0.0;
//     BillPageViewModel().totalWanted = 0.0;
//     for (var entry in BillPageViewModel().billEntries.values) {
//       BillPageViewModel().totalQuantity += entry.quantity + entry.freeQuantity;
//       BillPageViewModel().totalTax += (((entry.total) / 100) * entry.tax);
//       BillPageViewModel().totalDiscount += (((entry.total) / 100) * entry.disc);
//       BillPageViewModel().totalCost += entry.total;
//       BillPageViewModel().totalValuePrice += entry.total;
//     }
//   }
// }

// class BillUpdater extends updater.Updater {
//   BillUpdater({
//     init,
//     bool updateForCurrentEvent = false,
//   }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
// }

// class BillControleViewUpdater extends updater.Updater {
//   BillControleViewUpdater({
//     init,
//     bool updateForCurrentEvent = false,
//   }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
// }

// // class DETtextField extends StatelessWidget {
// //   const DETtextField({
// //     Key? key,
// //     this.dETtyp = DEType.string,
// //     this.controller,
// //     this.onSubmitted,
// //     this.labelText,
// //   }) : super(key: key);

// //   final DEType dETtyp;
// //   final TextEditingController? controller;
// //   final void Function(String)? onSubmitted;
// //   final String? labelText;

// //   @override
// //   Widget build(BuildContext context) {
// //     return TextField(
// //       controller: controller,
// //       onSubmitted: (result) {
// //             if (whatToSayifIsEmpty != null) {
// //               if (result.isEmpty) {
// //                 showSimpleNotification(
// //                   Text(whatToSayifIsEmpty!),
// //                   position: NotificationPosition.bottom,
// //                 );
// //                 return;
// //               }
// //             }
// //             if (isNumber) {
// //               try {
// //                 int.parse(result);
// //               } catch (e) {
// //                 showSimpleNotification(
// //                   const Text(
// //                       'تأكد من كتابتك للمعرف بصورة صحيحة حيث يحتوي على ارقام فقط'),
// //                   position: NotificationPosition.bottom,
// //                 );
// //                 return;
// //               }
// //             }
// //             onSubmited(result);
// //             nextNode?.requestFocus();
// //             nextController?.selection = TextSelection(
// //               baseOffset: 0,
// //               extentOffset: nextController!.text.length,
// //             );
// //           },
// //       keyboardType:
// //           dETtyp == DEType.string ? TextInputType.text : TextInputType.number,
// //       decoration: InputDecoration(
// //         labelText: labelText,
// //       ),
// //     );
// //   }
// // }

// // enum DEType {
// //   int,
// //   double,
// //   string,
// // }
