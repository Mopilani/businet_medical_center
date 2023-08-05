import 'payment_method_model.dart';

class ReceiptPaymentMethodEntryModel {
  ReceiptPaymentMethodEntryModel(
    this.id, {
    required this.value,
    required this.paymentMethod,
    this.time,
  }) {
    time = DateTime.now();
  }

  int id;
  PaymentMethodModel paymentMethod;
  double value;
  late DateTime? time;

  Map<String, dynamic> toMap() => {
        'id': id,
        'paymentMethod': paymentMethod.toMap(),
        'value': value,
        'time': time,
      };

  static ReceiptPaymentMethodEntryModel fromMap(Map<String, dynamic> data) {
    return ReceiptPaymentMethodEntryModel(
      data['id'],
      paymentMethod: PaymentMethodModel.fromMap(data['paymentMethod']),
      value: data['value'],
      time: data['time'],
    );
  }
}

class BillPaymentMethodEntryModel {
  BillPaymentMethodEntryModel(
    this.id, {
    required this.value,
    required this.paymentMethod,
    this.time,
  }) {
    time = DateTime.now();
  }

  int id;
  PaymentMethodModel paymentMethod;
  double value;
  late DateTime? time;

  Map<String, dynamic> toMap() => {
        'id': id,
        'paymentMethod': paymentMethod.toMap(),
        'value': value,
        'time': time,
      };

  static BillPaymentMethodEntryModel fromMap(Map<String, dynamic> data) {
    return BillPaymentMethodEntryModel(
      data['id'],
      paymentMethod: PaymentMethodModel.fromMap(data['paymentMethod']),
      value: data['value'],
      time: data['time'],
    );
  }
}
