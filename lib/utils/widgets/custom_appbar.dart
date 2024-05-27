import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/theme_controller.dart';
import 'package:todo_app/utils/widgets/custom_switch.dart';

import '../common_text_style.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;
  final Widget? leading;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasLeading = true,
    this.leading,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  ThemeController themeControllerWatch = ThemeController();
  @override
  Widget build(BuildContext context) {
    themeControllerWatch = context.watch<ThemeController>();
    return AppBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: true,
      automaticallyImplyLeading: widget.hasLeading,
      leading: widget.leading,
      title: Text(widget.title.toUpperCase(),style: KTextStyle.txtMedium14,),
      actions: [
        CustomToggleButton(
          value: themeControllerWatch.isDarkMode,
          inactiveIcon: Icons.light_mode_rounded,
          activeIcon: Icons.dark_mode_rounded,
          onChanged: (){
            themeControllerWatch.toggleTheme();
          },
        ),
        SizedBox(width: 10.w,)
      ],
    );
  }
}
