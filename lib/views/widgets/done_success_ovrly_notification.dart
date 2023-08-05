import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void doneSuccessfulyOverLayNotification() {
  showSimpleNotification(
    const Text(
      'تم بنجاح',
      style: TextStyle(fontSize: 20),
    ),
    position: NotificationPosition.bottom,
  );
}
