import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableStatusHelper {
  static Color color(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;

      case 'occupied':
        return Colors.red;

      case 'reserved':
        return Colors.deepPurple;

      case 'unavailable':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  static String name(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'available'.tr;

      case 'occupied':
        return 'occupied'.tr;

      case 'reserved':
        return 'reserved'.tr;

      case 'unavailable':
        return 'unavailable'.tr;

      default:
        return status;
    }
  }
}
