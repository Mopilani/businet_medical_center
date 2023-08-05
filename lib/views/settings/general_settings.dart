import 'dart:io';

import 'package:businet_medical_center/models/system_config.dart';
import 'package:businet_medical_center/utils/check_funcs.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import '/views/settings/database_settings.dart';

class WindowsPrinting {
  static Future<String?> getAvailablePrintersNames() async {
    try {
      final process = await Process.run('printing/raw_print_helper.exe', [
        'showprinters',
      ]);
      return process.stdout;
    } catch (e) {
      // print(e);
      return null;
    }
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  List<String> panamas = []; // Printers List
  List<String> pageRoutingTypes = [
    'CupertinoPageRoute',
    'MaterialPageRoute',
  ];

  @override
  void initState() {
    super.initState();
  }

  // printerChoosDialog() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Material(
  //         color: Colors.transparent,
  //         child: GestureDetector(
  //           onTap: () => Navigator.pop(context),
  //           child: Container(
  //             alignment: Alignment.center,
  //             color: Colors.transparent,
  //             height: 300,
  //             width: 300,
  //             child: GestureDetector(
  //               onTap: () {},
  //               child: SizedBox(
  //                 height: 300,
  //                 width: 300,
  //                 child: Card(
  //                   color: Colors.white,
  //                   child: Center(
  //                     child: Column(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(16),
  //                           margin: const EdgeInsets.all(16),
  //                           color: Colors.black,
  //                           child: Text(
  //                             'Printer List',
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                         ),
  //                         for (String printerName in _printerList)
  //                           MaterialButton(
  //                             onPressed: () {
  //                               ProcessesModel.stored!.printerName =
  //                                   printerName;
  //                               ProcessesModel.stored!.edit();
  //                             },
  //                             child: Text('$printerName\n'),
  //                           )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GeneralSettingsAppBar(),
          Container(
            // height: 80,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DatabaseSettings(),
                  ),
                );
              },
              leading: const Icon(Icons.library_books),
              title: const Text('Database'),
              subtitle: const Text('Categories and so..'),
            ),
          ),
          Container(
            // height: 80,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: CheckboxListTile(
              onChanged: (v) {
                setState(() {
                  SystemConfig().animations = !SystemConfig().animations;
                });
              },
              value: SystemConfig().animations,
              // leading: const Icon(Icons.book),
              title: const Text('الرسوم المتحركة'),
              subtitle: Text(SystemConfig().animations ? "تعمل" : "لا تعمل"),
            ),
          ),
          ListTile(
            title: const Text('اختيار الطابعة'),
            leading: const Icon(
              Icons.print,
            ),
            trailing: Text(SystemConfig().printer.toString()),
            onTap: () async {
              panamas = ((await WindowsPrinting.getAvailablePrintersNames())
                      as String)
                  .split(',');
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...panamas
                              .map(
                                (e) => ListTile(
                                  title: Text(e),
                                  onTap: () async {
                                    // final box = await Hive.openBox('data');
                                    setState(() {
                                      SystemConfig().printer = e;
                                    });
                                    // await box
                                    //     .put('defPrntr', SystemConfig.printer)
                                    //     .then((value) {
                                    Navigator.pop(context);
                                    // });
                                  },
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Page Routings'),
            leading: const Icon(
              Icons.route,
            ),
            trailing: Text(SystemConfig().pageRoute.toString()),
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...pageRoutingTypes
                              .map(
                                (e) => ListTile(
                                  title: Text(e),
                                  onTap: () async {
                                    setState(() {
                                      SystemConfig().pageRoute = e;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('نظام شاشة البيع'),
            trailing: DropdownButton<String>(
              value: SystemConfig().salesType,
              items: const [
                DropdownMenuItem<String>(
                  value: InterfaceType.administration,
                  child: Text(InterfaceType.administration),
                ),
                DropdownMenuItem<String>(
                  value: InterfaceType.lab,
                  child: Text(InterfaceType.lab),
                ),
                DropdownMenuItem<String>(
                  value: InterfaceType.pharmacy,
                  child: Text(InterfaceType.pharmacy),
                ),
                DropdownMenuItem<String>(
                  value: InterfaceType.reception,
                  child: Text(InterfaceType.reception),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    SystemConfig().salesType = value;
                  });
                }
              },
            ),
          ),
          // Container(
          //   // height: 80,
          //   padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          //   child: ListTile(
          //     onTap: () {},
          //     leading: const Icon(Icons.print_rounded),
          //     title: const Text('Default Printer'),
          //     subtitle: Text(
          //       'Current: ${SystemConfig.printer ?? 'Default Printer Not Defiend, We can' "'" 't find any available printers'}',
          //     ),
          //   ),
          // ),
          Container(
            // height: 80,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: ListTile(
              onTap: onTapInvoicesSavingFolder,
              leading: const Icon(Icons.folder),
              title: const Text('Invoices Saving Folder'),
              subtitle:
                  Text('Current: ${SystemConfig().invoicesSaveDirectoryPath}'),
            ),
          ),
        ],
      ),
    );
  }

  void onTapInvoicesSavingFolder() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      context: context,
      builder: (context) {
        TextEditingController cont = TextEditingController(
          text: SystemConfig().invoicesSaveDirectoryPath,
        );
        return Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              TextField(
                controller: cont,
                onSubmitted: (String input) async {
                  if (await chkdir(input)) {
                    SystemConfig().invoicesSaveDirectoryPath = input;
                    Navigator.pop(context);
                    setState(() {});
                  } else {
                    toast("We can't find the specified directory");
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneralSettingsAppBar extends StatelessWidget {
  const GeneralSettingsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Account Settings'),
        centerTitle: true,
        actions: const [],
      ),
    );
  }
}
