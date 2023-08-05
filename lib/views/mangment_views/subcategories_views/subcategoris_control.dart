import 'package:businet_medical_center/models/category_model.dart';
import 'package:businet_medical_center/models/subcatgory_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

class SubcategoriesControle extends StatefulWidget {
  const SubcategoriesControle({
    Key? key,
    this.model,
    this.editMode = false,
  }) : super(key: key);
  final SubCatgModel? model;
  final bool editMode;

  @override
  State<SubcategoriesControle> createState() => _SubcategoriesControleState();
}

class _SubcategoriesControleState extends State<SubcategoriesControle> {
  late FocusNode descriptionNode;
  late FocusNode nameNode;
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameNode = FocusNode();
    descriptionNode = FocusNode();
    if (widget.editMode) {
      id = widget.model!.id;
      subcatgoryName = widget.model!.subcatgoryName;
      subcatgoryDescription = widget.model!.subcatgoryDescription;
      idController = TextEditingController(text: id.toString());
      nameController = TextEditingController(text: subcatgoryName);
      descriptionController =
          TextEditingController(text: subcatgoryDescription);
    } else {
      idController = TextEditingController();
      nameController = TextEditingController();
      descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameNode.dispose();
    descriptionNode.dispose();
  }

  bool loading = false;

  final List<SubCatgModel> models = [];

  int id = 0;
  String subcatgoryName = '';
  String subcatgoryDescription = '';

  @override
  Widget build(BuildContext context) {
    // _registeredSaleUnits.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editMode ? 'edit_subcategory'.tr : 'add_subcategory'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: idController,
                autofocus: !widget.editMode,
                enabled: !widget.editMode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'id'.tr,
                ),
                onSubmitted: (result) {
                  if (result.isEmpty) {
                    showSimpleNotification(
                      const Text('لا يمكنك ترك معرف الشريحة فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  try {
                    id = int.parse(result);
                  } catch (e) {
                    showSimpleNotification(
                      const Text(
                          'تأكد من كتابتك للمعرف بصورة صحيحة حيث يحتوي على ارقام فقط'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  nameNode.requestFocus();
                  nameController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: nameController.text.length,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: nameController,
                autofocus: widget.editMode,
                focusNode: nameNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'name'.tr,
                ),
                onSubmitted: (result) {
                  if (result.isEmpty) {
                    showSimpleNotification(
                      const Text('لا يمكنك ترك اسم الشريحة الرئيسية فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  subcatgoryName = result;
                  descriptionNode.requestFocus();
                  descriptionController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: descriptionController.text.length,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: descriptionController,
                focusNode: descriptionNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'description'.tr,
                ),
                onSubmitted: (result) {
                  subcatgoryDescription = result;
                },
              ),
            ),
          ),
          const Spacer(),
          MaterialButton(
            color: Colors.blue,
            child: const Text(
              'حفظ',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              setState(() {
                loading = true;
              });

              if (widget.editMode) {
                await SubCatgModel(
                  id,
                  subcatgoryName,
                  subcatgoryDescription,
                ).edit().then((value) {
                  setState(() {
                    loading = false;
                  });
                  showSimpleNotification(
                    const Text(
                      'تم بنجاح',
                      style: TextStyle(fontSize: 20),
                    ),
                    position: NotificationPosition.bottom,
                  );
                });
              } else {
                if (idController.text.isEmpty) {
                  showSimpleNotification(
                    const Text('لا يمكنك ترك معرف الشريحة فارغا'),
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                if (subcatgoryName.isEmpty) {
                  showSimpleNotification(
                    const Text('لا يمكنك ترك اسم الشريحة فارغا'),
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                await CatgoryModel.get(id).then(
                  (value) async {
                    if (value == null) {
                      await SubCatgModel(
                        id,
                        subcatgoryName,
                        subcatgoryDescription,
                      ).add().then((value) {
                        setState(() {
                          loading = false;
                          showSimpleNotification(
                            const Text(
                              'تم بنجاح',
                              style: TextStyle(fontSize: 20),
                            ),
                            position: NotificationPosition.bottom,
                          );
                        });
                      });
                    } else {
                      toast('معرف المنتج مدرج بالفعل');
                    }
                  },
                );
              }
            },
          ),
          const Spacer(),
        ],
      ),
      // FutureBuilder<List<SubCatgModel>>(
      //   future: SubCatgModel.getAll(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('حدث خطأ اثناء تحميل البيانات');
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     }
      //     if (snapshot.hasData) {
      //       models.addAll(snapshot.data!);
      //     }
      //     return Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         children: models.map(
      //           (model) {
      //             return Text(model.subcatgoryName);
      //           },
      //         ).toList(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
