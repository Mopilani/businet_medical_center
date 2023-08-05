// import 'package:businet_medical_center/models/point_of_sale_model.dart';
// import 'package:flutter/material.dart';
// import 'package:updater/updater.dart' as updater;

// class SalePointsView extends StatefulWidget {
//   const SalePointsView({Key? key}) : super(key: key);

//   @override
//   State<SalePointsView> createState() => _SalePointsViewState();
// }

// class _SalePointsViewState extends State<SalePointsView> {
//   PointOfSaleModel pointOfSaleModel = PointOfSaleModel.stored!;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('اعدادات النقطة'),
//       ),
//       body: FutureBuilder<List<PointOfSaleModel>>(
//         future: PointOfSaleModel.getAll(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasData) {
//             final poss = snapshot.data!;
//             return GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//               ),
//               itemCount: poss.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: Column(
//                     children: [
//                       Text(
//                         poss[index].deviceName.toString(),
//                       ),
//                       Text(
//                         poss[index].placeName.toString(),
//                       ),
//                       Text(
//                         poss[index].toMap().toString(),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(
//               child: Text('لا يوجد نقاط بيع'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class SelectionsUpdater extends updater.Updater {
//   SelectionsUpdater({
//     init,
//     bool updateForCurrentEvent = false,
//   }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
// }
