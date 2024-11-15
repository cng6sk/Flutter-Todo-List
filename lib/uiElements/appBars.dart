import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


import 'package:flutter_todolist/utils/CustomColors.dart';
import 'package:flutter_todolist/todo.dart';


PreferredSizeWidget blueAppbar(WidgetRef ref) {
  final uncompletedCount = ref.watch(uncompletedTodosCount);
  return PreferredSize(
    preferredSize: const Size.fromHeight(75.0),
    child: GradientAppBar(
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomPaint(
            painter: CirclePainter(
              center: const Offset(28.0, 0.0), 
              radius: 99.0, 
              color: CustomColors.headerCircle
            ),
          ),
          CustomPaint(
            painter: CirclePainter(
              center: const Offset(-30, 20), 
              radius: 50.0, 
              color: CustomColors.headerCircle
            ),
          ),
        ],
      ),
      title: Container(
        margin: const EdgeInsets.only(top: 20),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              uncompletedCount == 0 
              ? 'Well Done.' 
              : 'You have $uncompletedCount task${uncompletedCount == 1 ? '' : 's'}.',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      elevation: 0,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [CustomColors.headerBlueDark, CustomColors.headerBlueLight],
      ),
    ),
  );
}


class CirclePainter extends CustomPainter {
  final Offset center; // 圆心位置
  final double radius; // 圆的半径
  final Color color;   // 圆的颜色

  // 构造函数接受圆心坐标、半径和颜色作为参数
  CirclePainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 使用传入的参数绘制圆
    Paint _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}