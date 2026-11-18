import 'package:get/get.dart';

extension TranslationExtension on String {
  String itemsCount(int count) {
    final String key;

    if (Get.locale?.languageCode == 'ar') {
      if (count == 1) {
        key = 'item';
      } else if (count == 2) {
        key = 'two_items';
      } else {
        key = 'items';
      }
    } else {
      key = count == 1 ? 'item' : 'items';
    }

    return 'items_count'.trParams({'count': count.toString(), 'item': key.tr});
  }

  String guestsCount(int count) {
    final String key;

    if (Get.locale?.languageCode == 'ar') {
      if (count == 1) {
        key = 'guest';
      } else if (count == 2) {
        key = 'two_guests';
      } else {
        key = 'guests';
      }
    } else {
      key = count == 1 ? 'guest' : 'guests';
    }

    return 'guests_count'.trParams({
      'count': count.toString(),
      'guest': key.tr,
    });
  }
}
