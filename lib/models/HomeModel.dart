import 'dart:convert';

import 'package:todo_app/models/TodoModel.dart';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  int? todayCount;
  int? scheduledCount;
  int? allCount;
  int? overDueCount;
  List<TodoModel>? todayDueDateList;
  List<TodoModel>? allTasksList;
  List<TodoModel>? overDueTasksList;
  List<TodoModel>? scheduledTasksList;

  HomeModel({
    this.todayCount,
    this.scheduledCount,
    this.allCount,
    this.overDueCount,
    this.todayDueDateList,
    this.allTasksList,
    this.overDueTasksList,
    this.scheduledTasksList
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    todayCount: json["todayCount"],
    scheduledCount: json["scheduledCount"],
    allCount: json["allCount"],
    overDueCount: json["overDueCount"],
    todayDueDateList: json["todayDueDateList"] == null ? [] : List<TodoModel>.from(json["todayDueDateList"]!.map((x) => TodoModel.fromJson(x))),
    allTasksList: json["allTasksList"] == null ? [] : List<TodoModel>.from(json["allTasksList"]!.map((x) => TodoModel.fromJson(x))),
    overDueTasksList: json["overDueTasksList"] == null ? [] : List<TodoModel>.from(json["overDueTasksList"]!.map((x) => TodoModel.fromJson(x))),
    scheduledTasksList: json["scheduledTasksList"] == null ? [] : List<TodoModel>.from(json["scheduledTasksList"]!.map((x) => TodoModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "todayCount": todayCount,
    "scheduledCount": scheduledCount,
    "allCount": allCount,
    "overDueCount": overDueCount,
    "todayDueDateList": todayDueDateList == null ? [] : List<dynamic>.from(todayDueDateList!.map((x) => x.toJson())),
    "allTasksList": allTasksList == null ? [] : List<dynamic>.from(allTasksList!.map((x) => x.toJson())),
    "overDueTasksList": overDueTasksList == null ? [] : List<dynamic>.from(overDueTasksList!.map((x) => x.toJson())),
    "scheduledTasksList": scheduledTasksList == null ? [] : List<dynamic>.from(scheduledTasksList!.map((x) => x.toJson())),
  };
}


