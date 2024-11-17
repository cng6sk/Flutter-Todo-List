import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; 
import 'package:uuid/uuid.dart';


part 'todo.g.dart';


/// ============================================================
/// XXX Due Date 设置到期时间/提醒时间(可能完成了，但是好像还差一点)
/// TODO Completed At 任务完成的时间(已完成的排序)
/// TODO tag 添加标签
/// TODO Priority 设置优先级
/// TODO Subtasks 创建多个子任务
/// ============================================================

enum Priority {
  lowest, 
  low, 
  medium, 
  high, 
  highest 
}

@immutable
class Todo {
  const Todo({
    required this.title,
    required this.id,
    this.completed = false,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    this.priority = Priority.medium,
    this.subTasks = const [],
  });


  final String id;
  final String title;
  final bool completed;
  final DateTime? dueDate; 
  final DateTime? completedAt;
  final List<String> tags;
  final Priority priority;
  final List<SubTodo> subTasks;
}

@immutable
class SubTodo {
  const SubTodo({
    required this.title,
    required this.id,
    this.completed = false,
    this.dueDate,
  });

  final String id;
  final String title;   
  final bool completed;
  final DateTime? dueDate; 
}

/// ============================================================
/// List<Todo>
/// ============================================================

const _uuid = Uuid(); 
@Riverpod(keepAlive: true)
class TodoList extends _$TodoList {

  @override
  List<Todo> build({required String title, required String id, bool completed = false}) {
    // XXX: for test
    return [
      Todo(title: title, id: id, completed: completed),
      Todo(
        title: 'Set up your profile', id: '0001', 
        completed: false, dueDate: DateTime(2024, 12, 31, 11, 00),
      ),
      Todo(
        title: 'Add your first task', id: '0002', 
        completed: false, dueDate: DateTime(2024, 11, 17, 23, 00),
      ),
      Todo(
        title: 'Complete the tutorial', id: '0003', 
        completed: false, dueDate: DateTime(2024, 11, 17, 22, 00),
      ),
      Todo(
        title: 'Organize your workspace', id: '0004', 
        completed: false, dueDate: DateTime(2024, 11, 16, 23, 00),
      ),
      Todo(title: 'Plan your day', id: '0005', completed: false),
      Todo(title: 'Sync with your calendar', id: '0006', completed: false),
      Todo(title: 'Explore advanced features', id: '0007', completed: false),
      Todo(title: 'Make your first provider/network request', id: '0008', completed: false),
    ];
  }

  // 添加任务
  void add({
    required String title,
    DateTime? dueDate,
    List<String> tags = const [],
    Priority priority = Priority.medium,
    List<SubTodo> subTasks = const [],
  }) {
    state = [
      ...state,
      Todo(
        title: title,
        id: _uuid.v4(),
        dueDate: dueDate,
        tags: tags,
        priority: priority,
        subTasks: subTasks,
      ),
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
            dueDate: todo.dueDate,
            completedAt: !todo.completed ? DateTime.now() : null,
            tags: todo.tags,
            priority: todo.priority,
            subTasks: todo.subTasks,
          )
        else
          todo,
    ];
  }

  // 编辑任务
  void edit({
    required String id,
    String? title,
    DateTime? dueDate,
    List<String>? tags,
    Priority? priority,
    List<SubTodo>? subTasks,
  }) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            title: title ?? todo.title, 
            id: todo.id,
            completed: todo.completed,
            dueDate: dueDate ?? todo.dueDate, 
            completedAt: todo.completedAt,
            tags: tags ?? todo.tags, 
            priority: priority ?? todo.priority, 
            subTasks: subTasks ?? todo.subTasks, 
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
/// 需要激活的TodoList筛选
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
