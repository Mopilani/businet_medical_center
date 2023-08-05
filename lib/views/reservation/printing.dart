
  import 'dart:io';

import 'package:businet_medical_center/models/system_config.dart';
import 'package:pdfx/pdfx.dart';

/// 
Future<void> printDocument(String documentPath) async {
    String path = documentPath;
    String fileExt = path.split('.').last;
    if (fileExt == 'pdf') {
      // From file (Android, Ios, MacOs)
      final document = await PdfDocument.openFile(path);
      final page = await document.getPage(1); // Starts from 1

      final pageImage = await page.render(
        // rendered image width resolution, required
        width: page.width * 2,
        // rendered image height resolution, required
        height: page.height * 2,

        // Rendered image compression format, also can be PNG, WEBP*
        // Optional, default: PdfPageImageFormat.PNG
        // Web not supported
        format: PdfPageImageFormat.jpeg,
        backgroundColor: '#ffffff',
      );

      path = '$path.jpg';
      await File(path).writeAsBytes(pageImage!.bytes);
      await document.close();
    }

    try {
      final process = await Process.run('printing/raw_print_helper.exe', [
        'print',
        SystemConfig().printer,
        path,
      ]);
      print(process.stdout);
      print(process.stderr.runtimeType);
    } catch (e) {
      print(e);
    }

    // ViewWidgetUpdater().add('');
  }