import 'package:flutter/material.dart';
import 'package:music_app/const/colors.dart';

const bold = FontWeight.bold;
const regular = FontWeight.normal;

ourStyle({weight = bold, double? size = 14, color = whiteColor}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: weight,
  );
}
