// // ignore_for_file: must_be_immutable

// import 'package:businet_medical_center/models/point_of_sale_model.dart';
// import 'package:businet_medical_center/views/widgets/done_success_ovrly_notification.dart';
// import 'package:businet_medical_center/views/widgets/focusable_field.dart';
// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';

// import 'reset_pos_settings.dart';

// class PosSettingsView extends StatefulWidget {
//   PosSettingsView({
//     Key? key,
//     this.model,
//     this.editMode = false,
//   }) : super(key: key);
//   PointOfSaleModel? model;
//   final bool editMode;

//   @override
//   State<PosSettingsView> createState() => _PosSettingsViewState();
// }

// class _PosSettingsViewState extends State<PosSettingsView> {
//   PointOfSaleModel pointOfSaleModel = PointOfSaleModel.stored!;

//   late FocusNode idNode;
//   late FocusNode areaNode;
//   late FocusNode townNode;
//   late FocusNode stateNode;
//   late FocusNode countryNode;
//   late FocusNode deviceNameNode;
//   late FocusNode managerPhoneNumberNode;
//   late FocusNode placeNameNode;
//   late FocusNode printerNameNode;
//   late FocusNode numberNode;
//   late FocusNode groupIdNode;

//   late TextEditingController idController;
//   late TextEditingController areaController;
//   late TextEditingController townController;
//   late TextEditingController stateController;
//   late TextEditingController countryController;
//   late TextEditingController deviceNameController;
//   late TextEditingController managerPhoneNumberController;
//   late TextEditingController placeNameController;
//   late TextEditingController printerNameController;
//   late TextEditingController numberController;
//   late TextEditingController groupIdController;

//   bool loading = false;

//   late int id;
//   String? area;
//   String? town;
//   String? state;
//   String? country;
//   String? deviceName;
//   String? managerPhoneNumber;
//   String? placeName;
//   String? printerName;
//   String? groupId;
//   int? number;

//   bool recordShiftSANDT = false;
//   bool recordDaySANDT = false;
//   bool recordSuppliersTraffic = false;
//   bool recordCategoriesTraffic = false;
//   bool recordSubCategoriesTraffic = false;
//   bool recordSaleUnitsTraffic = false;
//   bool recordStocksTraffic = false;
//   bool recordPaymentMethodsTraffic = false;
//   bool recordSKUsTraffic = false;
//   bool recordBillsTraffic = false;
//   bool recordReceiptsTraffic = false;
//   bool recordReportsTraffic = false;
//   bool recordInvoicesTraffic = false;
//   bool recordUsersTraffic = false;

//   Map<String, dynamic> envVars = {
//     'recordShiftSANDT': false,
//     'recordDaySANDT': false,
//     'recordSuppliersTraffic': false,
//     'recordCategoriesTraffic': false,
//     'recordSubCategoriesTraffic': false,
//     'recordSaleUnitsTraffic': false,
//     'recordStocksTraffic': false,
//     'recordPaymentMethodsTraffic': false,
//     'recordSKUsTraffic': false,
//     'recordBillsTraffic': false,
//     'recordReceiptsTraffic': false,
//     'recordReportsTraffic': false,
//     'recordInvoicesTraffic': false,
//     'recordUsersTraffic': false,
//   };

//   Map<String, String> envVarsSentenses = {
//     'recordShiftSANDT': 'الورديات',
//     'recordDaySANDT': 'اليوم',
//     'recordSuppliersTraffic': 'الموردين',
//     'recordCategoriesTraffic': 'الشرائح الرئيسية',
//     'recordSubCategoriesTraffic': 'الشرائح الفرعية',
//     'recordSaleUnitsTraffic': 'وحدات البيع',
//     'recordStocksTraffic': 'المخازن',
//     'recordPaymentMethodsTraffic': 'طرق الدفع',
//     'recordSKUsTraffic': 'الاصناف',
//     'recordBillsTraffic': 'الفواتير',
//     'recordReceiptsTraffic': 'الايصالات',
//     'recordReportsTraffic': 'التنبيهات',
//     'recordInvoicesTraffic': 'الفواتير الرقمية',
//     'recordUsersTraffic': 'المستخدمين',
//   };

//   int currentSaleUnitDropDownValue = 0;
//   bool editMode = false;

//   @override
//   void initState() {
//     super.initState();
//     editMode = widget.editMode;
//     widget.model = pointOfSaleModel;

//     idNode = FocusNode();
//     groupIdNode = FocusNode();
//     areaNode = FocusNode();
//     townNode = FocusNode();
//     stateNode = FocusNode();
//     countryNode = FocusNode();
//     deviceNameNode = FocusNode();
//     managerPhoneNumberNode = FocusNode();
//     placeNameNode = FocusNode();
//     printerNameNode = FocusNode();
//     numberNode = FocusNode();
//     editMode = true;

//     if (editMode) {
//       id = widget.model!.id;
//       area = widget.model!.area;
//       town = widget.model!.town;
//       state = widget.model!.state;
//       country = widget.model!.country;
//       deviceName = widget.model!.deviceName;
//       managerPhoneNumber = widget.model!.managerPhoneNumber;
//       placeName = widget.model!.placeName;
//       printerName = widget.model!.printerName;
//       number = widget.model!.number;
//       groupId = widget.model!.groupId;
//       envVars.addAll(widget.model!.metadata!);

//       idController = TextEditingController(text: id.toString());
//       areaController = TextEditingController(text: area);
//       townController = TextEditingController(text: town);
//       stateController = TextEditingController(text: state);
//       countryController = TextEditingController(text: country);
//       deviceNameController = TextEditingController(text: deviceName);
//       managerPhoneNumberController =
//           TextEditingController(text: managerPhoneNumber);
//       placeNameController = TextEditingController(text: placeName);
//       printerNameController = TextEditingController(text: printerName);
//       numberController = TextEditingController(text: number.toString());
//       groupIdController = TextEditingController(text: groupId);
//     } else {
//       idController = TextEditingController();
//       areaController = TextEditingController();
//       townController = TextEditingController();
//       stateController = TextEditingController();
//       countryController = TextEditingController();
//       deviceNameController = TextEditingController();
//       managerPhoneNumberController = TextEditingController();
//       placeNameController = TextEditingController();
//       printerNameController = TextEditingController();
//       numberController = TextEditingController();
//       groupIdController = TextEditingController();
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     idNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('اعدادات النقطة'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.restart_alt_rounded),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ResetPosSettingsView(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: FocusableField(
//                     idController,
//                     idNode,
//                     'id',
//                     (result) {
//                       id = int.parse(result);
//                     },
//                     areaNode,
//                     areaController,
//                     'لا يمكنك ترك المعرف فارغا',
//                     true,
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                     groupIdController,
//                     groupIdNode,
//                     'gid',
//                     (result) {
//                       groupId = result;
//                     },
//                     null,
//                     null,
//                     'لا يمكنك ترك المعرف فارغا',
//                     true,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             FocusableField(
//               deviceNameController,
//               deviceNameNode,
//               'name',
//               (result) {
//                 deviceName = result;
//               },
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: FocusableField(
//                     managerPhoneNumberController,
//                     managerPhoneNumberNode,
//                     'manager_phone',
//                     (result) {
//                       managerPhoneNumber = result;
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                     placeNameController,
//                     placeNameNode,
//                     'place_name',
//                     (result) {
//                       placeName = result;
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                     printerNameController,
//                     printerNameNode,
//                     'printer_name',
//                     (result) {
//                       printerName = result;
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                       numberController, numberNode, 'point_number', (result) {
//                     number = int.parse(result);
//                   }, null, null, null, true),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: FocusableField(
//                     areaController,
//                     areaNode,
//                     'area',
//                     (result) {
//                       // area = result;
//                     },
//                     townNode,
//                     townController,
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                     townController,
//                     townNode,
//                     'town',
//                     (result) {
//                       town = result;
//                     },
//                     stateNode,
//                     stateController,
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                     stateController,
//                     stateNode,
//                     'state',
//                     (result) {
//                       state = result;
//                     },
//                     countryNode,
//                     countryController,
//                   ),
//                 ),
//                 Expanded(
//                   child: FocusableField(
//                     countryController,
//                     countryNode,
//                     'country',
//                     (result) {
//                       country = result;return true;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//               child: Row(
//                 children: const [
//                   Text(
//                     'تسجيلات الاحداث:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               children: envVars.entries.map((e) {
//                 return SizedBox(
//                   width: 250,
//                   child: CheckboxListTile(
//                     title: Text(envVarsSentenses[e.key]!),
//                     value: e.value,
//                     onChanged: (v) {
//                       setState(() {
//                         envVars[e.key] = v;
//                       });
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 32),
//             MaterialButton(
//               color: Colors.blue,
//               child: const Text(
//                 'حفظ',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                 ),
//               ),
//               onPressed: () async {
//                 setState(() {
//                   loading = true;
//                 });

//                 if (editMode) {
//                   var ins = PointOfSaleModel(
//                     id,
//                     area: area,
//                     groupId: groupId,
//                     town: town,
//                     state: state,
//                     country: country,
//                     number: number,
//                     deviceName: deviceName,
//                     managerPhoneNumber: managerPhoneNumber,
//                     placeName: placeName,
//                     printerName: printerName,
//                     metadata: envVars,
//                   );
//                   await ins.edit().then((value) {
//                     setState(() {
//                       loading = false;
//                       doneSuccessfulyOverLayNotification();
//                     });
//                   });
//                 } else {
//                   if (idController.text.isEmpty) {
//                     showSimpleNotification(
//                       const Text('لا يمكنك ترك المعرف فارغا'),
//                       position: NotificationPosition.bottom,
//                     );
//                     return;
//                   }
//                   if (deviceName!.isEmpty) {
//                     showSimpleNotification(
//                       const Text('لا يمكنك ترك اسم المعرف فارغا'),
//                       position: NotificationPosition.bottom,
//                     );
//                     return;
//                   }
//                   await PointOfSaleModel.get(id).then(
//                     (value) async {
//                       if (value == null) {
//                         var ins = PointOfSaleModel(
//                           id,
//                           area: area,
//                           groupId: groupId,
//                           town: town,
//                           state: state,
//                           country: country,
//                           number: number,
//                           deviceName: deviceName,
//                           managerPhoneNumber: managerPhoneNumber,
//                           placeName: placeName,
//                           printerName: printerName,
//                           metadata: envVars,
//                         );

//                         await ins.add().then((value) {
//                           setState(() {
//                             loading = false;
//                             doneSuccessfulyOverLayNotification();
//                           });
//                         });
//                       } else {
//                         toast('معرف المنتج مدرج بالفعل');
//                       }
//                     },
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       // body: FutureBuilder<List<PointOfSaleModel>>(
//       //   future: PointOfSaleModel.getAll(),
//       //   builder: (context, snapshot) {
//       //     if (snapshot.hasError) {
//       //       return Center(
//       //         child: Text(snapshot.error.toString()),
//       //       );
//       //     }

//       //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //       return const Center(
//       //         child: CircularProgressIndicator(),
//       //       );
//       //     }

//       //     if (snapshot.hasData) {
//       //       final poss = snapshot.data!;
//       //       return GridView.builder(
//       //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       //           crossAxisCount: 3,
//       //         ),
//       //         itemCount: poss.length,
//       //         itemBuilder: (context, index) {
//       //           return Card(
//       //             child: Column(
//       //               children: [
//       //                 Text(
//       //                   poss[index].deviceName.toString(),
//       //                 ),
//       //                 Text(
//       //                   poss[index].placeName.toString(),
//       //                 ),
//       //                 Text(
//       //                   poss[index].toMap().toString(),
//       //                 ),
//       //               ],
//       //             ),
//       //           );
//       //         },
//       //       );
//       //     } else {
//       //       return const Center(
//       //         child: Text('لا يوجد نقاط بيع'),
//       //       );
//       //     }
//       //   },
//       // ),
//     );
//   }
// }
