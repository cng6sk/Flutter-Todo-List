import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todolist/todo.dart';

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>(
  (ref) {
    return TodoList(const [
      Todo(id: '0', description: 'hey there :)'),
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
