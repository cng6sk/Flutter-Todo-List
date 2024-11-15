import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_todolist/uiElements/appBars.dart';
import 'package:flutter_todolist/utils/CustomColors.dart';
import 'package:flutter_todolist/todo.dart';


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
      return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.015, 0.015],
                      colors: [CustomColors.greenIcon, Colors.white],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    boxShadow: [
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
                      GestureDetector(
                        onTap: () {
                          // 切换任务完成状态
                          ref.read(todoListInit.notifier).toggle(todo.id);
                        },
                        child: Image.asset(
                          todo.completed
                              ? 'assets/images/checked.png'
                              : 'assets/images/checked-empty.png',
                        ),
                      ),
                      const Text(
                        '13.00 PM', // 示例时间
                        style: TextStyle(color: CustomColors.textGrey),
                      ),
                      SizedBox(
                        width: 180,
                        child: Text(
                          todo.title,
                          style: TextStyle(
                            color: CustomColors.textHeader,
                            fontWeight: FontWeight.w600,
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      Image.asset('assets/images/bell-small.png'),
                    ],
                  ),
                );
              },
            );
    }
  }

}

// Container(
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//           scrollDirection: Axis.vertical,
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   Text(
//                     '13.00 PM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   Container(
//                     width: 180,
//                     child: Text(
//                       'Email client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.greenIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//             ),
//           ]
//         ),
//       );