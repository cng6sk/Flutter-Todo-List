import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;
}


const _uuid = Uuid(); 

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  // 添加
  void add(String description) {
    state = [
      ...state,
      Todo(description: description, id: _uuid.v4())
    ];
  }

  void toggle(String id) {
    final newState = [...state];
    final todoReplaceIndex = state.indexWhere((todo) => todo.id == id);

    if (todoReplaceIndex != -1) {
      newState[todoReplaceIndex] = Todo(
        description: newState[todoReplaceIndex].description, 
        id: newState[todoReplaceIndex].id,
        completed: !newState[todoReplaceIndex].completed
      );
    }

    state = newState;
  }

  void edit({required String id, required String description}) {
    final newState = [...state];
    final todoReplaceIndex = state.indexWhere((todo) => todo.id == id);

    if (todoReplaceIndex != -1) {
      newState[todoReplaceIndex] = Todo(
        description: description, 
        id: newState[todoReplaceIndex].id,
        completed: newState[todoReplaceIndex].completed
      );
    }

    state = newState;
  }

}