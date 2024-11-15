import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Todo {
  const Todo({
    required this.title,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String title;
  final bool completed;
}


const _uuid = Uuid(); 

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  // 添加
  void add(String title) {
    state = [
      ...state,
      Todo(title: title, id: _uuid.v4())
    ];
  }

  void toggle(String id) {
    final newState = [...state];
    final todoReplaceIndex = state.indexWhere((todo) => todo.id == id);

    if (todoReplaceIndex != -1) {
      newState[todoReplaceIndex] = Todo(
        title: newState[todoReplaceIndex].title, 
        id: newState[todoReplaceIndex].id,
        completed: !newState[todoReplaceIndex].completed
      );
    }

    state = newState;
  }

  void edit({required String id, required String title}) {
    final newState = [...state];
    final todoReplaceIndex = state.indexWhere((todo) => todo.id == id);

    if (todoReplaceIndex != -1) {
      newState[todoReplaceIndex] = Todo(
        title: title, 
        id: newState[todoReplaceIndex].id,
        completed: newState[todoReplaceIndex].completed
      );
    }

    state = newState;
  }

}


final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>(
  (ref) {
    return TodoList(const [
      Todo(id: '0', title: 'hey there :)'),
    ]);
  }
);

/// 可能筛选方式。
enum TodoListFilter {
  all,
  active,       // uncompleted
  completed,
}

/// 当前激活的筛选方式。
final todoListFilter = StateProvider((_) => TodoListFilter.all);

/// 筛选后的待办事项列表。
final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});

// 未完成的待办事项数量
final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});
