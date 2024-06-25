import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/bloc/common/common_bloc.dart';
import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/bloc/todo/todo_state.dart';
import 'package:todo_app/repository/todo/model/todo_model.dart';
import 'package:todo_app/screens/todo_add_edit_screen.dart';
import 'package:todo_app/screens/todo_detail_screen.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/utils/widgets/custom_appbar.dart';
import '../bloc/common/common_event.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart';
import '../bloc/todo/todo_event.dart';
import '../repository/todo/model/home_model.dart';
import '../utils/common_text_style.dart';
import '../utils/widgets/slide_left_animation.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      BlocProvider.of<TodoBloc>(context).add(HomePageDataLoadedEvent());
    });
  }
  @override
  Widget build(BuildContext context) {

    final todoBloc = BlocProvider.of<TodoBloc>(context);
    final commonBloc = BlocProvider.of<CommonBloc>(context);
    // todoBloc.add(HomePageDataLoadedEvent());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'TODO',hasLeading: false,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: ( (context) =>const TodoAddEditScreen(isEdit: false,) )));
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r)
        ),
        child: Icon(Icons.add_rounded,color: Colors.white,size: 32.sp,),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          log("state $state");
          if (state is HomePageDataLoaded) {
            log("heyyyyyyyyy");
            HomeModel homeModel = state.homeData;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    Text("Hello",style: KTextStyle.txtMedium18,),
                    Text("You have work today",style: KTextStyle.txtRegular12.copyWith(color: Colors.blueGrey),),
                    SizedBox(height: 20.h,),
                    categoryTaskGrid(homeModel,commonBloc),
                    SizedBox(height: 20.h,),
                    Text("Today's Due Task",style: KTextStyle.txtMedium18.copyWith(color: Colors.blueGrey),),
                    SizedBox(height: 20.h,),
                    dueTodayTaskList(context,homeModel.todayDueDateList ?? [],todoBloc),
                  ],
                ),
              ),
            );
          } else if (state is TodoError) {
            return const Center(child: Text("Failed to load todos"));
          } else {
            return const Center(child: Text("Loading Todos"));
          }
        },
      ),
    );
  }
}

Widget dueTodayTaskList(BuildContext context, List<TodoModel> cardList, TodoBloc todoBloc) {
  return cardList.isEmpty
      ?
  SizedBox(
    width: MediaQuery.of(context).size.width,
    child: const Center(child: Text("No Data Found")),
  )
      :
  BlocBuilder<ThemeBloc,ThemeState>(
      builder: (context,themeState){
        bool isDarkMode = false;
        if(themeState is ThemeLoaded){
          isDarkMode = themeState.isDarkMode;
        }
        return ListView.separated(
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
                color = isDarkMode
                    ? const Color(0xFF5C5470)
                    : const Color(0xFFF5E8DD);
                break;
              case 'work':
                color = isDarkMode
                    ? const Color(0xFF50727B)
                    : const Color(0xFFAAD7D9);
                break;
              case 'shopping':
                color = isDarkMode
                    ? const Color(0xFF78A083)
                    : const Color(0xFFEED3D9);
                break;
              default:
                color = isDarkMode
                    ? const Color(0xFF344955)
                    : const Color(0xFFF5E8DD);
            }

            return SlideLeftAnimation(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              TodoDetailScreen(todoModel: todoModel))));
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
                        child: Icon(
                          Icons.edit,
                          size: 25.sp,
                        ),
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
                        child: Icon(
                          Icons.delete,
                          size: 25.sp,
                        ),
                      ),
                    ),
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        /// --------For Editing todos
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => TodoAddEditScreen(
                                  isEdit: true,
                                  todoModel: todoModel,
                                ))));
                      } else if (direction == DismissDirection.endToStart) {
                        /// --------For Deleting todos
                        // await todoControllerWatch.deleteTodo(todoModel.id ?? "");
                        todoBloc.add(DeleteTodoEvent(todoModel.id ?? ""));
                        Fluttertoast.showToast(
                            msg: "Task deleted successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color(0xFFFC4100),
                            textColor: Colors.white,
                            fontSize: 16.0);
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
                            padding: EdgeInsetsDirectional.only(start: 15.w),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: Text(
                                    todoModel.title ?? "",
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                    style: KTextStyle.txtMedium16.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.date_range_rounded,
                                      size: 14.sp,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      todoModel.dueDate ?? "",
                                      style: KTextStyle.txtRegular14.copyWith(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.r),
                                          border: Border.all(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black)
                                        // color: Theme.of(context).dividerColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        child: Text(
                                          todoModel.category ?? "",
                                          style: KTextStyle.txtRegular12
                                              .copyWith(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
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
                            child: Checkbox(
                              value: todoModel.isCompleted == 0 ? false : true,
                              side: BorderSide(
                                  color: Theme.of(context).disabledColor,
                                  width: 2.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20.r)),
                              onChanged: (bool? value) {
                                // todoControllerWatch.updateCheckTodo(todoModel, value!);
                                todoBloc.add(UpdateCheckTodoEvent(todoModel, value!));
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
      });
}

Widget categoryTaskGrid(HomeModel? homeModel,CommonBloc commonBloc){
  const colorIconList = [
    {
      "color":0xffFFC96F,
      "icon":Icons.timer,
      "title":"Today",
    },
    {
      "color":0xffACD793,
      "icon":Icons.access_time_filled_rounded,
      "title":"Scheduled",
    },
    {
      "color":0xff68D2E8,
      "icon":Icons.cached_rounded,
      "title":"All",
    },
    {
      "color":0xffFF70AB,
      "icon":Icons.timelapse_rounded,
      "title":"Overdue",
    },
  ];
  return GridView.builder(
    itemCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      childAspectRatio: 1.5
  ),
    itemBuilder: (context, index) {
      List<TodoModel>? todoList;
      int count = 0;
      switch (index) {
        case 0:
          count = homeModel?.todayCount ?? 0;
          todoList = homeModel?.todayDueDateList ?? [];
          break;
        case 1:
          count = homeModel?.scheduledCount ?? 0;
          todoList = homeModel?.scheduledTasksList ?? [];
          break;
        case 2:
          count = homeModel?.allCount ?? 0;
          todoList = homeModel?.allTasksList ?? [];
          break;
        case 3:
          count = homeModel?.overDueCount ?? 0;
          todoList = homeModel?.overDueTasksList ?? [];
          break;
        default:
          count = 0;
      }
      return InkWell(
        onTap: (){
          commonBloc.add(const SetTabIndexEvent(0));
          Navigator.push(context, MaterialPageRoute(builder: ( (context) => TodoListScreen(title: colorIconList[index]["title"].toString(),todoList: todoList ?? [],) )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color(colorIconList[index]["color"] as int),
              borderRadius: BorderRadiusDirectional.circular(10.r)
          ),
          padding: EdgeInsetsDirectional.all(10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.r,
                child:Icon(colorIconList[index]["icon"] as IconData,color: Color(colorIconList[index]["color"] as int),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(colorIconList[index]["title"].toString(),style: KTextStyle.txtRegular16,),
                  Text("$count",style: KTextStyle.txtMedium16,)
                ],
              )
            ],),
        ),
      ); // Customize item content
    },
  );
}
