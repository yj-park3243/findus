import 'dart:core';

import 'package:intl/intl.dart';

String dateFormatter(String date) {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  return df.format(DateTime.parse(date) );
}
