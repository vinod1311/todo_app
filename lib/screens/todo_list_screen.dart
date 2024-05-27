import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/theme_controller.dart';
import 'package:todo_app/controller/todo_controller.dart';
import 'package:todo_app/models/TodoModel.dart';
import 'package:todo_app/screens/todo_add_edit_screen.dart';
import 'package:todo_app/screens/todo_detail_screen.dart';
import '../utils/common.dart';
import '../utils/common_text_style.dart';
import '../utils/widgets/custom_appbar.dart';
import '../utils/widgets/slide_left_animation.dart';


class TodoListScreen extends StatefulWidget {
  final String title;
  final List<TodoModel> todoList;
  const TodoListScreen({Key? key,required this.title,required this.todoList}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  late TodoController todoControllerWatch;
  late TodoController todoControllerRead;

  late ThemeController themeControllerWatch;


  late List<List<TodoModel>> _tabTodoLists;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabTodoLists = [
      widget.todoList, // All
      widget.todoList.where((todo) => todo.category == 'personal').toList(), // Personal
      widget.todoList.where((todo) => todo.category == 'work').toList(), // Work
      widget.todoList.where((todo) => todo.category == 'shopping').toList(), // Shopping
    ];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      todoControllerRead = context.read<TodoController>();
    });
  }

  @override
  Widget build(BuildContext context) {
    todoControllerWatch = context.watch<TodoController>();
    themeControllerWatch = context.watch<ThemeController>();
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(title: '${widget.title} List',hasLeading: true,),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                onTap: (int index) {
                  todoControllerWatch.setTabIndex(index);
                },
                automaticIndicatorColorAdjustment: true,
                isScrollable: false,
                tabs: const [
                  Tab(text: 'All'), // First tab
                  Tab(text: 'Personal'), // Second tab
                  Tab(text: 'Work'), // Second tab
                  Tab(text: 'Shopping'), // Second tab
                ],
              ),
              SizedBox(height: 20.h,),

              taskList(context,_tabTodoLists[todoControllerWatch.selectedIndex],todoControllerWatch,themeControllerWatch),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: ( (context) =>const TodoAddEditScreen(isEdit: false,) )));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add_rounded,color: Colors.white,size: 32.sp,),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.r)
          ),
        ),
      ),
    );
  }


  Widget taskList(BuildContext context,List<TodoModel> cardList,TodoController todoControllerWatch,ThemeController themeControllerWatch){
    return cardList.isEmpty ? SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Center(
            child: Text("No Data Found"))) : ListView.separated(
      shrinkWrap: true,
      primary: false,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
      itemCount: cardList.length,

      itemBuilder: (context, index) {
        TodoModel todoModel = cardList[index];
        String? category = todoModel.category;
        Color color = const Color(0xFFF5E8DD);
        switch (category) {
          case 'personal':
            color = themeControllerWatch.isDarkMode ? const Color(0xFF5C5470) : const Color(0xFFF5E8DD);
            break;
          case 'work':
            color = themeControllerWatch.isDarkMode ? const Color(0xFF50727B) : const Color(0xFFAAD7D9);
            break;
          case 'shopping':
            color = themeControllerWatch.isDarkMode ? const Color(0xFF78A083) : const Color(0xFFEED3D9);
            break;
          default:
            color = themeControllerWatch.isDarkMode ? const Color(0xFF344955) : const Color(0xFFF5E8DD);
        }

        return SlideLeftAnimation(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: ( (context) =>TodoDetailScreen(todoModel:todoModel,) )));
            },
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
              child: Dismissible(
                background: Container(
                  padding: EdgeInsetsDirectional.all(10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BCF53),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w),
                    child: Icon(Icons.edit,size: 25.sp,),
                  ),
                ),
                secondaryBackground: Container(
                  padding: EdgeInsetsDirectional.all(10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC4100),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w),
                    child: Icon(Icons.delete,size: 25.sp,),
                  ),
                ),
                key: UniqueKey(),
                onDismissed: (direction) async{
                  if (direction == DismissDirection.startToEnd) {
                    /// --------For Editing todo
                    Navigator.push(context, MaterialPageRoute(builder: ( (context) =>TodoAddEditScreen(isEdit: true,todoModel:todoModel,) )));
                  } else if (direction == DismissDirection.endToStart) {
                    /// --------For Deleting todo
                    await todoControllerWatch.deleteTodo(todoModel.id ?? "");
                    Fluttertoast.showToast(
                        msg: "Task deleted successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xFFFC4100),
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsetsDirectional.all(10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:  EdgeInsetsDirectional.only(start: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(todoModel.title ?? "",style: KTextStyle.txtMedium16.copyWith(color: themeControllerWatch.isDarkMode ? Colors.white : Colors.black),),
                            Row(
                              children: [
                                Icon(Icons.date_range_rounded,size: 14.sp,),
                                SizedBox(width: 5.w,),
                                Text(todoModel.dueDate ?? "",style: KTextStyle.txtRegular14.copyWith(color: themeControllerWatch.isDarkMode ? Colors.white : Colors.black),),
                                SizedBox(width: 10.w,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(color: themeControllerWatch.isDarkMode ? Colors.white : Colors.black)
                                    // color: Theme.of(context).dividerColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 4.h),
                                    child: Text(todoModel.category ?? "",style: KTextStyle.txtRegular12.copyWith(color: themeControllerWatch.isDarkMode ? Colors.white : Colors.black),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.r,
                        child:Checkbox(
                          value: todoModel.isCompleted == 0 ? false : true,
                          side: BorderSide(color: Theme.of(context).disabledColor,width: 2.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)
                          ),
                          onChanged: (bool? value){
                            todoControllerWatch.updateCheckTodo(todoModel, value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
