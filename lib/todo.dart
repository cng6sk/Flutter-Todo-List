import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; 
import 'package:uuid/uuid.dart';


part 'todo.g.dart';


/// ============================================================
/// Todo
/// WTD：
/// 设置时间
/// 提醒时间
/// ============================================================

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

/// ============================================================
/// List<Todo>
/// ============================================================

const _uuid = Uuid(); 
@Riverpod(keepAlive: true)
class TodoList extends _$TodoList {

  @override
  List<Todo> build({required String title, required String id, bool completed = false}) {
    return [
      Todo(title: title, id: id, completed: completed),
      Todo(title: 'Set up your profile', id: '0001', completed: false),
      Todo(title: 'Add your first task', id: '0002', completed: false),
      Todo(title: 'Complete the tutorial', id: '0003', completed: false),
      Todo(title: 'Organize your workspace', id: '0004', completed: false),
      Todo(title: 'Plan your day', id: '0005', completed: false),
      Todo(title: 'Sync with your calendar', id: '0006', completed: false),
      Todo(title: 'Explore advanced features', id: '0007', completed: false),
      Todo(title: 'Make your first provider/network request', id: '0008', completed: false),
    ];
  }

  // 添加任务
  void add(String title) {
    state = [
      ...state,
      Todo(title: title, id: _uuid.v4())
    ];
  }

  // 切换任务完成状态
  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            title: todo.title,
            id: todo.id,
            completed: !todo.completed,
          )
        else
          todo,
    ];
  }

  // 编辑任务
  void edit({required String id, required String title}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            title: title,
            id: todo.id,
            completed: todo.completed,
          )
        else
          todo,
    ];
  }
}

// 一个 todoList 实例(由Provider控制)   DATA
// final todoListInit = TodoListProvider(title: "What can I say...", id: "0001", completed: true);
final todoListInit = TodoListProvider(title: "What can I say...", id: "0000");


/// ============================================================
/// TodoList筛选
/// 因为没有Notifier，所以我就直接使用Provider
/// ============================================================

// 可能筛选方式。
enum TodoListFilter {
  all,
  active,       // uncompleted
  completed,
}

// 当前激活的筛选方式
final todoListFilter = StateProvider((_) => TodoListFilter.all);

// 筛选后的待办事项列表
final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListInit);

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
  return ref.watch(todoListInit).where((todo) => !todo.completed).length;
});
