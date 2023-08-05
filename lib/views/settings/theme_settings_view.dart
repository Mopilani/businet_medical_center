
import 'package:businet_medical_center/main.dart';
import 'package:businet_medical_center/models/system_config.dart';
import 'package:flutter/material.dart';

class ThemeSettingsView extends StatefulWidget {
  const ThemeSettingsView({Key? key}) : super(key: key);

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();
}

class _ThemeSettingsViewState extends State<ThemeSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اعدادات ال'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Light'),
            onTap: () {
              ThemeUpdater().add(ThemeData.light());
              SystemConfig().theme = 'light';
            },
          ),
          ListTile(
            title: const Text('Dark'),
            onTap: () {
              ThemeUpdater().add(ThemeData.dark());
              SystemConfig().theme = 'dark';
            },
          ),
        ],
      ),
    );
  }
}
