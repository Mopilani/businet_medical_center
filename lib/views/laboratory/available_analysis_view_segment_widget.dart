import 'package:businet_medical_center/models/lab/analysis_group_model.dart';
import 'package:businet_medical_center/models/lab/analysis_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/widgets/2_tabs_bar.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:flutter/material.dart';
import 'package:updater/updater.dart' as updater;

import '../../view_models/laboratory_reservation_page.dart';

class LabAvailableAnalysisListsViewSegment extends StatelessWidget {
  LabAvailableAnalysisListsViewSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: wantedAnalysisListView(),
    );
  }

  Widget wantedAnalysisListView() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: WantedAnalysisListSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    const Text('تحاليل المريض المطلوبة'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: wantedAnalysis.length,
                        itemBuilder: (context, index) {
                          var analysis = wantedAnalysis[index];
                          return Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(analysis.description)),
                                  const Divider(),
                                  Expanded(
                                      child: Text(analysis.price.toString())),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      wantedAnalysis
                                          .remove(wantedAnalysis[index]);
                                      WantedAnalysisListSegmentUpdater().add(0);
                                    },
                                  ),
                                ],
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
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            tapBarWidget('كل التحاليل', 'مجموعات التحاليل'),
                            const SizedBox(height: 16),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  allAnalysisView(),
                                  groupedAnalysisView(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  AnalysisGroupModel? selectedAnalysisGroup;
  bool analysisSearchMode = false;
  TextEditingController analysisSearchController = TextEditingController();
  var analysisSearchNode = FocusNode();
  Widget allAnalysisView() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: !analysisSearchMode
                  ? null
                  : () {
                      analysisSearchController.clear();
                    },
            ),
            Expanded(
              child: NFocusableField(
                controller: analysisSearchController,
                node: analysisSearchNode,
                labelTextWillBeTranslated: 'بحث',
                onChanged: (text) {
                  analysisSearchMode = true;
                  WantedAnalysisListSegmentUpdater().add(0);
                  analysisSearchNode.requestFocus();
                  return true;
                },
                onSubmited: (text) {
                  return true;
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<AnalysisModel> subList = [];
            for (var analysis in allAnalysis) {
              if (analysis.description
                  .toLowerCase()
                  .contains(analysisSearchController.text.toLowerCase())) {
                subList.add(analysis);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedAnalysis) {
                      if (element.description == subList[index].description) {
                        return;
                      }
                    }
                    wantedAnalysis.add(subList[index]);
                    WantedAnalysisListSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(subList[index].description)),
                          const Divider(),
                          Expanded(
                              child: Text(subList[index].price.toString())),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget groupedAnalysisView() {
    return Column(
      children: [
        DropdownButton<AnalysisGroupModel>(
          items: analysisGroups.map((e) {
            return DropdownMenuItem<AnalysisGroupModel>(
              value: e,
              child: Text(e.title),
              onTap: () {
                selectedAnalysisGroup = e;
                WantedAnalysisListSegmentUpdater().add(0);
              },
            );
          }).toList(),
          value: analysisGroups.isNotEmpty
              ? analysisGroups.first
              : () {
                  selectedAnalysisGroup;
                  if (selectedAnalysisGroup == null) {
                    return null;
                  }
                  for (var element in analysisGroups) {
                    if (selectedAnalysisGroup!.title == element.title) {
                      return element;
                    }
                  }
                }(),
          onChanged: (value) {
            // if (value == null) {
            //   return;
            // }
            // selectedAnalysisGroupTitle = value;
            // WantedAnalysisListSegmentUpdater().add(0);
          },
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<AnalysisModel> subList = [];
            for (var analysis in allAnalysis) {
              if (analysis.analysisGroup.title ==
                  selectedAnalysisGroup?.title) {
                subList.add(analysis);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedAnalysis) {
                      if (element.description == subList[index].description) {
                        return;
                      }
                    }
                    wantedAnalysis.add(subList[index]);
                    WantedAnalysisListSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(subList[index].description)),
                          const Divider(),
                          Expanded(
                              child: Text(subList[index].price.toString())),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
