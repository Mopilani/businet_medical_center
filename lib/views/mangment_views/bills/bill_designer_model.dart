import 'dart:io';

import 'package:businet_medical_center/models/point_of_sale_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/utils/convert_functions.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart' hide convert;
import 'package:pdf/widgets.dart' as pw;

import '../../../models/bill_model.dart';
// import 'package:printing/printing.dart' as printing;

class BillsDesigner {
  static Future<Uint8List> getFor(
    BillModel bill, {
    PdfPageFormat pageFormat = PdfPageFormat.a4,
  }) async {
    late File targetFile;

    final pdf = pw.Document();

    Future<pw.PageTheme> pageTheme() async {
      final arialFont = await rootBundle.load("assets/fonts/ARIAL.TTF");
      final arialFontTTF = pw.Font.ttf(arialFont);

      return pw.PageTheme(
        pageFormat: pageFormat,
        theme: pw.ThemeData.withFont(
          icons: arialFontTTF,
          fontFallback: [pw.Font.ttf(arialFont)],
        ),
      );
    }

    buildPages([pw.Context? context]) {
      return [
        // pw.Text(
        //   convert("").split(' ').reversed.join(' '),
        //   style: pw.TextStyle(
        //     fontSize: 12,
        //     fontWeight: pw.FontWeight.bold,
        //   ),
        // ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              convert(PointOfSaleModel.stored!.placeName!)
                  .split(' ')
                  .reversed
                  .join(' '),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              convert('طلب شراء').split(' ').reversed.join(' '),
              style: pw.TextStyle(
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              convert("تحريرا في 20 ... / ... / ... ")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              convert("الجهة الطالبة: .......................")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              convert("المطلوب شراء الاصناف المبينة أدناه على أن يتم التوريد خلال: ..............")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Table(
          columnWidths: {
            0: const pw.IntrinsicColumnWidth(flex: 4),
            1: const pw.IntrinsicColumnWidth(flex: 3),
            2: const pw.IntrinsicColumnWidth(flex: 2),
            3: const pw.IntrinsicColumnWidth(flex: 3),
            4: const pw.IntrinsicColumnWidth(flex: 2),
          },
          border: pw.TableBorder.symmetric(
            inside: const pw.BorderSide(width: 1),
            outside: const pw.BorderSide(width: 1),
          ),
          children: [
            //   child: ListView.builder(
            //     itemCount: dnya.length,
            //     itemBuilder:
            ...() {
              var rows = [];
              for (var index = 0; index < bill.billEntries.length; index++) {
                // print('//////////////');
                // print(bill.billEntries);
                var enteries = bill.billEntries.values.toList();
                rows.add(
                  pw.TableRow(
                    // verticalAlignment: pw.TableCellVerticalAlignment.r,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        // child: pw.Image(
                        //   pw.ImageImage(
                        //     Image.,
                        //   ),
                        // ),
                        // pw.Wrap(
                        //   runAlignment: pw.WrapAlignment.end,
                        //   // verticalDirection: pw.VerticalDirection.down,
                        //   crossAxisAlignment: pw.WrapCrossAlignment.end,
                        //   alignment: pw.WrapAlignment.end,
                        //   children: enteries[index]
                        //       .note
                        //       .split(' ')
                        //       // .reversed
                        //       .map((e) => pw.Text('${convert(e)} '))
                        //       .toList(),
                        // ),
                        //  pw.Text(
                        //   () {
                        //     var text = '';
                        //     var segs = (enteries[index].note).split(' ');
                        //     var newSegs = <String>[];
                        //     for (var seg in segs) {
                        //       newSegs.add(
                        //           (convert(seg).split('').reversed.join()));
                        //     }
                        //     text = newSegs.join(' ');
                        //     return (text);
                        //   }(),
                        //   // softWrap: false,convert
                        //   textDirection: pw.TextDirection.rtl,
                        //   textAlign: pw.TextAlign.right,
                        //   style: const pw.TextStyle(
                        //     fontSize: 14,
                        //     // renderingMode: PdfTextRenderingMode.fill,
                        //   ),
                        // ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          (enteries[index].total).toString(),
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          enteries[index].quantity.toString(),
                          textAlign: pw.TextAlign.right,
                          // style: const TextStyle(
                          //   fontSize: 18,
                          // ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          enteries[index].skuModel.costPrice.toString(),
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          convert(enteries[index].skuModel.description!)
                              .split(' ')
                              .reversed
                              .join(' '),
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return rows;
            }(),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("مدير الادارة").split(' ').reversed.join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("...............................")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("تم اصدار أمر شراء رقم .......  بتاريخ .... / .... / .... 20")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("اسم المورد: .............. عنوانه: ....................")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("تاريخ التوريد: .... / .... / .... 20")
                  .split(' ')
                  .reversed
                  .join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("").split(' ').reversed.join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert("مدير المشتريات").split(' ').reversed.join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(width: 72),
            pw.Text(
              convert(".......................").split(' ').reversed.join(' '),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        // pw.SizedBox(height: 8),
        // pw.Text(
        //   convert("sales_report".tr()).split(' ').reversed.join(' '),
        // ),
        pw.Divider(),
        // pw.SizedBox(height: 8),
      ]; // Center
    }

    if (pageFormat == PdfPageFormat.a3 || pageFormat == PdfPageFormat.a4) {
      pdf.addPage(
        pw.MultiPage(
          pageTheme: await pageTheme(),
          build: buildPages,
        ),
      ); // Page
    } else {
      pdf.addPage(
        pw.Page(
          pageTheme: await pageTheme(),
          build: (context) => pw.Column(
            children: buildPages(context),
          ),
        ),
      ); // Page

    }

    // pdf.document.page(0);

    var rawPDF = await pdf.save();
    return rawPDF;
  }

  static Future<File?> _actionsReport() async {
    // bool accordingToStock = false;
    // bool accordingToShift = false;
    // bool accordingToCategory = false;
    // bool accordingToSales = false;
    // bool accordingToPaymentMethod = false;
    // bool accordingToReceiptState = false;
    // bool accordingToSubCategory = false;
    // bool accordingToSupplier = false;
    // print('Filters: $filters');

    PointOfSaleModel posData = PointOfSaleModel.stored!;
    ProcessesModel processesModel = ProcessesModel.stored!;

    // if (filters.containsKey('accordingToStock')) {
    //   accordingToStock = true;
    // }
    // if (filters.containsKey('accordingToShift')) {
    //   accordingToShift = true;
    // }
    // if (filters.containsKey('accordingToSales')) {
    //   accordingToShift = true;
    // }
    // if (filters.containsKey('accordingToCategory')) {
    //   accordingToCategory = true;
    // }
    // if (filters.containsKey('accordingToPaymentMethod')) {
    //   accordingToPaymentMethod = true;
    // }
    // if (filters.containsKey('accordingToReceiptState')) {
    //   accordingToReceiptState = true;
    // }
    // if (filters.containsKey('accordingToSubCategory')) {
    //   accordingToSubCategory = true;
    // }
    // if (filters.containsKey('accordingToSupplier')) {
    //   accordingToSupplier = true;
    // }
    // var actionsStream = ActionModel.stream();

    // final List<PaymentMethodModel> _registeredPaymentMethods = [];
    // final Map<int, List<ReceiptModel>> foundReceiptsAccordingPaymentMethods = {
    //   // paymehtMethodName : <SKUModel>[]
    // };
    // final Map<String, List<ReceiptPaymentMethodEntryModel>>
    //     foundPaymentMethodsAccordingPaymentMethods = {
    //   // paymehtMethodName : <SKUModel>[]
    // };
    // final Map<String, dynamic> accordingToReceiptsPaymentMethodsCalcs = {
    //   // 'methodName': total, payed,
    // };
    // final List<CatgoryModel> _registeredCatgs = [];
    // final Map<String, List<SKUModel>> categsProductsFound = {
    //   // catgeName : <SKUModel>[]
    // };
    // final List<SupplierModel> _registeredSuppliers = [];
    // final Map<String, List<SKUModel>> suppliersProductsFound = {
    //   // supplierName : <SKUModel>[]
    // };
    // final List<StockModel> _registeredStocks = [];
    // final Map<String, List<SKUModel>> stocksProductsFound = {
    //   // stockName : <SKUModel>[]
    // };
    // final List<ReceiptState> _registeredReceiptState = [
    //   ReceiptState.payed,
    //   ReceiptState.onWait,
    //   ReceiptState.canceled,
    //   ReceiptState.returned,
    //   ReceiptState.partialPay,
    // ];
    // final Map<String, List<SKUModel>> stocksReceiptStateFound = {
    //   // receiptState : <SKUModel>[]
    // };
    // final List<int> _registeredShifts = [];
    // final Map<int, List<SKUModel>> shiftsFound = {
    //   // receiptState : <SKUModel>[]
    // };
    // final List<ReceiptModel> billsFound = [];
    // double totalPayments = 0.0;

    // final List<ActionDataModel> accordingToSigns = [
    //   // receiptState : <SKUModel>[]
    // ];

    late File targetFile;
    bool notDone = true;
    return null;

    // actionsStream.listen((action) {
    //   print(action);
    //   if (details) {
    //     accordingToSigns.add(action);
    //   }
    //   if (accordingToPaymentMethod) {
    //     if (filters['accordingToPaymentMethod'] != null) {
    //       // var method =
    //       //     (filters['accordingToPaymentMethod'] as PaymentMethodModel);
    //       // for (var pMethod in receipt.receiptPaymentMethods) {
    //       //   if (method.id == pMethod.id) {
    //       //     if (foundReceiptsAccordingPaymentMethods[method.id] == null) {
    //       //       foundReceiptsAccordingPaymentMethods.addAll({
    //       //         method.id: [receipt]
    //       //       });
    //       //     } else {
    //       //       foundReceiptsAccordingPaymentMethods[method.id]!.add(receipt);
    //       //     }
    //       //   }
    //     }
    //   }
    //   //  else {
    //   //   for (var pMethod in receipt.receiptPaymentMethods) {
    //   //     for (var method in _registeredPaymentMethods) {
    //   //       if (method.id == pMethod.paymentMethod.id) {
    //   //         if (foundReceiptsAccordingPaymentMethods[method.id] == null) {
    //   //           foundReceiptsAccordingPaymentMethods.addAll({
    //   //             method.id: [receipt]
    //   //           });
    //   //           foundPaymentMethodsAccordingPaymentMethods.addAll({
    //   //             method.methodName: [pMethod]
    //   //           });
    //   //           // print('Good: ${event.receiptPaymentMethods}');
    //   //           // print('Good: ${foundPaymentMethodsAccordingPaymentMethods}');
    //   //         } else {
    //   //           foundReceiptsAccordingPaymentMethods[method.id]!.add(receipt);
    //   //           foundPaymentMethodsAccordingPaymentMethods[method.methodName]!
    //   //               .add(pMethod);
    //   //         }
    //   //       }
    //   //     }
    //   //   }
    //   // }
    //   // }
    //   // if (accordingToShift) {
    //   //   if (receipt.shiftNumber == filters['accordingToShift']) {}
    //   // for (var entry in foundReceiptsAccordingPaymentMethods.entries) {
    //   //   for (var element in _registeredPaymentMethods) {
    //   //     if (entry.key == element.id) {
    //   //       if (accordingToReceiptsPaymentMethodsCalcs[element.methodName] ==
    //   //           null) {
    //   //         accordingToReceiptsPaymentMethodsCalcs
    //   //             .addAll({element.methodName: 0.0});
    //   //       }
    //   //       // print(accordingToReceiptsPaymentMethodsCalcs);
    //   //       double total = 0.0;
    //   //       for (var value in entry.value) {
    //   //         // if(value.payed)
    //   //         total += value.total;
    //   //       }
    //   //       // print(total);
    //   //       accordingToReceiptsPaymentMethodsCalcs[element.methodName] +=
    //   //           total;
    //   //     }
    //   //   }
    //   // }
    //   // }
    //   // if (accordingToCategory) {
    //   //   for (var entry in receipt.receiptEntries.entries) {
    //   //     SKUModel.get(int.parse(entry.key));

    //   //     entry.value.total;
    //   //     entry.value.skuModel;
    //   //     entry.value.quantity;
    //   //   }
    //   // }
    //   // if (details) {
    //   //   for (var entry in receipt.receiptEntries.entries) {
    //   //     // SKUModel.get(int.parse(entry.key));
    //   //     if (accordingToSalesProductsFound[entry.value.skuModel.description] ==
    //   //         null) {
    //   //       accordingToSalesProductsFound[entry.value.skuModel.description!] = [
    //   //         entry.value.total,
    //   //         entry.value.quantity,
    //   //       ];
    //   //     } else {
    //   //       accordingToSalesProductsFound[entry.value.skuModel.description!]![
    //   //           0] += entry.value.total;
    //   //       accordingToSalesProductsFound[entry.value.skuModel.description!]![
    //   //           1] += entry.value.quantity;
    //   //     }
    //   //     // print(accordingToSalesProductsFound);
    //   //   }
    //   // }
    // }, onDone: () async {
    //   // print(accordingToSalesProductsFound);

    //   // for (var entry in foundPaymentMethodsAccordingPaymentMethods.entries) {
    //   //   // for (var element in _registeredPaymentMethods) {
    //   //   // if (entry.value == element.id) {

    //   //   if (accordingToReceiptsPaymentMethodsCalcs[entry.key] == null) {
    //   //     accordingToReceiptsPaymentMethodsCalcs.addAll({entry.key: 0.0});
    //   //   }
    //   //   double total = 0.0;
    //   //   for (var element in entry.value) {
    //   //     total += element.value;
    //   //     // print(total);
    //   //   }
    //   //   accordingToReceiptsPaymentMethodsCalcs[entry.key] += total;
    //   //   totalPayments += total;
    //   //   total = 0.0;
    //   // }

    //   final pdf = pw.Document();

    //   Future<pw.PageTheme> pageTheme() async {
    //     final arialFont = await rootBundle.load("assets/fonts/ARIAL.TTF");
    //     final arialFontTTF = pw.Font.ttf(arialFont);

    //     return pw.PageTheme(
    //       pageFormat: pageFormat,
    //       theme: pw.ThemeData.withFont(
    //         icons: arialFontTTF,
    //         fontFallback: [pw.Font.ttf(arialFont)],
    //       ),
    //     );
    //   }

    //   buildPages([pw.Context? context]) {
    //     return [
    //       pw.Column(
    //         mainAxisAlignment: pw.MainAxisAlignment.start,
    //         children: [
    //           // pw.Image(
    //           //   pw.RawImage(bytes: pngBytes, width: 100, height: 40),
    //           // ),
    //           pw.Text(convert("تقرير الانشطة").split(' ').reversed.join(' '),
    //               style: pw.TextStyle(
    //                 fontSize: 12,
    //                 fontWeight: pw.FontWeight.bold,
    //               )),
    //           pw.SizedBox(height: 16),
    //           pw.Row(
    //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //               children: [
    //                 pw.Text(
    //                     convert(PointOfSaleModel.stored!.placeName!)
    //                         .split(' ')
    //                         .reversed
    //                         .join(' '),
    //                     style: pw.TextStyle(
    //                       fontSize: 14,
    //                       fontWeight: pw.FontWeight.bold,
    //                     )),
    //                 pw.Text(
    //                   convert('${"dayDate".tr()}: ${(processesModel.businessDayString())} ')
    //                       .split(' ')
    //                       .reversed
    //                       .join(' '),
    //                 ),
    //               ]),
    //           pw.SizedBox(height: 8),
    //           // pw.Text(
    //           //   convert("sales_report".tr()).split(' ').reversed.join(' '),
    //           // ),
    //           pw.Divider(),
    //           pw.SizedBox(height: 8),
    //           () {
    //             if (true) {
    //               double totalValue = 0.0;
    //               double totalPayouts = 0.0;
    //               int itemIndex = 0;
    //               return pw.Column(
    //                 children: [
    //                   // pw.SizedBox(height: 8),
    //                   // pw.Text(
    //                   //   convert('تقرير المبيعات').split(' ').reversed.join(' '),
    //                   // ),
    //                   // pw.SizedBox(height: 8),

    //                   // pw.Row(
    //                   //   mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    //                   //   children: [
    //                   //     pw.Text(
    //                   //       convert('الاجمالي'),
    //                   //     ),
    //                   //     pw.VerticalDivider(),
    //                   //     pw.Text(
    //                   //       convert('الكمية'),
    //                   //     ),
    //                   //     pw.VerticalDivider(),
    //                   //     pw.Text(
    //                   //       convert('الوصف'),
    //                   //     ),
    //                   //   ],
    //                   // ),
    //                   // pw.SizedBox(height: 4),
    //                   pw.Row(
    //                     mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    //                     children: [
    //                       pw.Text(convert('معلومات اضافية'),
    //                           style: pw.TextStyle(
    //                             fontSize: 12,
    //                             fontWeight: pw.FontWeight.bold,
    //                           )),
    //                       pw.VerticalDivider(),
    //                       pw.Text(convert('الحدث'),
    //                           style: pw.TextStyle(
    //                             fontSize: 12,
    //                             fontWeight: pw.FontWeight.bold,
    //                           )),
    //                       pw.VerticalDivider(),
    //                       pw.Text(convert('المستخدم'),
    //                           style: pw.TextStyle(
    //                             fontSize: 12,
    //                             fontWeight: pw.FontWeight.bold,
    //                           )),
    //                     ],
    //                   ),
    //                   ...accordingToSigns.map<pw.Widget>((action) {
    //                     itemIndex++;
    //                     return pw.Column(
    //                         // mainAxisAlignment: pw.MainAxisAlignment.start,
    //                         children: () {
    //                       return [
    //                         pw.Row(
    //                             mainAxisAlignment: pw.MainAxisAlignment.end,
    //                             children: [
    //                               pw.Text(
    //                                 convert(ActionDataModel
    //                                         .registeredActions[action.action])
    //                                     .split(' ')
    //                                     .reversed
    //                                     .join(' '),
    //                               ),
    //                               pw.VerticalDivider(),
    //                               pw.Text(
    //                                 convert(action.lastname.toString()),
    //                               ),
    //                               pw.SizedBox(width: 4),
    //                               pw.Text(
    //                                 convert(action.firstname.toString()),
    //                               ),
    //                             ]),
    //                         () {
    //                           if (action.action ==
    //                                   ActionDataModel.createdAReceipt ||
    //                               action.action ==
    //                                   ActionDataModel.updatedAReceipt ||
    //                               action.action ==
    //                                   ActionDataModel.returnedAReceipt ||
    //                               action.action ==
    //                                   ActionDataModel.canceledAReceipt) {
    //                             return pw.Text(
    //                               '${convert(action.metaData!['rcptno'].toString()).split(' ').reversed.join(' ')} .$itemIndex',
    //                             );
    //                           } else if (action.action ==
    //                                   ActionDataModel.createdABill ||
    //                               action.action ==
    //                                   ActionDataModel.canceledABill ||
    //                               action.action ==
    //                                   ActionDataModel.returnedABill ||
    //                               action.action ==
    //                                   ActionDataModel.updatedABill ||
    //                               action.action ==
    //                                   ActionDataModel.printedABill) {
    //                             return pw.Text(
    //                               '${convert(action.metaData!['blno'].toString()).split(' ').reversed.join(' ')} .$itemIndex',
    //                             );
    //                           } else if (action.action ==
    //                                   ActionDataModel.signin ||
    //                               action.action == ActionDataModel.signout) {
    //                             return pw.SizedBox();
    //                           } else {
    //                             return pw.Text(
    //                               '${convert(action.metaData.toString()).split(' ').reversed.join(' ')} .$itemIndex',
    //                             );
    //                           }
    //                         }()
    //                       ];
    //                     }());
    //                   }).toList(),
    //                   pw.SizedBox(height: 4),
    //                 ],
    //               );
    //             } else {
    //               return pw.SizedBox();
    //             }
    //           }(),
    //           // pw.Row(
    //           //   children: [
    //           //     pw.Text(
    //           //       convert('الرقم'),
    //           //     ),
    //           //     pw.VerticalDivider(),
    //           //     pw.Text(
    //           //       convert('المدفوع'),
    //           //     ),
    //           //     pw.VerticalDivider(),
    //           //     pw.Text(
    //           //       convert('المجموع'),
    //           //     ),
    //           //     pw.VerticalDivider(),
    //           //     pw.Text(
    //           //       convert('حالة الايصال'),
    //           //     ),
    //           //   ],
    //           // ),

    //           // pw.Column(children: () {
    //           // if (accordingToPaymentMethod) {
    //           //   return entry.value.map((entry) {
    //           //     return pw.Row(
    //           //       children: [
    //           //         // pw.Text(
    //           //         //   convert(entry.id.toString()),
    //           //         // ),
    //           //         // pw.VerticalDivider(),
    //           //         // pw.Text(
    //           //         //   convert(entry.payed.toString()),
    //           //         // ),
    //           //         pw.VerticalDivider(),
    //           //         pw.Text(
    //           //           convert(entry.toString()),
    //           //         ),
    //           //         pw.VerticalDivider(),
    //           //         pw.Text(
    //           //           convert(entry.receiptState.name),
    //           //         ),
    //           //       ],
    //           //     );
    //           //   }).toList();
    //           // } else {
    //           //   return [pw.SizedBox()];
    //           // }
    //           // }()
    //           // ),
    //           // return foundReceiptsAccordingPaymentMethods.entries
    //           //     .map((entry) {
    //           //   // print('accordingToPaymentMethod');
    //           //   return pw.Column(
    //           //     children: [
    //           //       pw.SizedBox(height: 8),
    //           //       pw.Text(
    //           //         convert(() {
    //           //           for (var element in _registeredPaymentMethods) {
    //           //             if (entry.key == element.id) {
    //           //               return element.methodName.toString();
    //           //             }
    //           //           }
    //           //           return 'غير معروف';
    //           //         }()),
    //           //       ),
    //           //       pw.SizedBox(height: 4),
    //           //       pw.Column(children: () {
    //           //         if (accordingToPaymentMethod) {
    //           //           return entry.value.map((entry) {
    //           //             return pw.Row(
    //           //               children: [
    //           //                 pw.Text(
    //           //                   convert(entry.id.toString()),
    //           //                 ),
    //           //                 pw.VerticalDivider(),
    //           //                 pw.Text(
    //           //                   convert(entry.payed.toString()),
    //           //                 ),
    //           //                 pw.VerticalDivider(),
    //           //                 pw.Text(
    //           //                   convert(entry.total.toString()),
    //           //                 ),
    //           //                 pw.VerticalDivider(),
    //           //                 pw.Text(
    //           //                   convert(entry.receiptState.name),
    //           //                 ),
    //           //               ],
    //           //             );
    //           //           }).toList();
    //           //         } else {
    //           //           return [pw.SizedBox()];
    //           //         }
    //           //       }()),
    //           //     ],
    //           //   );
    //           // }).toList();

    //           // pw.Column(children: () {
    //           //   if (accordingToReceiptState) {
    //           //     return _registeredReceiptState.map((e) {
    //           //       return pw.Text(convert(e.name));
    //           //     }).toList();
    //           //   } else {
    //           //     return [pw.SizedBox()];
    //           //   }
    //           // }()),
    //           // pw.Column(children: () {
    //           //   if (accordingToSubCategory) {
    //           //     return _registeredSubCatgs.map((e) {
    //           //       return pw.Text(convert(e.subcatgoryName));
    //           //     }).toList();
    //           //   } else {
    //           //     return [pw.SizedBox()];
    //           //   }
    //           // }()),
    //           // pw.Column(children: () {
    //           //   if (accordingToSupplier) {
    //           //     return _registeredSuppliers.map((e) {
    //           //       return pw.Text(convert(e.name));
    //           //     }).toList();
    //           //   } else {
    //           //     return [pw.SizedBox()];
    //           //   }
    //           // }()),
    //           pw.SizedBox(height: 8),
    //           pw.Divider(),
    //           // pw.Text(
    //           //   "$_registeredSaleUnits",
    //           // ),
    //           // pw.Text(
    //           //   "$_registeredSaleUnits",
    //           // ),
    //         ],
    //       ),
    //       () {
    //         if (accordingToPaymentMethod) {
    //           int itemIndex = 0;
    //           return pw.Column(children: [
    //             pw.SizedBox(height: 16),
    //             pw.Text(
    //               convert('تقرير واردات الحسابات')
    //                   .split(' ')
    //                   .reversed
    //                   .join(' '),
    //             ),
    //             pw.SizedBox(height: 8),
    //             // ...() {
    //             //   return accordingToReceiptsPaymentMethodsCalcs.entries.map(
    //             //     (entry) {
    //             //       itemIndex++;
    //             //       return pw.Row(
    //             //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //             //         children: [
    //             //           // pw.SizedBox(height: 8),
    //             //           pw.Text(
    //             //             convert(entry.value.toString()),
    //             //           ),
    //             //           pw.SizedBox(height: 4),
    //             //           pw.Text(
    //             //             convert('${entry.key} .$itemIndex'),
    //             //           ),
    //             //         ],
    //             //       );
    //             //     },
    //             //   ).toList();
    //             // }(),
    //             // pw.Text(
    //             //   '$totalPayments :${convert('الاجمالي')}',
    //             //   style: pw.TextStyle(
    //             //     fontSize: 18,
    //             //     fontWeight: pw.FontWeight.bold,
    //             //   ),
    //             // ),
    //             pw.SizedBox(height: 16),
    //           ]);
    //         } else {
    //           return pw.SizedBox();
    //         }
    //       }(),
    //     ]; // Center
    //   }

    //   if (pageFormat == PdfPageFormat.a3 || pageFormat == PdfPageFormat.a4) {
    //     pdf.addPage(
    //       pw.MultiPage(
    //         pageTheme: await pageTheme(),
    //         build: buildPages,
    //       ),
    //     ); // Page
    //   } else {
    //     pdf.addPage(
    //       pw.Page(
    //         pageTheme: await pageTheme(),
    //         build: (context) => pw.Column(
    //           children: buildPages(context),
    //         ),
    //       ),
    //     ); // Page

    //   }

    //   // pdf.document.page(0);

    //   var rawPDF = await pdf.save();
    //   // var r = await printing.Printing.directPrintPdf(
    //   //   printer: const printing.Printer(url: '', name: ''),
    //   //   onLayout: (format) => rawPDF,
    //   // );
    //   // print('==================');
    //   // print(r);
    //   Directory appDocDir = await getApplicationDocumentsDirectory();
    //   targetFile = File(
    //       'C:/Users/Mopilani/Documents/Acan/winprint_location/SalesReport.pdf');
    //   targetFile = await targetFile.writeAsBytes(rawPDF);
    //   print(targetFile.path);
    //   notDone = false;
    // });
    // while (notDone) {
    //   await Future.delayed(const Duration(milliseconds: 32));
    //   // print('Looping');
    // }
    // print('Returned TheFile');
    // return targetFile;
  }
}
