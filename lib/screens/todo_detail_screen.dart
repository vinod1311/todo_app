import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/repository/todo/model/todo_model.dart';

import '../utils/common_text_style.dart';
import '../utils/widgets/custom_appbar.dart';

class TodoDetailScreen extends StatefulWidget {
  final TodoModel todoModel;
  const TodoDetailScreen({Key? key, required this.todoModel}) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'TODO Detail',
        hasLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: ListView(
          children: [
            buildDetailItem("Task", widget.todoModel.title),
            SizedBox(height: 10.h),
            buildDetailItem("Category", widget.todoModel.category),
            SizedBox(height: 10.h),
            buildDetailItem("Due Date", widget.todoModel.dueDate),
            SizedBox(height: 10.h),
            buildDetailItem("Description", widget.todoModel.description),
          ],
        ),
      ),
    );
  }

  Widget buildDetailItem(String title, String? value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: KTextStyle.txtMedium16.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              value ?? "",
              style: KTextStyle.txtRegular16.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
