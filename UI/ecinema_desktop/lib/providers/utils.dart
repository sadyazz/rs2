import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert';


String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if(dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input){
  return Image.memory(
    base64Decode(input),
    fit: BoxFit.cover,
  );
}

ImageProvider imageProviderFromString(String input) {
  return MemoryImage(base64Decode(input));
}
