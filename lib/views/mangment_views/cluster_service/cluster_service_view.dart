// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:updater/updater.dart' as updater;

// class ClusterServiceView extends StatefulWidget {
//   const ClusterServiceView({Key? key}) : super(key: key);

//   @override
//   State<ClusterServiceView> createState() => _ClusterServiceViewState();
// }

// bool debug = false;

// class _ClusterServiceViewState extends State<ClusterServiceView> {
//   bool loading = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   TextEditingController keyController =
//       TextEditingController(text: 'Businet G');
//   TextEditingController pointNumberController =
//       TextEditingController(text: '2');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('خدمة ربط نقاط البيع'),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.bug_report_outlined,
//               color: debug ? Colors.yellow : null,
//             ),
//             onPressed: () async {
//               setState(() {
//                 debug = !debug;
//                 print('Debug $debug');
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.receipt),
//             onPressed: () async {
//               var receipt = await ReceiptModel.get(345);

//               var res =
//                   await BusinetBackendSVCConnector(debug).receipt(receipt!);
//               print(res?.body);
//             },
//           ),
//         ],
//         // ignore: prefer_const_constructors
//         flexibleSpace: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 onPressed: () async {
//                   var res =
//                       await BusinetBackendSVCConnector(debug).fetchService();
//                   print(res.body);
//                   // await Process.run(
//                   //   'businet_cluster_backend_svc.exe',
//                   //   [keyController.text],
//                   // );
//                 },
//               ),
//             ),
//             // Padding(
//             //   padding: EdgeInsets.all(4.0),
//             //   child: SizedBox(
//             //     width: 100,
//             //     height: 50,
//             //     child: LinearProgressIndicator(),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 40,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: keyController,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 40,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: pointNumberController,
//                 decoration: const InputDecoration(
//                   labelText: 'رقم نقطة البيع',
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           updater.UpdaterBloc(
//             updater: SelectionsUpdater(
//               init: 0,
//               updateForCurrentEvent: true,
//             ),
//             update: (context, state) {
//               return Wrap(
//                 children: collectionsNamesInArabic.entries.map(
//                   (entry) {
//                     bool value = false;
//                     value = collectionsNames.contains(entry.key);
//                     return SizedBox(
//                       width: 300,
//                       child: CheckboxListTile(
//                         value: value,
//                         title: Text(entry.value['cname'] +
//                             ' - ' +
//                             entry.value['count'].toString()),
//                         onChanged: (_) {
//                           // collectionsNamesInArabic[entry.key] = entry.value;
//                           if (!value) {
//                             collectionsNames.add(entry.key);
//                           } else {
//                             collectionsNames.remove(entry.key);
//                           }
//                           // if (entry.value) {
//                           //   // accessLevelModel!.allowedLevels
//                           //   //     .addAll(entry.value.toMap());
//                           // } else {
//                           //   // accessLevelModel!.allowedLevels.remove(entry.key);
//                           // }
//                           // print(accessLevelModel!.allowedLevels);
//                           SelectionsUpdater().add(0);
//                         },
//                       ),
//                     );
//                   },
//                 ).toList(),
//               );
//             },
//           ),
//           const Spacer(),
//           loading
//               ? const CircularProgressIndicator()
//               : MaterialButton(
//                   color: Colors.blue,
//                   onPressed: () async {
//                     var posNumber = int.tryParse(pointNumberController.text);
//                     if (posNumber == null) {
//                       toast('تأكد من كتابتك رقم نقطة البيع بطريقة صحيحة');
//                       return;
//                     }

//                     setState(() {
//                       loading = true;
//                     });
//                     var connector = BusinetBackendSVCConnector(debug);
//                     try {
//                       final res = await connector.cloneSVCConnector(
//                           collectionsNames, posNumber);
//                       toast(json.decode(res.body)['msg']);
//                     } catch (e) {
//                       toast(e.toString());
//                       // setState(() {
//                       //   loading = false;
//                       // });
//                     }
//                     setState(() {
//                       loading = false;
//                     });
//                     // await collectData(collectionsNames);
//                     // while (true) {
//                     //   print(allDone);
//                     //   if (dones.values.length == collectionsNames.length) {
//                     //     print('////////////////////////');
//                     //     allDone = true;
//                     //     setState(() {
//                     //       loading = false;
//                     //     });
//                     //     break;
//                     //   }
//                     //   await Future.delayed(const Duration(seconds: 1));
//                     // }
//                   },
//                   child: const Text(
//                     'نقل',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }
// }
