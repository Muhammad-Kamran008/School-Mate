import 'package:flutter/material.dart';
import 'package:schoolmate/controller/core/colors.dart';
import 'package:schoolmate/controller/core/textstyle.dart';

AppBar myAppbar(String title) {
  return AppBar(
    title: Text(
      title,
      style: appbarTextStyle,
    ),
    backgroundColor: appbarColor,
     
  );
}
