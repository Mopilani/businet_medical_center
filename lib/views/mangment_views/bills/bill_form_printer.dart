import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:businet_medical_center/models/bill_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/system_config.dart';
import 'package:businet_medical_center/utils/enums.dart';
import 'package:businet_medical_center/views/mangment_views/bills/widgets.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdfx/pdfx.dart';
import 'package:updater/updater.dart' as updater;

import '../../../models/point_of_sale_model.dart';
import 'bill_designer_model.dart';
import 'bills_control_page_view_model.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart' as image_viewer;

class BillFormPrinter extends StatefulWidget {
  const BillFormPrinter({Key? key, required this.billForm}) : super(key: key);
  final BillModel billForm;

  @override
  State<BillFormPrinter> createState() => _BillFormPrinterState();
}

class _BillFormPrinterState extends State<BillFormPrinter> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> showChooseStyleModel(BuildContext context) async {
    // TextEditingController noteController = TextEditingController(text: note);
    submit([tx]) {
      Navigator.pop(context);
    }

    await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              height: 500,
              width: 600,
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: 500,
                  width: 600,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // textWithButtomPad('اضافة ملاحظة لهذا الايصال'),
                        // TextField(
                        //   autofocus: true,
                        //   onSubmitted: submit,
                        //   controller: noteController,
                        //   expands: true,
                        //   maxLines: null,
                        //   minLines: null,
                        // ),
                        // const Spacer(),
                        okButton(submit),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  late PdfController pdfController;

  int currentIndex = 0;
  int pagesCount = 0;
  double zoom = 100.0;
  bool wasInitialized = false;
  bool pdfIsReady = false;

  @override
  void dispose() {
    super.dispose();
    // imageReady = false;
    // lastIndex = 0;
    imagesData.clear();
  }

  PageController pageController = PageController();

  static Completer? completer = Completer();
  Widget? wgt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          updater.UpdaterBloc(
            updater: AppBarUpdater(
              initialState: 0,
              updateForCurrentEvent: true,
            ),
            update: (context, snapshot) {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: pagesCount > 1
                        ? null
                        : () async {
                            var outputFile = File(
                              '${SystemConfig().invoicesSaveDirectoryPath}/Businet/${DateTime.now().millisecondsSinceEpoch}.png',
                            );
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) async {
                              // Because it takes some time to rasterize, here is an artificial delay of 2 seconds.
                              // See the following link.
                              // https://api.flutter.dev/flutter/flutter_driver/FlutterDriver/screenshot.html
                              // await Future.delayed(Duration(seconds: 2));
                              // if ((!completer!.isCompleted)) {
                              final rrb = Invoice
                                  .renderRepaintBoundaryKey.currentContext!
                                  .findRenderObject() as RenderRepaintBoundary;
                              final imgData =
                                  await rrb.toImage(pixelRatio: 2.0);
                              final byteData = await (imgData.toByteData(
                                  format: ui.ImageByteFormat.png));

                              final pngBytes = byteData!.buffer.asUint8List();
                              // print(pngBytes);
                              outputFile.writeAsBytesSync(pngBytes);
                              // completer!.complete(pngBytes);
                              // }
                            });

                            // _pageWidget = ScreenshotMaker(
                            //   outputFile: targetFile,
                            //   size: const Size(1600, 2400),
                            //   completer: compeleter,
                            //   child: _invoiceWidget,
                            // );
                            // print('Done Successfully, Save To ${targetFile.path}');
                            InvoicePageUpdater().add(0);
                            await completer!.future.then((value) {
                              // print(value);
                              print(
                                  'Done Successfully, Save To ${outputFile.path}');
                              toast(
                                'Done Successfully, Save To ${outputFile.path}',
                              );
                              // Navigator.pop(context);
                            }, onError: (e) {
                              print(e);
                              toast(
                                e.toString(),
                              );
                            });
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    onPressed: () {
                      // showSimpleNotification(
                      //   Text(
                      //     'تم الحفظ بصيغة PDF في المسار التالي: $pdfFilePath',
                      //     style: const TextStyle(fontSize: 20),
                      //   ),
                      //   position: NotificationPosition.bottom,
                      // );
                    },
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.close_rounded),
                  //   onPressed: () {
                  //     setState(() {
                  //       //   reportIsReadyToView = false;
                  //     });
                  //   },
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.zoom_in),
                  //   onPressed: () {
                  //     setState(() {
                  //       zoom += 1.1;
                  //     });
                  //   },
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.zoom_out),
                  //   onPressed: () {
                  //     setState(() {
                  //       zoom += 1.1;
                  //     });
                  //   },
                  // ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    onPressed: () {
                      try {
                        pagesCount = pdfController.pagesCount!;
                      } catch (e) {
                        pagesCount = imagesData.length;
                      }
                      if (currentIndex > 0) {
                        currentIndex--;
                      }
                      try {
                        pdfController.animateToPage(
                          currentIndex,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      } catch (e) {
                        pageController.animateToPage(
                          currentIndex,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      }
                      AppBarUpdater().add('');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Text('${imagesData.length} - ${currentIndex + 1}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    onPressed: () {
                      // print(pagesCount);
                      try {
                        pagesCount = pdfController.pagesCount!;
                      } catch (e) {
                        pagesCount = imagesData.length;
                      }
                      if (currentIndex < (pagesCount - 1)) {
                        currentIndex++;
                      }
                      try {
                        pdfController.animateToPage(
                          currentIndex,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      } catch (e) {
                        pageController.animateToPage(
                          currentIndex,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      }
                      AppBarUpdater().add('');
                    },
                  ),
                  const SizedBox(width: 32),
                ],
              );
            },
          ),
        ],
      ),
      body: updater.UpdaterBloc(
        updater: InvoiceBodyUpdater(
          initialState: 'thereIsMore',
          updateForCurrentEvent: true,
        ),
        update: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'setState') {
              print('setState');
              // Future.delayed(const Duration(milliseconds: 100), () {
              //   build(context);
              //   setState(() {});
              // });
            }
            print(snapshot.data);
            if (snapshot.data == 'thereIsMore') {
              // Future.delayed(const Duration(milliseconds: 100), () {
              //   build(context);
              //   setState(() {});
              // });
              // wgt = null;
              // wgt = CustomerInvoiceBody(
              //   billModel: widget.billForm,
              //   // key: UniqueKey(),
              // );
              // Future.delayed(const Duration(milliseconds: 100), () {
              //   setState(() {});
              // });
            }
          }
          return !pdfIsReady
              ? Stack(
                  children: [
                    // wgt ?? const SizedBox(),
                    CustomerInvoiceBody(billModel: widget.billForm),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                    PageView.builder(
                      itemCount: imagesData.length,
                      controller: pageController,
                      itemBuilder: (context, index) {
                        // return imageReady ?
                        return () {
                          ImageProvider imageProvider =
                              MemoryImage(imagesData[currentIndex]);
                          return image_viewer.EasyImageView(
                            imageProvider: imageProvider,
                            doubleTapZoomable: true,
                          );
                        }();
                        // : const CircularProgressIndicator();
                        // : CustomerInvoiceBody(billModel: widget.billForm);
                      },
                    ),
                  ],
                )
              : FutureBuilder<Uint8List>(
                  future: BillsDesigner.getFor(widget.billForm),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      // throw snap.stackTrace!;
                      // return Center(
                      //   child: Text('Error: ${snap.error}'),
                      // );
                    }
                    if (snap.hasData) {
                      if (!wasInitialized) {
                        pdfController = PdfController(
                            document: PdfDocument.openData(snap.data!));
                        wasInitialized = true;
                      }
                      return PdfView(controller: pdfController);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
        },
      ),
    );
  }
}

late Widget _invoiceWidget;
// Widget? _pageWidget;

class CustomerInvoiceBody extends StatefulWidget {
  const CustomerInvoiceBody({
    Key? key,
    this.invoiceWidget,
    required this.billModel,
  }) : super(key: key);
  final Widget? invoiceWidget;
  final BillModel billModel;

  @override
  State<CustomerInvoiceBody> createState() => _CustomerInvoiceBodyState();
}

class _CustomerInvoiceBodyState extends State<CustomerInvoiceBody> {
  @override
  void initState() {
    super.initState();
    if (widget.invoiceWidget != null) {
      _invoiceWidget = widget.invoiceWidget!;
    } else {
      _invoiceWidget = Invoice(billModel: widget.billModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SD'),
      ],
      // path: 'assets/translations',
      // useFallbackTranslations: true,
      // startLocale: const Locale('ar', 'SD'),
      fallbackLocale: const Locale('ar', 'SD'),
      home: MaterialApp(
        // localizationsDelegates: context.localizationDelegates,
        // supportedLocales: context.supportedLocales,
        // locale: context.locale,
        title: 'Businet Sales Managment Demo',
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(
          child: updater.UpdaterBloc(
            updater: InvoicePageUpdater(
              initialState: 0,
              updateForCurrentEvent: true,
            ),
            update: (context, state) {
              return Column(
                children: [
                  _invoiceWidget,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// bool imageReady = false;
List<Uint8List> imagesData = [];

// ignore: must_be_immutable
class Invoice extends StatefulWidget {
  Invoice({Key? key, required this.billModel}) : super(key: key);
  final BillModel billModel;
  static GlobalKey renderRepaintBoundaryKey = GlobalKey();

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  bool takeScreenShot = false;
  bool takeingScreenShot = false;
  final double multiplier = 2.0;

  bool pageDone = false;
  bool allDone = false;

  int currnentPageIndex = 0;
  int lastIndex = 0;

  Widget? validWid;

  int currentIndex = 0;

  double reminingHeightSpace = 0;

  List<TableRow> oldRows = [];
  List<Map> pagesData = [
    {
      'first': true,
      'last': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    try {
      return updater.UpdaterBloc(
        updater: PainterUpdater(
          initialState: '',
          updateForCurrentEvent: true,
        ),
        update: (context, state) {
          if (takeScreenShot) {
            // print('Update takeScreenShot of index $currentIndex');
            takeScreenShot = false;
            takeingScreenShot = true;
            // pagesData.add({
            //   'first': currnentPageIndex == 0,
            //   'last': allDone,
            // });
            // currnentPageIndex += 1;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              final rrb = Invoice.renderRepaintBoundaryKey.currentContext!
                  .findRenderObject() as RenderRepaintBoundary;
              final imgData = await rrb.toImage(pixelRatio: 1.0);
              final byteData =
                  await (imgData.toByteData(format: ui.ImageByteFormat.png));

              imagesData.add(byteData!.buffer.asUint8List());

              InvoiceBodyUpdater().add('');
              AppBarUpdater().add('');
              pageDone = false;
              takeingScreenShot = false;
              Future.delayed(const Duration(milliseconds: 5), () {
                PainterUpdater().add('');
              });
            });
          }

          List<TableRow> _rows = (takeingScreenShot || allDone)
              ? oldRows
              : () {
                  List<TableRow> rows = [];
                  for (var index = lastIndex;
                      index < (widget.billModel.billEntries.length);
                      index++) {
                    var enteries = widget.billModel.billEntries.values.toList();
                    rows.add(
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              (enteries[index].skuModel.description!),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              enteries[index].skuModel.costPrice.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              enteries[index].quantity.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              (enteries[index].total).toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (enteries[index].note).toString(),
                              textAlign: TextAlign.right,
                              // softWrap: true,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          // LayoutBuilder(builder: (contextm, consts) {
                          //   print(consts.maxWidth);
                          //   return Padding(padding: const EdgeInsets.all(4),
                          //     child: Row(children: [],),); }),
                        ],
                      ),
                    );
                    print(
                        'reminingHeightSpace: $reminingHeightSpace $lastIndex');
                    if (currentIndex > 1 &&
                        reminingHeightSpace < 1 &&
                        !pageDone) {
                      print('End Of The Page');
                      // PainterUpdater().add('');
                      // oldRows.removeLast();
                      oldRows.removeLast();
                      // rows.removeLast();
                      currentIndex -= 1;
                      lastIndex = (currentIndex);

                      takeScreenShot = true;

                      pageDone = true;
                      currnentPageIndex += 1;

                      AppBarUpdater().add('');
                      Future.delayed(const Duration(milliseconds: 2), () {
                        PainterUpdater().add('');
                      });
                      print('Row Contains: ${oldRows.length}');
                      return oldRows;
                    }

                    if ((currentIndex) >= widget.billModel.billEntries.length &&
                        !pageDone) {
                      print(
                          '=========== Done ${(lastIndex + index)} - ${widget.billModel.billEntries.length}');
                      takeScreenShot = true;

                      pageDone = true;
                      currnentPageIndex += 1;

                      allDone = true;

                      AppBarUpdater().add('');
                      InvoiceBodyUpdater().add('setState');
                      InvoiceBodyUpdater().add('thereIsMore');
                      Future.delayed(const Duration(milliseconds: 2), () {
                        PainterUpdater().add('');
                      });
                      // break;
                      return oldRows;
                    }
                    if (currentIndex == index) {
                      currentIndex++;
                      print('currentIndex: $currentIndex == $index');
                      Future.delayed(const Duration(milliseconds: 2), () {
                        PainterUpdater().add('');
                      });
                      // return oldRows;
                      break;
                    }
                  } // End of for loop
                  oldRows = rows;
                  return oldRows;
                }();
          return RepaintBoundary(
            key: Invoice.renderRepaintBoundaryKey,
            child: SizedBox(
              height: pdf.PdfPageFormat.a3.height * multiplier,
              width: pdf.PdfPageFormat.a3.width * multiplier,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: SizedBox(
                  height: pdf.PdfPageFormat.a3.height * multiplier,
                  width: pdf.PdfPageFormat.a3.width * multiplier,
                  child: Padding(
                    padding: EdgeInsets.all(
                        pdf.PdfPageFormat.a3.marginRight * multiplier),
                    child: Column(
                      children: [
                        !(allDone || currnentPageIndex > 1)
                            ? Text(
                                PointOfSaleModel.stored!.placeName!,
                                style: TextStyle(
                                  fontSize: 20 * multiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : currnentPageIndex > 1
                                ? SizedBox(height: 20 * multiplier)
                                : Text(
                                    PointOfSaleModel.stored!.placeName!,
                                    style: TextStyle(
                                      fontSize: 20 * multiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     :
                        const SizedBox(height: 16),
                        (allDone || currnentPageIndex > 1)
                            ? currnentPageIndex > 1
                                ? SizedBox(height: 24 * multiplier)
                                : Text(
                                    billTypes[widget.billModel.billType!.index],
                                    style: TextStyle(
                                      fontSize: 24 * multiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                            : Text(
                                billTypes[widget.billModel.billType!.index],
                                style: TextStyle(
                                  fontSize: 24 * multiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     :
                        SizedBox(height: 16 * multiplier),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     :
                        const Divider(),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     :
                        SizedBox(height: 16 * multiplier),
                        (allDone || currnentPageIndex > 1)
                            ? currnentPageIndex > 1
                                ? SizedBox(height: 14 * multiplier)
                                : Text(
                                    "تحريرا في: ${dateToString(widget.billModel.createDate, '/')}",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                            : Text(
                                "تحريرا في: ${dateToString(widget.billModel.createDate, '/')}",
                                style: TextStyle(
                                  fontSize: 14 * multiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     : const
                        const SizedBox(height: 16),
                        (allDone || currnentPageIndex > 1)
                            ? currnentPageIndex > 1
                                ? SizedBox(height: 14 * multiplier)
                                : Row(
                                    children: [
                                      Text(
                                        "الجهة الطالبة: ${PointOfSaleModel.stored!.placeName!}",
                                        style: TextStyle(
                                          fontSize: 14 * multiplier,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                            : Row(
                                children: [
                                  Text(
                                    "الجهة الطالبة: ${PointOfSaleModel.stored!.placeName!}",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     :
                        const SizedBox(height: 16),
                        (allDone || currnentPageIndex > 1)
                            ? currnentPageIndex > 1
                                ? SizedBox(height: 14 * multiplier)
                                : Row(
                                    children: [
                                      Text(
                                        widget.billModel.billType ==
                                                BillType.goodsReceived
                                            ? "تم استلام الاصناف المبينة أدناه خلال: ${dateToString(widget.billModel.incomingDate, '/')}"
                                            : "المطلوب شراء الاصناف المبينة أدناه على أن يتم التوريد خلال: ${dateToString(widget.billModel.incomingDate, '/')}",
                                        style: TextStyle(
                                          fontSize: 14 * multiplier,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                            : Row(
                                children: [
                                  Text(
                                    widget.billModel.billType ==
                                            BillType.goodsReceived
                                        ? "تم استلام الاصناف المبينة أدناه خلال: ${dateToString(widget.billModel.incomingDate, '/')}"
                                        : "المطلوب شراء الاصناف المبينة أدناه على أن يتم التوريد خلال: ${dateToString(widget.billModel.incomingDate, '/')}",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        // !(currnentPageIndex != 0)
                        //     ? const SizedBox()
                        //     :
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 1450,
                          child: Column(
                            children: [
                              Table(
                                columnWidths: {
                                  // 0: FixedColumnWidth(100 * multiplier),
                                  // 1: FixedColumnWidth(100),
                                  2: FixedColumnWidth(60 * multiplier),
                                  // 3: FixedColumnWidth(60 * multiplier),
                                  4: FixedColumnWidth(200 * multiplier),
                                  // 0: IntrinsicColumnWidth(flex: 2),
                                },
                                border: TableBorder.symmetric(
                                  inside: const BorderSide(width: 1),
                                  outside: const BorderSide(width: 1),
                                ),
                                children: [
                                  TableRow(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          'اسم الصنف',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          'سعر الوحدة',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          'الكمية',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          'اجمالي السعر',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      widget.billModel.billType ==
                                              BillType.goodsReceived
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                '',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'ملاحظة',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  ..._rows,
                                ],
                              ),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, consts) {
                                    reminingHeightSpace = consts.maxHeight;
                                    // print(reminingHeightSpace);
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        !allDone
                            ? const SizedBox()
                            : SizedBox(height: 16 * multiplier),
                        !allDone
                            ? SizedBox(height: 14 * multiplier)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "مدير الادارة: ..................................",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        !allDone
                            ? const SizedBox()
                            : SizedBox(height: 16 * multiplier),
                        !allDone
                            ? SizedBox(height: 14 * multiplier)
                            : Row(
                                children: [
                                  Text(
                                    widget.billModel.billType ==
                                            BillType.goodsReceived
                                        ? "فاتورة استلام بضاعة رقم: ${widget.billModel.supplierModel.id}  بتاريخ: ${dateToString(widget.billModel.createDate, '/')}"
                                        : "تم اصدار أمر شراء رقم: ${widget.billModel.supplierModel.id}  بتاريخ: ${dateToString(widget.billModel.createDate, '/')}",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        !allDone
                            ? const SizedBox()
                            : SizedBox(height: 16 * multiplier),
                        !allDone
                            ? SizedBox(height: 14 * multiplier)
                            : Row(
                                children: [
                                  Text(
                                    "اسم المورد: ${widget.billModel.supplierModel.name}   -   عنوانه: ${widget.billModel.supplierModel.town}, ${widget.billModel.supplierModel.state}, ${widget.billModel.supplierModel.country}",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        !allDone
                            ? const SizedBox()
                            : SizedBox(height: 16 * multiplier),
                        !allDone
                            ? SizedBox(height: 14 * multiplier)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.billModel.billType ==
                                            BillType.goodsReceived
                                        ? "تاريخ الاستلام: ${dateToString(widget.billModel.incomingDate, '/')}"
                                        : "تاريخ التوريد: ${dateToString(widget.billModel.incomingDate, '/')}",
                                    style: TextStyle(
                                      fontSize: 14 * multiplier,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        !allDone
                            ? const SizedBox()
                            : SizedBox(height: 16 * multiplier),
                        !allDone
                            ? SizedBox(height: 12 * multiplier)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "مدير المشتريات: ${'${widget.billModel.userModel.firstname} ${widget.billModel.userModel.lastname}'}",
                                    style: TextStyle(
                                      fontSize: 12 * multiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                        !allDone
                            ? const SizedBox()
                            : const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } catch (E) {
      print(E);
      return const CircularProgressIndicator();
    }
  }
}

// class TestThePain extends StatelessWidget {
//   const TestThePain({Key? key, required this.child}) : super(key: key);
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return child;
//   }
// }

class InvoiceBodyUpdater extends updater.Updater {
  InvoiceBodyUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
}

class InvoicePageUpdater extends updater.Updater {
  InvoicePageUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
}

class AppBarUpdater extends updater.Updater {
  AppBarUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
}

class PainterUpdater extends updater.Updater {
  PainterUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
}

// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:businet/models/bill_model.dart';
// import 'package:businet/models/processes_model.dart';
// import 'package:businet/models/system_config.dart';
// import 'package:businet/views/mangment_views/bills/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:pdf/pdf.dart' as pdf;
// import 'package:pdfx/pdfx.dart';
// import 'package:updater/updater.dart' as updater;

// import '../../../models/point_of_sale_model.dart';
// import 'bill_designer_model.dart';
// import 'bills_controle_page_view_model.dart';
// import 'package:easy_image_viewer/easy_image_viewer.dart' as image_viewer;

// class BillFormPrinter extends StatefulWidget {
//   const BillFormPrinter({Key? key, required this.billForm}) : super(key: key);
//   final BillModel billForm;

//   @override
//   State<BillFormPrinter> createState() => _BillFormPrinterState();
// }

// class _BillFormPrinterState extends State<BillFormPrinter> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> showChooseStyleModel(BuildContext context) async {
//     // TextEditingController noteController = TextEditingController(text: note);
//     submit([tx]) {
//       Navigator.pop(context);
//     }

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return Material(
//           color: Colors.transparent,
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               alignment: Alignment.center,
//               color: Colors.transparent,
//               height: 500,
//               width: 600,
//               child: GestureDetector(
//                 onTap: () {},
//                 child: SizedBox(
//                   height: 500,
//                   width: 600,
//                   child: Card(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         // textWithButtomPad('اضافة ملاحظة لهذا الايصال'),
//                         // TextField(
//                         //   autofocus: true,
//                         //   onSubmitted: submit,
//                         //   controller: noteController,
//                         //   expands: true,
//                         //   maxLines: null,
//                         //   minLines: null,
//                         // ),
//                         // const Spacer(),
//                         okButton(submit),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   late PdfController pdfController;

//   int currentIndex = 0;
//   int pagesCount = 0;
//   double zoom = 100.0;
//   bool wasInitialized = false;
//   bool pdfIsReady = false;

//   @override
//   void dispose() {
//     super.dispose();
//     // imageReady = false;
//     lastIndex = 0;
//     imagesData.clear();
//   }

//   PageController pageController = PageController();

//   static Completer? completer = Completer();
//   Widget? wgt;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           updater.UpdaterBloc(
//               updater: AppBarUpdater(
//                 initialState: 0,
//                 updateForCurrentEvent: true,
//               ),
//               update: (context, snapshot) {
//                 return Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.image),
//                       onPressed: () async {
//                         var outputFile = File(
//                           '${SystemConfig.invoicesSaveDirectoryPath}/Businet/${DateTime.now().millisecondsSinceEpoch}.png',
//                         );
//                         WidgetsBinding.instance
//                             .addPostFrameCallback((timeStamp) async {
//                           // Because it takes some time to rasterize, here is an artificial delay of 2 seconds.
//                           // See the following link.
//                           // https://api.flutter.dev/flutter/flutter_driver/FlutterDriver/screenshot.html
//                           // await Future.delayed(Duration(seconds: 2));
//                           // if ((!completer!.isCompleted)) {
//                           final rrb = Invoice
//                               .renderRepaintBoundaryKey.currentContext!
//                               .findRenderObject() as RenderRepaintBoundary;
//                           final imgData = await rrb.toImage(pixelRatio: 2.0);
//                           final byteData = await (imgData.toByteData(
//                               format: ui.ImageByteFormat.png));

//                           final pngBytes = byteData!.buffer.asUint8List();
//                           // print(pngBytes);
//                           outputFile.writeAsBytesSync(pngBytes);
//                           // completer!.complete(pngBytes);
//                           // }
//                         });

//                         // _pageWidget = ScreenshotMaker(
//                         //   outputFile: targetFile,
//                         //   size: const Size(1600, 2400),
//                         //   completer: compeleter,
//                         //   child: _invoiceWidget,
//                         // );
//                         // print('Done Successfully, Save To ${targetFile.path}');
//                         InvoicePageUpdater().add(0);
//                         await completer!.future.then((value) {
//                           // print(value);
//                           print(
//                               'Done Successfully, Save To ${outputFile.path}');
//                           toast(
//                             'Done Successfully, Save To ${outputFile.path}',
//                           );
//                           // Navigator.pop(context);
//                         }, onError: (e) {
//                           print(e);
//                           toast(
//                             e.toString(),
//                           );
//                         });
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.picture_as_pdf_rounded),
//                       onPressed: () {
//                         // showSimpleNotification(
//                         //   Text(
//                         //     'تم الحفظ بصيغة PDF في المسار التالي: $pdfFilePath',
//                         //     style: const TextStyle(fontSize: 20),
//                         //   ),
//                         //   position: NotificationPosition.bottom,
//                         // );
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close_rounded),
//                       onPressed: () {
//                         setState(() {
//                           //   reportIsReadyToView = false;
//                         });
//                       },
//                     ),
//                     // IconButton(
//                     //   icon: const Icon(Icons.zoom_in),
//                     //   onPressed: () {
//                     //     setState(() {
//                     //       zoom += 1.1;
//                     //     });
//                     //   },
//                     // ),
//                     // IconButton(
//                     //   icon: const Icon(Icons.zoom_out),
//                     //   onPressed: () {
//                     //     setState(() {
//                     //       zoom += 1.1;
//                     //     });
//                     //   },
//                     // ),
//                     IconButton(
//                       icon: const Icon(Icons.skip_next_rounded),
//                       onPressed: () {
//                         try {
//                           pagesCount = pdfController.pagesCount!;
//                         } catch (e) {
//                           pagesCount = imagesData.length;
//                         }
//                         if (currentIndex > 0) {
//                           currentIndex--;
//                         }
//                         try {
//                           pdfController.animateToPage(
//                             currentIndex,
//                             duration: const Duration(milliseconds: 200),
//                             curve: Curves.ease,
//                           );
//                         } catch (e) {
//                           pageController.animateToPage(
//                             currentIndex,
//                             duration: const Duration(milliseconds: 200),
//                             curve: Curves.ease,
//                           );
//                         }
//                         AppBarUpdater().add('');
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
//                       child: Text('${imagesData.length} - $currentIndex'),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.skip_previous_rounded),
//                       onPressed: () {
//                         // print(pagesCount);
//                         try {
//                           pagesCount = pdfController.pagesCount!;
//                         } catch (e) {
//                           pagesCount = imagesData.length;
//                         }
//                         if (currentIndex < pagesCount) {
//                           currentIndex++;
//                         }
//                         try {
//                           pdfController.animateToPage(
//                             currentIndex,
//                             duration: const Duration(milliseconds: 200),
//                             curve: Curves.ease,
//                           );
//                         } catch (e) {
//                           pageController.animateToPage(
//                             currentIndex,
//                             duration: const Duration(milliseconds: 200),
//                             curve: Curves.ease,
//                           );
//                         }
//                         AppBarUpdater().add('');
//                       },
//                     ),
//                     const SizedBox(width: 32),
//                   ],
//                 );
//               }),
//         ],
//       ),
//       body: updater.UpdaterBloc(
//         updater: InvoiceBodyUpdater(
//           initialState: 'thereIsMore',
//           updateForCurrentEvent: true,
//         ),
//         update: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data == 'setState') {
//               print('setState');
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 setState(() {});
//               });
//             }
//             print(snapshot.data);
//             if (snapshot.data == 'thereIsMore') {
//               // wgt = null;
//               // wgt = CustomerInvoiceBody(
//               //   billModel: widget.billForm,
//               //   // key: UniqueKey(),
//               // );
//               // Future.delayed(const Duration(milliseconds: 100), () {
//               //   setState(() {});
//               // });
//             }
//           }
//           return !pdfIsReady
//               ? Stack(
//                   children: [
//                     // wgt ?? const SizedBox(),
//                     CustomerInvoiceBody(billModel: widget.billForm),
//                     Container(
//                         height: MediaQuery.of(context).size.height,
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.black),
//                     PageView.builder(
//                       itemCount: imagesData.length,
//                       controller: pageController,
//                       itemBuilder: (context, index) {
//                         // return imageReady ?
//                         return () {
//                           ImageProvider imageProvider =
//                               MemoryImage(imagesData[currentIndex]);
//                           return image_viewer.EasyImageView(
//                             imageProvider: imageProvider,
//                             doubleTapZoomable: true,
//                           );
//                         }();
//                         // : const CircularProgressIndicator();
//                         // : CustomerInvoiceBody(billModel: widget.billForm);
//                       },
//                     ),
//                   ],
//                 )
//               : FutureBuilder<Uint8List>(
//                   future: BillsDesigner.getFor(widget.billForm),
//                   builder: (context, snap) {
//                     if (snap.hasError) {
//                       // throw snap.stackTrace!;
//                       // return Center(
//                       //   child: Text('Error: ${snap.error}'),
//                       // );
//                     }
//                     if (snap.hasData) {
//                       if (!wasInitialized) {
//                         pdfController = PdfController(
//                             document: PdfDocument.openData(snap.data!));
//                         wasInitialized = true;
//                       }
//                       return PdfView(controller: pdfController);
//                     }
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   },
//                 );
//         },
//       ),
//     );
//   }
// }

// late Widget _invoiceWidget;
// // Widget? _pageWidget;

// class CustomerInvoiceBody extends StatefulWidget {
//   const CustomerInvoiceBody({
//     Key? key,
//     this.invoiceWidget,
//     required this.billModel,
//   }) : super(key: key);
//   final Widget? invoiceWidget;
//   final BillModel billModel;

//   @override
//   State<CustomerInvoiceBody> createState() => _CustomerInvoiceBodyState();
// }

// class _CustomerInvoiceBodyState extends State<CustomerInvoiceBody> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.invoiceWidget != null) {
//       _invoiceWidget = widget.invoiceWidget!;
//     } else {
//       _invoiceWidget = Invoice(billModel: widget.billModel);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: updater.UpdaterBloc(
//         updater: InvoicePageUpdater(
//           initialState: 0,
//           updateForCurrentEvent: true,
//         ),
//         update: (context, state) {
//           return Column(
//             children: [
//               _invoiceWidget,
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// // bool imageReady = false;
// List<Uint8List> imagesData = [];
// int lastIndex = 0;

// // ignore: must_be_immutable
// class Invoice extends StatelessWidget {
//   Invoice({Key? key, required this.billModel}) : super(key: key);
//   final BillModel billModel;
//   static GlobalKey renderRepaintBoundaryKey = GlobalKey();
//   final double multiplier = 2.0;

//   Widget? validWid;
//   int currentIndex = 0;
//   double reminingHeightSpace = 0;
//   List<TableRow> oldRows = [];

//   @override
//   Widget build(BuildContext context) {
//     try {
//       return updater.UpdaterBloc(
//         updater: PainterUpdater(
//           initialState: '',
//           updateForCurrentEvent: true,
//         ),
//         update: (context, state) {
//           List<TableRow> _rows = () {
//             List<TableRow> rows = [];
//             for (var index = 0;
//                 index < (billModel.billEntries.length - lastIndex);
//                 index++) {
//               var enteries =
//                   billModel.billEntries.values.toList().sublist(lastIndex);
//               print(enteries[index].skuModel.description);
//               rows.add(
//                 TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Text(
//                         (enteries[index].skuModel.description!),
//                         textAlign: TextAlign.right,
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Text(
//                         enteries[index].skuModel.costPrice.toString(),
//                         textAlign: TextAlign.right,
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Text(
//                         enteries[index].quantity.toString(),
//                         textAlign: TextAlign.right,
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Text(
//                         (enteries[index].total).toString(),
//                         textAlign: TextAlign.right,
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         (enteries[index].note).toString(),
//                         textAlign: TextAlign.right,
//                         // softWrap: true,
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     // LayoutBuilder(builder: (contextm, consts) {
//                     //   print(consts.maxWidth);
//                     //   return Padding(
//                     //     padding: const EdgeInsets.all(4),
//                     //     child: Row(
//                     //       children: [

//                     //       ],
//                     //     ),
//                     //   );
//                     // }),
//                   ],
//                 ),
//               );
//               print('reminingHeightSpace: $reminingHeightSpace $lastIndex');
//               if (currentIndex > 1 && reminingHeightSpace < 1) {
//                 // PainterUpdater().add('');
//                 oldRows.removeLast();
//                 WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//                   final rrb = Invoice.renderRepaintBoundaryKey.currentContext!
//                       .findRenderObject() as RenderRepaintBoundary;
//                   final imgData = await rrb.toImage(pixelRatio: 2.0);
//                   final byteData = await (imgData.toByteData(
//                       format: ui.ImageByteFormat.png));

//                   imagesData.add(byteData!.buffer.asUint8List());
//                   // File('${SystemConfig.invoicesSaveDirectoryPath}/Businet/0.png')
//                   //     .writeAsBytesSync(bytes);
//                   // imageReady = true;
//                   // InvoiceBodyUpdater().add('');
//                   // imageReady = true;
//                   lastIndex = (currentIndex);
//                   // currentIndex = 0;

//                   InvoiceBodyUpdater().add('setState');
//                   oldRows.clear();
//                   rows.clear();
//                   if (lastIndex < billModel.billEntries.length) {
//                     InvoiceBodyUpdater().add('thereIsMore');
//                   }
//                   AppBarUpdater().add('');
//                 });
//                 AppBarUpdater().add('');
//                 // return oldRows;
//               }
//               if ((lastIndex + currentIndex) >= billModel.billEntries.length) {
//                 print(
//                     '=========== Done ${(lastIndex + currentIndex)} - ${billModel.billEntries.length}');
//                 // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//                 //   final rrb = Invoice.renderRepaintBoundaryKey.currentContext!
//                 //       .findRenderObject() as RenderRepaintBoundary;
//                 //   final imgData = await rrb.toImage(pixelRatio: 1.0);
//                 //   final byteData = await (imgData.toByteData(
//                 //       format: ui.ImageByteFormat.png));

//                 //   imagesData.add(byteData!.buffer.asUint8List());
//                 //   // File('${SystemConfig.invoicesSaveDirectoryPath}/Businet/0.png')
//                 //   //     .writeAsBytesSync(bytes);
//                 //   // imageReady = true;
//                 //   // InvoiceBodyUpdater().add('');
//                 //   // imageReady = true;
//                 //   lastIndex = (currentIndex);
//                 //   // currentIndex = 0;

//                 //   // InvoiceBodyUpdater().add('setState');
//                 //   oldRows.clear();
//                 //   // InvoiceBodyUpdater().add('thereIsMore');
//                 //   AppBarUpdater().add('');
//                 // });
//               }
//               if (currentIndex == index) {
//                 currentIndex++;
//                 print(currentIndex);
//                 Future.delayed(const Duration(milliseconds: 50), () {
//                   PainterUpdater().add('');
//                 });
//                 break;
//               }
//             }
//             oldRows = rows;
//             return rows;
//           }();
//           return RepaintBoundary(
//             key: renderRepaintBoundaryKey,
//             child: SizedBox(
//               height: pdf.PdfPageFormat.a3.height * multiplier,
//               width: pdf.PdfPageFormat.a3.width * multiplier,
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: SizedBox(
//                   height: pdf.PdfPageFormat.a3.height * multiplier,
//                   width: pdf.PdfPageFormat.a3.width * multiplier,
//                   child: Padding(
//                     padding: EdgeInsets.all(
//                         pdf.PdfPageFormat.a3.marginRight * multiplier),
//                     child: Column(
//                       children: [
//                         Text(
//                           PointOfSaleModel.stored!.placeName!,
//                           style: TextStyle(
//                             fontSize: 20 * multiplier,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           billTypes[billModel.billType!.index],
//                           style: TextStyle(
//                             fontSize: 32 * multiplier,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 16 * multiplier),
//                         const Divider(),
//                         SizedBox(height: 16 * multiplier),
//                         Text(
//                           "تحريرا في: ${dateToString(billModel.createDate, '/')}",
//                           style: TextStyle(
//                             fontSize: 14 * multiplier,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Text(
//                               "الجهة الطالبة: ${PointOfSaleModel.stored!.placeName!}",
//                               style: TextStyle(
//                                 fontSize: 14 * multiplier,
//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Text(
//                               "المطلوب شراء الاصناف المبينة أدناه على أن يتم التوريد خلال: ${dateToString(billModel.incomingDate, '/')}",
//                               style: TextStyle(
//                                 fontSize: 14 * multiplier,
//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Table(
//                           columnWidths: {
//                             // 0: FixedColumnWidth(100 * multiplier),
//                             // 1: FixedColumnWidth(100),
//                             2: FixedColumnWidth(60 * multiplier),
//                             // 3: FixedColumnWidth(60 * multiplier),
//                             4: FixedColumnWidth(200 * multiplier),
//                             // 0: IntrinsicColumnWidth(flex: 2),
//                           },
//                           border: TableBorder.symmetric(
//                             inside: const BorderSide(width: 1),
//                             outside: const BorderSide(width: 1),
//                           ),
//                           children: [
//                             const TableRow(
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.all(4),
//                                   child: Text(
//                                     'اسم الصنف',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(4),
//                                   child: Text(
//                                     'سعر الوحدة',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(4),
//                                   child: Text(
//                                     'الكمية',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(4),
//                                   child: Text(
//                                     'اجمالي السعر',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text(
//                                     'ملاحظة',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 // LayoutBuilder(builder: (contextm, consts) {
//                                 //   print(consts.maxWidth);
//                                 //   return Padding(
//                                 //     padding: const EdgeInsets.all(4),
//                                 //     child: Row(
//                                 //       children: [],),);}),
//                               ],
//                             ),
//                             ..._rows,
//                           ],
//                         ),
//                         SizedBox(height: 16 * multiplier),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               "مدير الادارة: ..................................",
//                               style: TextStyle(
//                                 fontSize: 14 * multiplier,
//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16 * multiplier),
//                         Row(
//                           children: [
//                             Text(
//                               "تم اصدار أمر شراء رقم: ${billModel.supplierModel.id}  بتاريخ: ${dateToString(billModel.createDate, '/')}",
//                               style: TextStyle(
//                                 fontSize: 14 * multiplier,
//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16 * multiplier),
//                         Row(
//                           children: [
//                             Text(
//                               "اسم المورد: ${billModel.supplierModel.name}   -   عنوانه: ${billModel.supplierModel.town}, ${billModel.supplierModel.state}, ${billModel.supplierModel.country}",
//                               style: TextStyle(
//                                 fontSize: 14 * multiplier,
//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16 * multiplier),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               "تاريخ التوريد: ${dateToString(billModel.incomingDate, '/')}",
//                               style: TextStyle(
//                                 fontSize: 14 * multiplier,
//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16 * multiplier),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               "مدير المشتريات: ${'${billModel.userModel.firstname} ${billModel.userModel.lastname}'}",
//                               style: TextStyle(
//                                 fontSize: 12 * multiplier,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Expanded(
//                           child: LayoutBuilder(
//                             builder: (context, consts) {
//                               reminingHeightSpace = consts.maxHeight;
//                               print(reminingHeightSpace);
//                               return const SizedBox();
//                             },
//                           ),
//                         ),
//                         // SizedBox(
//                         //   height: 150,
//                         //   width: 140,
//                         //   child: LayoutBuilder(
//                         //     builder: (context, constraints) {
//                         //       return Column(
//                         //         children: [
//                         //           Text(constraints.maxHeight.toString()),
//                         //           Text(constraints.maxWidth.toString()),
//                         //         ],
//                         //       );
//                         //     },
//                         //   ),
//                         // ),
//                         // Expanded(
//                         //   child: LayoutBuilder(
//                         //     builder: (context, constraints) {
//                         //       return Column(
//                         //         children: [
//                         //           Text(constraints.maxHeight.toString()),
//                         //           Text(constraints.maxWidth.toString()),
//                         //         ],
//                         //       );
//                         //     },
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );

//       // return TestThePain(
//       //   child: wid,
//       // );
//     } catch (E) {
//       print(E);
//       return CircularProgressIndicator();
//     }
//   }
// }

// // class TestThePain extends StatelessWidget {
// //   const TestThePain({Key? key, required this.child}) : super(key: key);
// //   final Widget child;
// //   @override
// //   Widget build(BuildContext context) {
// //     return child;
// //   }
// // }

// class InvoiceBodyUpdater extends updater.Updater {
//   InvoiceBodyUpdater({
//     initialState,
//     bool updateForCurrentEvent = false,
//   }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
// }

// class InvoicePageUpdater extends updater.Updater {
//   InvoicePageUpdater({
//     initialState,
//     bool updateForCurrentEvent = false,
//   }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
// }

// class AppBarUpdater extends updater.Updater {
//   AppBarUpdater({
//     initialState,
//     bool updateForCurrentEvent = false,
//   }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
// }

// class PainterUpdater extends updater.Updater {
//   PainterUpdater({
//     initialState,
//     bool updateForCurrentEvent = false,
//   }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
// }
// // class CustomerInvoiceAppBar extends StatefulWidget {
// //   const CustomerInvoiceAppBar({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   State<CustomerInvoiceAppBar> createState() => _CustomerInvoiceAppBarState();
// // }

// // class _CustomerInvoiceAppBarState extends State<CustomerInvoiceAppBar> {
// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
// //       child: AppBar(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(15),
// //         ),
// //         title: const Text('Costumer Invoice'),
// //         centerTitle: true,
// //         actions: [
// //           MaterialButton(
// //             onPressed: () async {
// //               // print(SystemConfig.invoicesSaveDirectoryPath);
// //               _compeleter = Completer();
// //               _pageWidget = ScreenshotMaker(
// //                 outputFile: File(
// //                   '${SystemConfig.invoicesSaveDirectoryPath}/${DateTime.now().millisecondsSinceEpoch}.png',
// //                 ),
// //                 size: const Size(1600, 2400),
// //                 completer: _compeleter,
// //                 child: _invoiceWidget,
// //               );
// //               InvoicePageUpdater().add(0);
// //               await _compeleter!.future.then((value) {
// //                 // print(value);
// //                 toast(
// //                   'Done Successfully',
// //                 );
// //                 Navigator.pop(context);
// //               }, onError: (e) {
// //                 print(e);
// //                 toast(
// //                   e.toString(),
// //                 );
// //               });
// //               // var imageBytes = await screenShotCont.captureFromWidget(
// //               //   const CustomerInvoiceBody(),
// //               //   // 'H:/Businet_Invoices',
// //               //   pixelRatio: 2.0,
// //               //   context: context,
// //               //   delay: const Duration(seconds: 3),
// //               // );
// //               // await File(
// //               //         'H:/Businet_Invoices/${DateTime.now().millisecondsSinceEpoch}.png')
// //               //     .writeAsBytes(imageBytes);
// //             },
// //             child: const Text('Checkout'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // Row(
// //             children: [
// // Expanded(
// //   flex: 1,
// //   // Invoice First Side
// //   child: Column(
// //     children: [
// //       Container(
// //         // margin: EdgeI
// //         color: Colors.grey[100],
// //         height: 300,
// //         width: 400,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: const [
// //             FlutterLogo(size: 90),
// //           ],
// //         ),
// //       ),
// //       const Spacer(),
// //       const SizedBox(height: 300),
// //       // Bar Code
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Container(
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(10),
// //               color: Colors.black45,
// //             ),
// //             margin: const EdgeInsets.all(16),
// //             height: 150,
// //             width: 150,
// //           ),
// //           Container(
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             margin: const EdgeInsets.all(16),
// //             height: 150,
// //             width: 150,
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: const [
// //                 FlutterLogo(
// //                   size: 50,
// //                   textColor: Colors.yellow,
// //                 ),
// //                 SizedBox(height: 8),
// //                 Text(
// //                   'Besmar',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),
// // ),
// // Expanded(
// //   flex: 1,
// //   // Invoice Second Side
// //   child: Column(
// //     children: [
// //       Container(
// //         color: Colors.grey[100],
// //         height: 300,
// //         width: 400,
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           // mainAxisAlignment: MainAxisAlignment.start,
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Invoice',
// //               style: TextStyle(
// //                 fontSize: 25,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: const [
// //                 Text(
// //                   'Invoice Number:',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //                 Text(
// //                   '12345678',
// //                   style: TextStyle(
// //                     color: Colors.grey,
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 18,
// //                   ),
// //                   // textAlign: TextAlign.left,
// //                 ),
// //               ],
// //             ),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: const [
// //                 Text(
// //                   'Date:',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     // color: Colors.grey,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //                 // SizedBox
// //                 Text(
// //                   '20 Decemper 2022',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     color: Colors.grey,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     ],
// //   ),
// // ),
// // TextField(),
// // Text(
// //   'Invoice Number',
// //   style: TextStyle(
// //       // color: Colors.grey,
// //       ),
// // ),
// // Text(
// //   '12345678',
// //   style: TextStyle(
// //     color: Colors.grey,
// //   ),
// // ),
// //   ],
// // ),

// // class CustomerInvoice extends StatefulWidget {
// //   const CustomerInvoice({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   State<CustomerInvoice> createState() => _CustomerInvoiceState();
// // }

// // class _CustomerInvoiceState extends State<CustomerInvoice> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageWidget = const CustomerInvoiceBody();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // backgroundColor: Colors.grey[100],
// //       body: updater.UpdaterBloc(
// //         updater: InvoicePageUpdater(
// //           initialState: 0,
// //           updateForCurrentEvent: true,
// //         ),
// //         update: (context, state) {
// //           return Column(
// //             // ignore: prefer_const_literals_to_create_immutables
// //             children: [
// //               const SizedBox(
// //                 child: CustomerInvoiceAppBar(),
// //               ),
// //               Expanded(child: _pageWidget!),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
