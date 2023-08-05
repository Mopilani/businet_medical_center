import 'package:flutter/material.dart';

class CostumerPostpayView extends StatefulWidget {
  const CostumerPostpayView({
    Key? key,
  }) : super(key: key);

  @override
  State<CostumerPostpayView> createState() => _CostumerPostpayViewState();
}

class _CostumerPostpayViewState extends State<CostumerPostpayView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {},
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
