import 'package:flutter/widgets.dart';
import 'dart:convert';

Image imageFromString(String input){
  return Image.memory(
    base64Decode(input),
    fit: BoxFit.cover,
  );
} 