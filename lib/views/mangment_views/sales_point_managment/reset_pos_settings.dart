// import 'package:businet_medical_center/models/point_of_sale_model.dart';
// import 'package:businet_medical_center/models/processes_model.dart';
// import 'package:businet_medical_center/utils/system_db.dart';
// import 'package:businet_medical_center/views/widgets/done_success_ovrly_notification.dart';
// import 'package:flutter/material.dart';
// import 'package:updater/updater.dart' as updater;

// import 'points_view.dart';

// class ResetPosSettingsView extends StatefulWidget {
//   const ResetPosSettingsView({Key? key}) : super(key: key);

//   @override
//   State<ResetPosSettingsView> createState() => _ResetPosSettingsViewState();
// }

// class _ResetPosSettingsViewState extends State<ResetPosSettingsView> {
//   bool loading = false;
//   bool checkAll = false;
//   bool resetPosSettingsValue = false;
//   bool resetProcesscessValue = false;
//   late Map<String, dynamic> collectionsNamesMap = {};
//   List<String> collectionsNames = [];

//   bool checkCanDeleted(String collName) {
//     switch (collName) {
//       case 'accessLevels':
//         return false;
//       case 'systemFile':
//         return false;
//       case 'processes':
//         return false;
//       case 'users':
//         return false;
//       default:
//         return true;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     collectionsNamesInArabic.forEach((key, value) {
//       if (checkCanDeleted(key)) {
//         collectionsNamesMap.addAll({key: value});
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     collectionsNames.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('اعادة تعيين بيانات النقطة'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             updater.UpdaterBloc(
//               updater: SelectionsUpdater(
//                 init: 0,
//                 updateForCurrentEvent: true,
//               ),
//               update: (context, state) {
//                 return Column(
//                   children: [
//                     CheckboxListTile(
//                       value: checkAll,
//                       title: const Text('تحديد الكل'),
//                       onChanged: (_) {
//                         checkAll = !checkAll;
//                         if (checkAll) {
//                           collectionsNames.addAll(collectionsNamesMap.keys);
//                         } else {
//                           collectionsNames.clear();
//                         }
//                         SelectionsUpdater().add(0);
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Wrap(
//                       children: collectionsNamesMap.entries.map(
//                         (entry) {
//                           bool value = false;
//                           value = collectionsNames.contains(entry.key);
//                           return SizedBox(
//                             width: 300,
//                             child: CheckboxListTile(
//                               value: value,
//                               title: Text(entry.value['cname'] +
//                                   ' - ' +
//                                   entry.value['count'].toString()),
//                               onChanged: !checkCanDeleted(entry.key)
//                                   ? null
//                                   : (_) {
//                                       if (!value) {
//                                         collectionsNames.add(entry.key);
//                                       } else {
//                                         collectionsNames.remove(entry.key);
//                                       }
//                                       SelectionsUpdater().add(0);
//                                     },
//                             ),
//                           );
//                         },
//                       ).toList(),
//                     ),
//                     const SizedBox(height: 16),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
//                       child: Column(
//                         children: [
//                           CheckboxListTile(
//                             value: resetPosSettingsValue,
//                             title: const Text('اعادة تعيين نقاط البيع'),
//                             onChanged: (_) {
//                               resetPosSettingsValue = !resetPosSettingsValue;
//                               SelectionsUpdater().add(0);
//                             },
//                           ),
//                           CheckboxListTile(
//                             value: resetProcesscessValue,
//                             title: const Text('اعادة تعيين العمليات'),
//                             onChanged: (_) {
//                               resetProcesscessValue = !resetProcesscessValue;
//                               SelectionsUpdater().add(0);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       height: 50,
//                       width: 150,
//                       child: MaterialButton(
//                         color: Colors.blue,
//                         onPressed: resetSelected,
//                         child: const Text(
//                           'اعادة تعيين',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }

//   void resetSelected() async {
//     setState(() {
//       loading = true;
//     });

//     if (resetProcesscessValue) {
//       await _resetProcesses();
//     }
//     if (resetPosSettingsValue) {
//       await _resetPosSettings();
//     }
//     for (final collName in collectionsNames) {
//       var r = await SystemMDBService.db.collection(collName).drop();
//       print(r);
//     }
//     // if (idController.text.isEmpty) {
//     //   showSimpleNotification(
//     //     const Text('لا يمكنك ترك المعرف فارغا'),
//     //     position: NotificationPosition.bottom,
//     //   );
//     //   return;
//     // }
//   }

//   _resetPosSettings() async {
//     PointOfSaleModel stored = PointOfSaleModel.stored!;
//     stored.area = '';
//     stored.balance = 0.0;
//     stored.country = '';
//     stored.deviceName = '';
//     stored.groupId = '';
//     stored.managerPhoneNumber = '';
//     stored.metadata?.clear();
//     stored.number = 1;
//     stored.placeName = '';
//     stored.printerName = '';
//     stored.state = '';
//     stored.town = '';
//     await stored.edit().then((value) {
//       setState(() {
//         loading = false;
//         doneSuccessfulyOverLayNotification();
//       });
//     });
//   }

//   _resetProcesses() async {
//     ProcessesModel stored = ProcessesModel.stored!;
//     stored.businessDay = DateTime.now();
//     stored.currentDaty = DateTime.now();
//     stored.dayStarted = false;
//     stored.printerName = '';
//     stored.shiftNumber = 1;
//     stored.shiftStarted = false;
//     stored.lastBillId = 0;
//     stored.lastCategoryId = 0;
//     stored.lastReceiptId = 0;
//     stored.lastSKUId = 0;
//     stored.lastSaleUnitId = 0;
//     stored.lastStockId = 0;
//     stored.lastSubcategoryId = 0;
//     stored.lastSupplierId = 0;
//     stored.lastTicketId = 0;
//     await stored.edit().then((value) {
//       setState(() {
//         loading = false;
//         doneSuccessfulyOverLayNotification();
//       });
//     });
//   }
// }
