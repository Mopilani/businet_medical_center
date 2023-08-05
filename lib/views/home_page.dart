import 'package:businet_medical_center/views/data/datas_view.dart';
import 'package:businet_medical_center/views/exit_screen.dart';
import 'package:businet_medical_center/views/laboratory/laboratory_page_view.dart';
import 'package:businet_medical_center/views/reservation/reservation.dart';
import 'package:businet_medical_center/views/settings/settings.dart';
import 'package:businet_medical_center/views/treasury/treatury_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Segment> segments = [
    Segment(
      const ReservationViews(examination: false),
      'الحجز',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const ReservationViews(examination: true),
      'الكشف',
      '',
      icon: Icons.abc,
    ),
    Segment(
      const LaboratoryView(),
      'المعمل',
      '',
      icon: Icons.abc,
    ),
    Segment(
      const TreasuryView(),
      'الخزينة',
      '',
      icon: Icons.money,
    ),
    Segment(
      null,
      'العمليات',
      '',
      icon: Icons.polyline,
    ),
    Segment(
      null,
      'احصائات',
      '',
      icon: Icons.polyline,
    ),
    Segment(
      const DataManipulation(),
      'البيانات',
      '',
      icon: Icons.data_array_rounded,
    ),
    Segment(
      const SettingsView(),
      'الاعدادات',
      '',
      icon: Icons.settings,
    ),
    Segment(
      const ExitScreen(),
      'خروج',
      '',
      icon: Icons.exit_to_app,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          height: 500,
          width: 700,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: segments.length,
                  itemBuilder: (context, index) {
                    var item = segments[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (item.routeWidget == null) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item.routeWidget!,
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Segment {
  Segment(
    this.routeWidget,
    this.title,
    this.desctiption, {
    this.icon,
    this.imagePath,
  });

  Widget? routeWidget;
  String title;
  IconData? icon;
  String? imagePath;
  String desctiption;
}
