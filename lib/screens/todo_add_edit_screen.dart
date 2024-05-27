import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/todo_controller.dart';
import 'package:todo_app/models/TodoModel.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/utils/common_text_style.dart';

import '../utils/common.dart';
import '../utils/widgets/custom_appbar.dart';


class TodoAddEditScreen extends StatefulWidget {
  final bool isEdit;
  final TodoModel? todoModel;
  const TodoAddEditScreen({Key? key,required this.isEdit,this.todoModel}) : super(key: key);

  @override
  State<TodoAddEditScreen> createState() => _TodoAddEditScreenState();
}

class _TodoAddEditScreenState extends State<TodoAddEditScreen> {

  late TodoController todoControllerWatch;
  late TodoController todoControllerRead;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      todoControllerRead = context.read<TodoController>();
      if(widget.isEdit && widget.todoModel != null){
        todoControllerRead.titleTextEditingController.text = widget.todoModel?.title ?? '';
        todoControllerRead.descriptionTextEditingController.text = widget.todoModel?.description ?? '';
        todoControllerRead.selectedCategory = widget.todoModel?.category ?? '';
        todoControllerRead.dueDateEditingController.text = widget.todoModel?.dueDate ?? '';
        todoControllerRead.selectedDueDate = widget.todoModel?.dueDate ?? '';
      }
    });
  }

  @override
  void dispose() {
    todoControllerRead.disposeTodoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    todoControllerWatch = context.watch<TodoController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: widget.isEdit ? "Edit Todo" : "Add Todo",hasLeading: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h,),
              TextFormField(
                controller: todoControllerWatch.titleTextEditingController,
                style: KTextStyle.txtRegular14.copyWith(color: Theme.of(context).colorScheme.primary),cursorColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  label: Text("Title",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 20.h,),
              TextFormField(
                controller: todoControllerWatch.descriptionTextEditingController,
                style: KTextStyle.txtRegular14.copyWith(color: Theme.of(context).colorScheme.primary),
                cursorColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  label: Text("Description",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),),
                  alignLabelWithHint: true,
                ),

              ),
              SizedBox(height: 20.h,),

              DropdownButtonFormField<String>(
                value: todoControllerWatch.selectedCategory,
                elevation: 1,
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 0.0,
                        strokeAlign: 0.0
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0,
                        strokeAlign: 0.0
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0,
                        strokeAlign: 0.0
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.0,
                      strokeAlign: 0.0
                    ),
                  )
                ),
                items: todoControllerWatch.taskCategoryList.map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item,style: KTextStyle.txtRegular14.copyWith(color: Theme.of(context).colorScheme.primary),),
                )).toList(),
                onChanged: (value) {
                  todoControllerWatch.setSelectedCategory(value ?? '');
                },
              ),
              SizedBox(height: 20.h,),
              TextFormField(
                onTap: () async{
                  DateTime? date = DateTime.now();
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime.now(),
                      lastDate: DateTime(2100));
                  String formattedDate = getDDMMYYDate(date!);
                  todoControllerWatch.setSelectedDueDate(formattedDate);
                },
                controller: todoControllerWatch.dueDateEditingController,
                style: KTextStyle.txtRegular14.copyWith(color: Theme.of(context).colorScheme.primary),
                cursorColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  label: Text("Due Date",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),),
                  alignLabelWithHint: true,
                ),

              ),

              SizedBox(height: 40.h,),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)
                    )
                  ),
                  onPressed: () async {
                    if(widget.isEdit){
                      ///-------  For Updating Todo
                      TodoModel todo = TodoModel(
                          isCompleted: 0,
                          category: todoControllerWatch.selectedCategory,
                          description: todoControllerWatch.descriptionTextEditingController.text,
                          dueDate: todoControllerWatch.selectedDueDate,
                          title: todoControllerWatch.titleTextEditingController.text,
                          id: widget.todoModel?.id,
                      );
                      await todoControllerWatch.updateTodo(todo);
                      Navigator.push(context, MaterialPageRoute(builder: ( (context) => const HomeScreen() )));
                      Fluttertoast.showToast(
                          msg: "Task edited successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: const Color(0xFF9BCF53),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{
                      ///-------  For Adding Todo
                      log("todoControllerWatch.selectedDeoDate ${todoControllerWatch.selectedDueDate.runtimeType}");
                      TodoModel todo = TodoModel(
                        isCompleted: 0,
                        category: todoControllerWatch.selectedCategory,
                        description: todoControllerWatch.descriptionTextEditingController.text,
                        dueDate: todoControllerWatch.selectedDueDate,
                        title: todoControllerWatch.titleTextEditingController.text,
                        id: getUUID()
                      );
                      await todoControllerWatch.addTodo(todo);


                        Navigator.push(context, MaterialPageRoute(builder: ( (context) => const HomeScreen() )));
                        Fluttertoast.showToast(
                            msg: "New task created!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color(0xFF9BCF53),
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      todoControllerWatch.disposeTodoController();
                    }
                  },
                  child: Text("Save",style: KTextStyle.txtMedium18.copyWith(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
