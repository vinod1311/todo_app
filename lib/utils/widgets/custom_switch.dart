import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final bool value;
  final Function onChanged;
  final IconData activeIcon;
  final IconData inactiveIcon;

  const CustomToggleButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.activeIcon,
    required this.inactiveIcon,
  }) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    final Color activeColor = Theme.of(context).colorScheme.onSurface;
    final Color inactiveColor = Theme.of(context).disabledColor;

    return InkWell(
      onTap: (){
        widget.onChanged();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: widget.value
            ? Icon(
          widget.activeIcon,
          color: activeColor,
          size: 24.0, // Adjust icon size
        )
            : Icon(
          widget.inactiveIcon,
          color: inactiveColor,
          size: 24.0, // Adjust icon size
        ),
      ),
    );

  }
}
