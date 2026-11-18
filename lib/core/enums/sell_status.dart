enum SellStatus {
  completed,
  draft;

  String get value {
    switch (this) {
      case completed:
        return 'final';
      case draft:
        return 'draft';
    }
  }
}
