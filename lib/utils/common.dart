import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Color generateRandomLightColor() {
  const minLightness = 0.7;
  const maxLightness = 0.9;

  final hslColor = HSLColor.fromColor(Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)));
  final lightness = (Random().nextDouble() * (maxLightness - minLightness)) + minLightness;
  return hslColor.withLightness(lightness).toColor();
}


bool isOverdue(DateTime dueDate) {
  return DateTime.now().isAfter(dueDate);
}

bool isUpcoming(DateTime dueDate) {
  final today = DateTime.now();
  final difference = dueDate.difference(today).inDays;
  return difference >= 0 && difference <= 7; // Within the next 7 days
}

String getUUID(){
  return const Uuid().v1();
}

String getDDMMYYDate(DateTime dateTime ){
  // Create a DateFormat instance with the desired format
  DateFormat dateFormat = DateFormat('dd/MM/yy');
// Format the current date
  String formattedDate = dateFormat.format(dateTime);
  return formattedDate;
}

bool isTaskDueToday(String? dueDate) {
  if (dueDate == null) return false;
  DateFormat dateFormat = DateFormat("dd/MM/yy");
  DateTime taskDueDate = dateFormat.parse(dueDate);
  DateTime today = DateTime.now();
  return taskDueDate.year == today.year && taskDueDate.month == today.month && taskDueDate.day == today.day;
}

bool isTaskOverdue(String? dueDate) {
  if (dueDate == null) return false;
  DateTime taskDueDate = convertDateString(dueDate);
  DateTime currentDate = convertDateString(formatDate(DateTime.now()));
  return taskDueDate.isBefore(currentDate);
}

DateTime convertDateString(String dateString) {
  DateFormat inputFormat = DateFormat("dd/MM/yy");
  DateTime dateTime = inputFormat.parse(dateString);
  return dateTime;
}

String formatDate(DateTime dateTime) {
  DateFormat outputFormat = DateFormat("dd/MM/yy");
  String formattedDate = outputFormat.format(dateTime);
  return formattedDate;
}