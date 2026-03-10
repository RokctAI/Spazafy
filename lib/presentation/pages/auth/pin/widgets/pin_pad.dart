import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venderfoodyman/presentation/styles/style.dart';
import 'package:venderfoodyman/presentation/component/components.dart';

class PinPad extends StatelessWidget {
  final Function(String) onTap;
  final VoidCallback onDelete;

  const PinPad({super.key, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row in [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ])
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var num in row)
                  _PinButton(
                    text: num.toString(),
                    onTap: () => onTap(num.toString()),
                  ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 80),
            _PinButton(text: '0', onTap: () => onTap('0')),
            _PinButton(
              icon: Icons.backspace_outlined,
              onTap: onDelete,
              isDelete: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _PinButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isDelete;

  const _PinButton({
    this.text,
    this.icon,
    required this.onTap,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonsBouncingEffect(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 70.r,
          height: 70.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDelete ? AppStyle.transparent : AppStyle.white,
            border: isDelete ? null : Border.all(color: AppStyle.borderColor),
          ),
          child: Center(
            child: text != null
                ? Text(text!, style: AppStyle.interBold(size: 24))
                : Icon(icon, size: 24.r, color: AppStyle.black),
          ),
        ),
      ),
    );
  }
}
