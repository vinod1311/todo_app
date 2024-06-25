import 'dart:convert';

import 'package:flutter/cupertino.dart';

TodoModel todoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoModelToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
  String? id;
  @required String? title;
  @required String? category;
  String? description;
  String? dueDate;
  int? isCompleted;

  TodoModel({
    this.id,
    this.title,
    this.category,
    this.description,
    this.dueDate,
    this.isCompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    id: json["id"],
    title: json["title"],
    category: json["category"],
    description: json["description"],
    dueDate: json["dueDate"],
    isCompleted: json["isCompleted"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category": category,
    "description":description,
    "dueDate": dueDate,
    "isCompleted":isCompleted,
  };
}
