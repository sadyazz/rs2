import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

Image imageFromString(String input) {
  try {
    return Image.memory(
      base64Decode(input),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/placeholder_movie.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFE0E0E0),
              child: const Icon(
                Icons.movie,
                color: Color(0xFF757575),
                size: 32,
              ),
            );
          },
        );
      },
    );
  } catch (e) {
    return Image.asset(
      'assets/images/placeholder_movie.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFE0E0E0),
          child: const Icon(
            Icons.movie,
            color: Color(0xFF757575),
            size: 32,
          ),
        );
      },
    );
  }
} 