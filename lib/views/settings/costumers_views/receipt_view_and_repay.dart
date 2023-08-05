import 'package:businet_medical_center/models/receipt_model.dart';
import 'package:flutter/material.dart';

class ReceiptViewAndRepay extends StatefulWidget {
  const ReceiptViewAndRepay({
    Key? key,
    required this.receipt,
  }) : super(key: key);
  final ReceiptModel receipt;

  @override
  State<ReceiptViewAndRepay> createState() => _ReceiptViewAndRepayState();
}

class _ReceiptViewAndRepayState extends State<ReceiptViewAndRepay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض الايصال ومراجعة الدفعيات - ${widget.receipt.id}'),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                color: () {
                  switch (widget.receipt.receiptState) {
                    case ReceiptState.returned:
                      return Colors.orange;
                    case ReceiptState.onWait:
                      return Colors.yellow;
                    case ReceiptState.canceled:
                      return Colors.grey;
                    case ReceiptState.payed:
                      return Colors.green;
                    case ReceiptState.partialPay:
                      return Colors.grey;
                  }
                }(),
              ),
              const SizedBox(width: 8),
              Text(
                receiptStatesTranslations[widget.receipt.receiptState]!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'المبيعات',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Table(
                border: TableBorder.all(
                  color: Colors.white,
                ),
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('الوصف'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('السعر'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('الكمية'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('الاجمالي'),
                      ),
                    ],
                  ),
                  ...widget.receipt.receiptEntries.entries
                      .map<TableRow>((entry) {
                    var value = entry.value;
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${value.skuModel.description}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${value.skuModel.salePrice}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${value.quantity}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${value.total}'),
                        ),
                      ],
                    );
                    // return Container();
                  }).toList(),
                  TableRow(
                    children: [
                      const Text(''),
                      const Text(''),
                      const Text(''),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${widget.receipt.total}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'المدفوعات',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Table(
                border: TableBorder.all(
                  color: Colors.white,
                ),
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('الرقم'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('طريقة الدفع'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('القيمة'),
                      ),
                    ],
                  ),
                  ...widget.receipt.receiptPaymentMethods
                      .map<TableRow>((entry) {
                    var value = entry;
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${value.id}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              '${value.paymentMethod.methodName} ${value.paymentMethod.currency}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${value.value}'),
                        ),
                      ],
                    );
                    // return Container();
                  }).toList(),
                  TableRow(
                    children: [
                      const Text(''),
                      Text(
                        'الاجل المتفق: ${widget.receipt.debitWanted}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${widget.receipt.total}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      
                    },
                    child: const Text('تحصيل الدفع'),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: const Text('تم'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
