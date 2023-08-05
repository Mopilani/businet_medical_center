
// import 'package:flutter/material.dart';

// class LabPatientAnalysisListsViewSegment extends StatelessWidget {
//   const LabPatientAnalysisListsViewSegment({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [],
//       ),
//     );
//   }

  
//   Widget wantedAnalysisListView() {
//     return updater.UpdaterBlocWithoutDisposer(
//       updater: WantedAnalysisListSegmentUpdater(
//         init: '',
//         updateForCurrentEvent: true,
//       ),
//       update: (context, s) {
//         return Row(
//           children: [
//             Expanded(
//               child: Card(
//                 child: Column(
//                   children: [
//                     const Text('تحاليل المريض المطلوبة'),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: wantedAnalysis.length,
//                         itemBuilder: (context, index) {
//                           var analysis = wantedAnalysis[index];
//                           return Card(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 8.0, right: 8.0),
//                               child: Row(
//                                 children: [
//                                   Text(analysis.description),
//                                   const Spacer(),
//                                   IconButton(
//                                     icon: const Icon(Icons.close),
//                                     onPressed: () {
//                                       wantedAnalysis
//                                           .remove(wantedAnalysis[index]);
//                                       WantedAnalysisListSegmentUpdater().add(0);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Card(
//                 child: Column(
//                   children: [
//                     DefaultTabController(
//                       length: 2,
//                       child: Expanded(
//                         child: Column(
//                           children: [
//                             tapBarWidget('كل التحاليل', 'مجموعات التحاليل'),
//                             const SizedBox(height: 16),
//                             Expanded(
//                               child: TabBarView(
//                                 children: [
//                                   allAnalysisView(),
//                                   groupedAnalysisView(),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
