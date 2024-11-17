import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_todolist/uiElements/appBars.dart';
import 'package:flutter_todolist/utils/CustomColors.dart';
import 'package:flutter_todolist/todo.dart';
import 'package:flutter_todolist/utils/date.dart';

// TODO: 添加按钮
// TODO: 删除按钮
class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uncompletedCount = ref.watch(uncompletedTodosCount);
    return Scaffold(
      appBar: blueAppbar(ref),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: _buildBody(context, uncompletedCount, ref),
      ),
    );
  }

  Widget _buildBody(BuildContext context, int uncompletedCount, WidgetRef ref) {
    if (uncompletedCount == 0) {
      // empty
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,  // Same as Container but more semantically correct
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Hero(
                  tag: 'Clipboard',
                  child: Image.asset('assets/images/Clipboard-empty.png'),
                ),
              ),
              const Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Text(
                      'No tasks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.textHeader,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'You have no tasks to do.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: CustomColors.textBody,
                        fontFamily: 'opensans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 1,          // Using SizedBox for an empty space
                child: SizedBox(),  
              )
            ],
          ),
        ),
      );
    } else {
      // have todo item
      final todos = ref.watch(todoListInit);
      final categorizedTodos = categorizeTodos(todos);
      final todoWidgets = buildTodoList(categorizedTodos, ref);
      
      return ListView(
        children: todoWidgets,
      );
    }
  }

  Map<String, List<Todo>> categorizeTodos(List<Todo> todos) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    final categorized = {
      '已过期': <Todo>[],
      '今天': <Todo>[],
      '明天': <Todo>[],
      '接下来一周': <Todo>[],
      '更久的未来': <Todo>[],
      '无日期': <Todo>[],
    };

    for (final todo in todos) {
      if (todo.dueDate == null) {
        categorized['无日期']!.add(todo);
      } else if (todo.dueDate!.isBefore(today)) {
        categorized['已过期']!.add(todo);
      } else if (todo.dueDate!.isSameDay(today)) {
        categorized['今天']!.add(todo);
      } else if (todo.dueDate!.isSameDay(tomorrow)) {
        categorized['明天']!.add(todo);
      } else if (todo.dueDate!.isAfter(today) && todo.dueDate!.isBefore(nextWeek)) {
        categorized['接下来一周']!.add(todo);
      } else {
        categorized['更久的未来']!.add(todo);
      }
    }

    return categorized;
  }

  List<Widget> buildTodoList(Map<String, List<Todo>> categorizedTodos, WidgetRef ref) {
    final widgets = <Widget>[];
    categorizedTodos.forEach((category, todos) {
      if (todos.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.textHeader,
              ),
            ),
          ),
        );

        widgets.addAll(todos.map((todo) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.015, 0.015],
                colors: category == '已过期' && !todo.completed
                  ? [Colors.red, Colors.white] // 已过期未完成时，渐变红色
                  : [CustomColors.greenIcon, Colors.white]
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: CustomColors.greyBorder,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(width: 12.0),
                GestureDetector(
                  onTap: () {
                    // toggle
                    ref.read(todoListInit.notifier).toggle(todo.id);
                  },
                  child: Image.asset(
                    todo.completed
                        ? 'assets/images/checked.png'
                        : 'assets/images/checked-empty.png',
                  ),
                ),
                const SizedBox(width: 3.0),
                SizedBox(
                  width: 80, // 确保时间的宽度一致
                  child: Text(
                    formatDateForCategory(category, todo.dueDate),
                    style: TextStyle(
                      color: category == '已过期' && !todo.completed ? Colors.red : CustomColors.textGrey, 
                    ),
                    textAlign: TextAlign.center, // 确保文本居中
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded( 
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      color: category == '已过期' && !todo.completed ? Colors.red : CustomColors.textHeader, 
                      fontWeight: FontWeight.w600,
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    
                  ),
                ),
                const SizedBox(width: 10.0),
                Image.asset('assets/images/bell-small.png'),
                const SizedBox(width: 8.0),
              ],
            ),
          );
        }).toList());
      }
    });
    return widgets;
  }

  String formatDateForCategory(String category, DateTime? dueDate) {
    if (dueDate == null) {
      return ''; // 无日期时返回空字符串
    }

    if (category == '今天') {
      return '${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')} ${dueDate.hour >= 12 ? 'PM' : 'AM'}';
    } else if (category == '明天') {
      return '${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')} ${dueDate.hour >= 12 ? 'PM' : 'AM'}';
    } else {
      // 对于其他分类，返回日期
      return '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
    }
  }

}