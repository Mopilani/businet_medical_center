
import 'package:businet_medical_center/models/receipt_and_bill_payment_method_entry_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:flutter/material.dart';

import 'flying_widgets.dart';

class Wid5 extends StatelessWidget {
  const Wid5({
    Key? key,
    required this.receiptPaymentMethod,
    required this.index,
  }) : super(key: key);
  final ReceiptPaymentMethodEntryModel receiptPaymentMethod;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {},
      onLongPress: () {
        payed -= receiptPaymentMethod.value;
        wanted += receiptPaymentMethod.value;
        if (receiptPaymentMethod.paymentMethod.postPayMethod) {
          realPayed = payed - debitWanted;
          debitWanted -= receiptPaymentMethod.value;
        } else {
          realPayed = payed - debitWanted;
        }
        receiptPaymentMethods.removeAt(index);
        ReceiptUpdater().add(0);
      },
      borderRadius: BorderRadius.circular(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${receiptPaymentMethod.paymentMethod.methodName} ${receiptPaymentMethod.paymentMethod.currency}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 50),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        receiptPaymentMethod.value.toString(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       const VerticalDivider(),
          //       InkWell(
          //         borderRadius: BorderRadius.circular(15),
          //         onTap: () {},
          //         child: ConstrainedBox(
          //           constraints: const BoxConstraints(minWidth: 30),
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 4, right: 4),
          //             child: Text(
          //               receiptEntry.quantity.toString(),
          //               textAlign: TextAlign.start,
          //               style: const TextStyle(
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       const VerticalDivider(),
          //       Text(
          //         receiptEntry.total.toString(),
          //         textAlign: TextAlign.start,
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}