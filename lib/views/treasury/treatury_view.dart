import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../widgets/datetime_picker.dart';

class TreasuryView extends StatefulWidget {
  const TreasuryView({Key? key}) : super(key: key);

  @override
  State<TreasuryView> createState() => _TreasuryViewState();
}

class _TreasuryViewState extends State<TreasuryView> {
  TextEditingController fromDateTimeController = TextEditingController();
  TextEditingController toDateTimeController = TextEditingController();
  bool geted = true;
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخزينة'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateTimePicker(
                  controller: fromDateTimeController,
                  onChanged: (text) {
                    geted = false;
                    setState(() {});
                  },
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2100),
                ),
              ),
              Expanded(
                child: DateTimePicker(
                  controller: toDateTimeController,
                  onChanged: (text) {
                    geted = false;
                    setState(() {});
                  },
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2100),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Expanded(
                child: Text('التاريخ'),
              ),
              Expanded(
                child: Text('الوقت'),
              ),
              Expanded(
                child: Text('المستخدم'),
              ),
              Expanded(
                child: Text('العملية'),
              ),
              Expanded(
                child: Text('توريد'),
              ),
              Expanded(
                child: Text('صرف'),
              ),
              Expanded(
                child: Text('البيان'),
              ),
            ],
          ),
          StreamBuilder(
            stream: TransactionModel.stream(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text('Error: ${snapshot.error}',),);
              }
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  TransactionModel model = transactions[index];
                  return Row(
                    children: [
                      Expanded(
                        child: Text(dateToString(model.time)),
                      ),
                      Expanded(
                        child: Text(timeToString(model.time)),
                      ),
                      Expanded(
                        child: Text(model.user.firstname + model.user.lastname),
                      ),
                      Expanded(
                        child: Text(model.type.name),
                      ),
                      Expanded(
                        child: Text(model.value.toString()),
                      ),
                      Expanded(
                        child: Text(model.value.toString()),
                      ),
                      Expanded(
                        child: Text(model.statement),
                      ),
                    ],
                  );
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
