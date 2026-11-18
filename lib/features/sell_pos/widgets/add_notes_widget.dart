import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class AddNotesWidget extends StatefulWidget {
  const AddNotesWidget({super.key});

  @override
  State<AddNotesWidget> createState() => _AddNotesWidgetState();
}

class _AddNotesWidgetState extends State<AddNotesWidget> {
  late final TextEditingController notesController;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    notesController = TextEditingController(
      text: Get.find<PosController>().orderNote,
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasNote = notesController.text.trim().isNotEmpty;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
        ),
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'notes'.tr,
                  style: TextStyle(
                    fontSize: context.largeFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: IconButton(
                  onPressed: Get.back,
                  icon: Icon(Icons.close, size: context.iconSize),
                ),
              ),

              const SizedBox(height: 5),

              CustomTextField(
                maxLines: 5,
                maxLength: 500,
                controller: notesController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                hint: 'enter_note'.tr,
                onChanged: (_) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'enter_note'.tr;
                  }
                  return null;
                },
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(
                children: [
                  if (hasNote) ...[
                    Expanded(
                      child: CustomButtonWidget(
                        onPressed: _clearNote,
                        buttonText: 'clear'.tr,
                        icon: Icons.delete_outline,
                        transparent: true,
                        isBorder: true,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                  ],

                  Expanded(
                    flex: 2,
                    child: CustomButtonWidget(
                      onPressed: _saveNote,
                      buttonText: 'save'.tr,
                      icon: Icons.check,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    final note = notesController.text.trim();
    Get.find<PosController>().setOrderNote(note);

    Get.back();
  }

  void _clearNote() {
    notesController.clear();

    Get.find<PosController>().clearOrderNote();

    setState(() {});
  }
}
