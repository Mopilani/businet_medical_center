import 'dart:async';

import 'package:businet_medical_center/models/medical_service_model.dart';
import 'package:businet_medical_center/models/note_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:flutter/material.dart';
import 'package:updater/updater.dart' as updater;

Future<T?> crudOverlay<T>(
  BuildContext context,
  Widget widget, [
  double height = 400,
  double width = 400,
]) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: height,
            width: width,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: height,
                width: width,
                child: Card(
                  child: widget,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

List<MedicalServiceModel> cachedMedicalServices = [];

Future<MedicalServiceModel?> medicalServiceCrudOverlay(context) async {
  TextEditingController controller = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0.0');
  int? selectedId;
  Widget widget = Padding(
    padding: const EdgeInsets.all(16),
    child: updater.UpdaterBloc(
      updater: NotesCrudOverlayUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Column(
          children: [
            const Text(
              'الخدمات الطبية',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              children: const [
                SizedBox(width: 40, child: Text('الرقم')),
                SizedBox(width: 12),
                Text(
                  'الوصف',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 12),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: Text(
                    'السعر',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cachedMedicalServices.length,
                itemBuilder: (context, index) {
                  MedicalServiceModel model = cachedMedicalServices[index];
                  return InkWell(
                    onTap: () {
                      selectedId = model.id;
                      controller.text = model.description;
                      priceController.text = model.price.toString();
                      NotesCrudOverlayUpdater().add('');
                    },
                    onDoubleTap: () {
                      Navigator.pop<MedicalServiceModel>(context, model);
                      NotesCrudOverlayUpdater().add('');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          SizedBox(width: 40, child: Text(model.id.toString())),
                          const SizedBox(width: 12),
                          Text(
                            model.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: Text(
                              model.price.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FocusableField(
                      controller,
                      FocusNode(),
                      'وصف الخدمة',
                      (text) {
                        return true;
                      },
                    ),
                  ),
                  Expanded(
                    child: FocusableField(
                      priceController,
                      FocusNode(),
                      'سعر الخدمة',
                      (text) {
                        return true;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () async {
                        var noteId = await ProcessesModel.stored!
                            .requestMedicalServiceId();
                        var model = MedicalServiceModel(
                          noteId,
                          double.parse(priceController.text),
                          controller.text,
                        );
                        await model.add();
                        var value = await MedicalServiceModel.getAll();
                        cachedMedicalServices.clear();
                        cachedMedicalServices.addAll(value);
                        NotesCrudOverlayUpdater().add('');
                      },
                      color: Colors.black87,
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: selectedId == null
                          ? null
                          : () async {
                              var r =
                                  await MedicalServiceModel.get(selectedId!);
                              if (r == null) {
                                var model = MedicalServiceModel(
                                  selectedId!,
                                  double.parse(priceController.text),
                                  controller.text,
                                );
                                await model.add();
                              } else {
                                r.description = controller.text;
                                r.price = double.parse(priceController.text);
                                await r.edit();
                              }
                              var value = await MedicalServiceModel.getAll();
                              cachedMedicalServices.clear();
                              cachedMedicalServices.addAll(value);
                              selectedId = null;
                              NotesCrudOverlayUpdater().add('');
                            },
                      color: Colors.black87,
                      child: const Text(
                        'تعديل',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: selectedId == null
                          ? null
                          : () async {
                              var r =
                                  await MedicalServiceModel.get(selectedId!);
                              await r?.delete();
                              var value = await MedicalServiceModel.getAll();
                              cachedMedicalServices.clear();
                              cachedMedicalServices.addAll(value);
                              selectedId = null;
                              NotesCrudOverlayUpdater().add('');
                            },
                      color: Colors.black87,
                      child: const Text(
                        'حذف',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  double height = 700;
  double width = 600;

  var value = await MedicalServiceModel.getAll();
  cachedMedicalServices.clear();
  cachedMedicalServices.addAll(value);
  return await crudOverlay<MedicalServiceModel>(
    context,
    widget,
    height,
    width,
  );
}

List<NoteModel> cachedNotes = [];

Future<NoteModel?> notesCrudOverlay(context) async {
  TextEditingController controller = TextEditingController();
  int? selectedId;
  Widget widget = Padding(
    padding: const EdgeInsets.all(16),
    child: updater.UpdaterBloc(
      updater: NotesCrudOverlayUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Column(
          children: [
            const Text(
              'الملاحظات',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cachedNotes.length,
                itemBuilder: (context, index) {
                  NoteModel model = cachedNotes[index];
                  return InkWell(
                    onTap: () {
                      selectedId = model.id;
                      controller.text = model.content;
                      NotesCrudOverlayUpdater().add('');
                    },
                    onDoubleTap: () {
                      Navigator.pop<NoteModel>(context, model);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Text(model.id.toString()),
                          const SizedBox(width: 12),
                          Text(
                            model.content,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: FocusableField(
                      controller,
                      FocusNode(),
                      'الملاحظة',
                      (text) {
                        return true;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () async {
                        var noteId =
                            await ProcessesModel.stored!.requestNoteId();
                        var model = NoteModel(
                          noteId,
                          content: controller.text,
                        );
                        await model.add();
                        var value = await NoteModel.getAll();
                        cachedNotes.clear();
                        cachedNotes.addAll(value);
                        NotesCrudOverlayUpdater().add('');
                      },
                      color: Colors.black87,
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: selectedId == null
                          ? null
                          : () async {
                              var r = await NoteModel.get(selectedId!);
                              if (r == null) {
                                var model = NoteModel(
                                  selectedId!,
                                  content: controller.text,
                                );
                                await model.add();
                              } else {
                                r.content = controller.text;
                                await r.edit();
                              }
                              var value = await NoteModel.getAll();
                              cachedNotes.clear();
                              cachedNotes.addAll(value);
                              selectedId = null;
                              NotesCrudOverlayUpdater().add('');
                            },
                      color: Colors.black87,
                      child: const Text(
                        'تعديل',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: selectedId == null
                          ? null
                          : () async {
                              var r = await NoteModel.get(selectedId!);
                              await r?.delete();
                              var value = await NoteModel.getAll();
                              cachedNotes.clear();
                              cachedNotes.addAll(value);
                              selectedId = null;
                              NotesCrudOverlayUpdater().add('');
                            },
                      color: Colors.black87,
                      child: const Text(
                        'حذف',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  double height = 700;
  double width = 600;

  var value = await NoteModel.getAll();
  cachedNotes.clear();
  cachedNotes.addAll(value);
  return await crudOverlay<NoteModel>(
    context,
    widget,
    height,
    width,
  );
}
