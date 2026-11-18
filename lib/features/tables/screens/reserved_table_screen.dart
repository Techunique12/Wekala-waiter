import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/date_time_extensions.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/tables/controllers/tables_controller.dart';
import 'package:wekala_waiter/features/tables/domain/models/reserve_table_request.dart';
import 'package:wekala_waiter/features/tables/domain/models/table_model.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class ReservedTableScreen extends StatefulWidget {
  const ReservedTableScreen({super.key});

  @override
  State<ReservedTableScreen> createState() => _ReservedTableScreenState();
}

class _ReservedTableScreenState extends State<ReservedTableScreen> {
  late final TableModel table;
  late final bool isEdit;

  int? bookingId;
  bool _isLoading = true;

  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final guestsController = TextEditingController(text: '2');
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final durationController = TextEditingController(text: '90');
  final notesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    table = Get.arguments as TableModel;

    bookingId = table.bookingId;
    isEdit = bookingId != null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  Future<void> _initializeForm() async {
    try {
      if (isEdit) {
        final tablesController = Get.find<TablesController>();

        final reservation = await tablesController.getReservation(
          bookingId: bookingId!,
        );

        if (!mounted) return;

        if (reservation == null) {
          return;
        }

        customerNameController.text = reservation.customerName;
        phoneController.text = reservation.phone ?? '';
        guestsController.text = '${reservation.guests}';
        durationController.text = '${reservation.durationMinutes}';
        notesController.text = reservation.notes ?? '';

        final date = DateTime.tryParse(reservation.date);

        if (date != null) {
          selectedDate = date;
          dateController.text = date.formatDisplayDate;
        }

        final time = parseApiTime(reservation.time);

        if (time != null) {
          selectedTime = time;
          timeController.text = time.formatDisplayTime(context);
        }
      } else {
        final now = DateTime.now();

        selectedDate = now;
        selectedTime = TimeOfDay.fromDateTime(now);

        dateController.text = now.formatDisplayDate;
        timeController.text = selectedTime!.formatDisplayTime(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    customerNameController.dispose();
    phoneController.dispose();
    guestsController.dispose();
    dateController.dispose();
    timeController.dispose();
    durationController.dispose();
    notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? '${'update_reservation'.tr} ${table.name}'
              : '${'reserve'.tr} ${table.name}',
          style: TextStyle(fontSize: context.largeFont),
        ),
      ),

      bottomNavigationBar: GetBuilder<TablesController>(
        builder: (controller) {
          return SafeArea(
            child: CustomButtonWidget(
              buttonText: isEdit
                  ? 'update_reservation'.tr
                  : 'save_reservation'.tr,
              isLoading: controller.isLoading,
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              onPressed: !_isLoading ? () => _submit(controller) : null,
            ),
          );
        },
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    CustomTextField(
                      label: 'customer_name'.tr,
                      hint: 'full_name'.tr,
                      textInputAction: TextInputAction.next,
                      controller: customerNameController,
                      required: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'customer_name_required'.tr;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),
                    CustomTextField(
                      label: 'phone_number'.tr,
                      hint: '01xxxxxxxxx',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: phoneController,
                      required: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'customer_phone_required'.tr;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'reservation_duration'.tr,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: durationController,
                            validator: (value) {
                              final duration = int.tryParse(value ?? '');

                              if (duration == null || duration < 15) {
                                return 'duration_minimum'.tr;
                              }

                              return null;
                            },
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: CustomTextField(
                            label: 'number_of_guests'.tr,
                            hint: '2',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: guestsController,
                            validator: (value) {
                              final guests = int.tryParse(value ?? '');

                              if (guests == null || guests < 1) {
                                return 'guests_required'.tr;
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'date'.tr,
                            hint: 'select_date'.tr,
                            readOnly: true,
                            suffixWidget: const Icon(
                              Icons.calendar_today_outlined,
                            ),
                            onTap: _selectDate,
                            controller: dateController,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: CustomTextField(
                            label: 'time'.tr,
                            hint: 'select_time'.tr,
                            readOnly: true,
                            suffixWidget: const Icon(
                              Icons.access_time_outlined,
                            ),
                            onTap: _selectTime,
                            controller: timeController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'notes'.tr,
                      hint: 'enter_reservation_notes'.tr,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                      controller: notesController,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _submit(TablesController controller) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      return;
    }

    final request = ReserveTableRequest(
      customerName: customerNameController.text.trim(),
      guests: int.parse(guestsController.text),

      // API: yyyy-MM-dd
      date: selectedDate!.formatApiDate,

      // API: HH:mm
      time: selectedTime!.formatApiTime,

      durationMinutes: int.parse(durationController.text),

      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),

      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    if (isEdit) {
      if (bookingId == null) return;

      await controller.updateReservation(
        bookingId: bookingId!,
        request: request,
      );
    } else {
      await controller.reserveTable(tableId: table.id, request: request);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
      dateController.text = date.formatDisplayDate;
    });
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (time == null || !mounted) return;

    setState(() {
      selectedTime = time;
      timeController.text = time.formatDisplayTime(context);
    });
  }
}
