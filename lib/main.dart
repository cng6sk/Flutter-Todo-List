import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:logger/logger.dart';


import 'package:flutter_todolist/gui/home.dart';
// import 'package:flutter_todolist/providers.dart';
// import 'package:flutter_todolist/todo.dart';

/// Keys for components for testing
final bottomNavigationBarKey = UniqueKey();
final addTodoKey = UniqueKey();
final logger = Logger();

// coverage:ignore-start
void main() {
  runApp(const ProviderScope(child: App()));
}
// coverage:ignore-end

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}






