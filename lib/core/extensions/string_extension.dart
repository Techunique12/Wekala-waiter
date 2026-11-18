extension StringExtension on String {
  String get cleanHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim();
  }
}
