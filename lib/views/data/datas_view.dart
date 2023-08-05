import 'package:businet_medical_center/views/home_page.dart';
import 'package:businet_medical_center/views/widgets/2_tabs_bar.dart';
import 'package:flutter/material.dart';

import 'lab_analysis_groups_view.dart';
import 'lab_analysis_sample_unit_view.dart';
import 'lab_analysis_sample_view.dart';
import 'lab_analysis_sub_groups_view.dart';
import 'lab_analysis_work_groups_view.dart';
import 'lab_analysises_view.dart';
import 'lab_external_labs_view.dart';
import 'organs_view.dart';
import 'analysis_groups_view.dart';
import 'analysises_view.dart';
import 'checkups_groups_view.dart';
import 'checkups_view.dart';
import 'dosing_view.dart';
import 'instructions_view.dart';
import 'pharaceuticals_view.dart';
import 'pharmaceutical_group_view.dart';
import 'prothrombin_constant_view.dart';

class DataManipulation extends StatefulWidget {
  const DataManipulation({Key? key}) : super(key: key);

  @override
  State<DataManipulation> createState() => _DataManipulationState();
}

class _DataManipulationState extends State<DataManipulation> {
  List<Segment> segments = [
    Segment(
      const AnalysisGroupView(),
      'مجموعات التحاليل',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const AnalysisListView(),
      'التحاليل',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const CheckupsGroupView(),
      'مجموعات الفحوصات',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const CheckupsListView(),
      'الفحوصات',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const PharmaceuticalGroupView(),
      'مجموعات الادوية',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const PharaceuticalListView(),
      'الادوية',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const DosingListView(),
      'الجرعات',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const OrganListView(),
      'اعضاء الجسم',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const InstructionListView(),
      'التعليمات',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'الاطباء',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'الموظفين',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'الوحدات',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'العينات',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'شركات ومندوبين',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'المجموعات التحاليل الرئيسية',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'المجموعات التحاليل الفرعية',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
    Segment(
      const AnalysisListView(),
      'مجموعات العمل',
      '',
      icon: Icons.airplane_ticket_rounded,
    ),
  ];

  List<Segment> labDataSegments = [
    Segment(
      const LabAnalysisListView(),
      'التحاليل',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const LabAnalysisGroupView(),
      'مجموعات التحاليل الرئيسية',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const LabAnalysisSubGroupView(),
      'مجموعات التحاليل الفرعية',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const LabAnalysisWorkGroupView(),
      'مجموعات العمل',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const LabAnalysisSampleView(),
      'العينات',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const LabAnalysisSampleUnitView(),
      'وحدات العينات',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const ProthrombinConstantModelView(),
      'ثوابت البروثرومبين',
      '',
      icon: Icons.local_pharmacy,
    ),
    Segment(
      const LabExternalLabsView(),
      'معامل خارجية',
      '',
      icon: Icons.local_pharmacy,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ادارة البيانات'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            tapBarWidget('بيانات الكشف', 'بيانات المعمل'),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  // Container(),
                  // Container(),
                  defaultDatasView(context),
                  labDatasView(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultDatasView(context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.5,
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
                          textAlign: TextAlign.center,
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
    );
  }

  Widget labDatasView(context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.5,
            ),
            itemCount: labDataSegments.length,
            itemBuilder: (context, index) {
              var item = labDataSegments[index];
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
                          textAlign: TextAlign.center,
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
    );
  }
}
