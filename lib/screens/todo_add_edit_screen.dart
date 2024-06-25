import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/bloc/common/common_state.dart';
import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/bloc/todo/todo_event.dart';
import 'package:todo_app/repository/todo/model/todo_model.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/utils/common_text_style.dart';

import '../bloc/common/common_bloc.dart';
import '../bloc/common/common_event.dart';
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



  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController dueDateEditingController = TextEditingController();

  static const List<String> taskCategoryList = ['personal','shopping','work'];

  String? selectedCategory;
  String? selectedDueDate;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      if(widget.isEdit && widget.todoModel != null){
        titleTextEditingController.text = widget.todoModel?.title ?? '';
        descriptionTextEditingController.text = widget.todoModel?.description ?? '';
        selectedCategory = widget.todoModel?.category ?? '';
        dueDateEditingController.text = widget.todoModel?.dueDate ?? '';
        selectedDueDate = widget.todoModel?.dueDate ?? '';
      }
    });
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    categoryTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    dueDateEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonBloc = BlocProvider.of<CommonBloc>(context);
    final todoBloc = BlocProvider.of<TodoBloc>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: widget.isEdit ? "Edit Todo" : "Add Todo",hasLeading: true,),
      body: BlocBuilder<CommonBloc,CommonState>(
        builder: (context,commonState){
          selectedCategory = commonState.selectedCategory;
          selectedDueDate = commonState.selectedDueDate;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h,),
                  TextFormField(
                    controller: titleTextEditingController,
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
                    controller: descriptionTextEditingController,
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
                    value: selectedCategory,
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
                    items: taskCategoryList.map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,style: KTextStyle.txtRegular14.copyWith(color: Theme.of(context).colorScheme.primary),),
                    )).toList(),
                    onChanged: (value) {
                      commonBloc.add(SetCategoryEvent(value ?? ''));
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
                      commonBloc.add(SetDueDateEvent(formattedDate));
                      dueDateEditingController.text = formattedDate;
                    },
                    controller: dueDateEditingController,
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
                            category: selectedCategory,
                            description: descriptionTextEditingController.text,
                            dueDate: selectedDueDate,
                            title: titleTextEditingController.text,
                            id: widget.todoModel?.id,
                          );
                          // await todoControllerWatch.updateTodo(todo);
                          todoBloc.add(UpdateTodoEvent(todo));
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
                          TodoModel todo = TodoModel(
                              isCompleted: 0,
                              category: selectedCategory,
                              description: descriptionTextEditingController.text,
                              dueDate: selectedDueDate,
                              title: titleTextEditingController.text,
                              id: getUUID()
                          );
                          // await todoControllerWatch.addTodo(todo);
                          todoBloc.add(AddTodoEvent(todo));
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
                        }
                      },
                      child: Text("Save",style: KTextStyle.txtMedium18.copyWith(color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
