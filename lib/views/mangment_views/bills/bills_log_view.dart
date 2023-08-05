// import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:pdfx/pdfx.dart';

// class ReportViewPage extends StatefulWidget {
//   const ReportViewPage(this.pdfFile, {Key? key}) : super(key: key);
//   final File pdfFile;

//   @override
//   State<ReportViewPage> createState() => _ReportViewPageState();
// }

// class _ReportViewPageState extends State<ReportViewPage>
//     with TickerProviderStateMixin {
//   late PdfController pdfController;
//   int currentIndex = 0;
//   int pagesCount = 0;

//   // Duration animationDuration = const Duration(
//   //   milliseconds: 300,
//   // );
//   // GlobalKey listenerKey = GlobalKey();

//   // final _transformWidget = GlobalKey<_TransformWidgetState>();

//   @override
//   void initState() {
//     super.initState();
//     pdfController = PdfController(
//       document: PdfDocument.openFile(widget.pdfFile.path),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   double minScale = 3.5;
//   double maxScale = 10.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('report_view').tr(),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.print_rounded),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf_rounded),
//             onPressed: () {
//               showSimpleNotification(
//                 Text(
//                   'تم الحفظ بصيغة PDF في المسار التالي: ${widget.pdfFile.path}',
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 position: NotificationPosition.bottom,
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.zoom_in),
//             onPressed: () {
//               showOverlayNotification((context) {
//                 return const Text(
//                     'اضغط بالماوس او التوتش مرتين على الصفحة للتكبير');
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.zoom_out),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.skip_next_rounded),
//             onPressed: () {
//               pagesCount = pdfController.pagesCount!;
//               if (currentIndex > 0) {
//                 currentIndex--;
//               }
//               pdfController.animateToPage(
//                 currentIndex,
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.ease,
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.skip_previous_rounded),
//             onPressed: () {
//               print(pagesCount);
//               pagesCount = pdfController.pagesCount!;
//               if (currentIndex < pagesCount) {
//                 currentIndex++;
//               }
//               pdfController.animateToPage(
//                 currentIndex,
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.ease,
//               );
//             },
//           ),
//           const SizedBox(width: 32),
//         ],
//       ),
//       body: PdfView(
//         controller: pdfController,
//       ),
//     );
//   }

//   bool twoTouchOnly = true;
// }
