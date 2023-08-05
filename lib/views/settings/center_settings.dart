import 'package:businet_medical_center/views/widgets/2_tabs_bar.dart';
import 'package:flutter/material.dart';

class CenterSettings extends StatefulWidget {
  const CenterSettings({Key? key}) : super(key: key);

  @override
  State<CenterSettings> createState() => _CenterSettingsState();
}

class _CenterSettingsState extends State<CenterSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات المركز'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            tapBarWidget('', ''),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
