
mixin DateFormats {

  String get currentDateInFormatted {
    DateTime now = DateTime.now();

    String formattedDate = "${now.year}_${now.month}_${now.day}";
    return formattedDate;
  }
}