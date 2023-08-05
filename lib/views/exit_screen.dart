import 'dart:io';

import 'package:flutter/material.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({Key? key}) : super(key: key);

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'هل تنوي فعلا تسجيل الخروج واغلاق البرنامج؟',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 80,
                child: MaterialButton(
                  color: Colors.red,
                  child: const Text('خروج'),
                  onPressed: () {
                    exit(0);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 80,
                child: MaterialButton(
                  child: const Text('رجوع'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
