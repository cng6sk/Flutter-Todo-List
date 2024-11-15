// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListHash() => r'd5e3925c596256c0a65c0d06b93542ebfebca151';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TodoList extends BuildlessNotifier<List<Todo>> {
  late final String title;
  late final String id;
  late final bool completed;

  List<Todo> build({
    required String title,
    required String id,
    bool completed = false,
  });
}

/// See also [TodoList].
@ProviderFor(TodoList)
const todoListProvider = TodoListFamily();

/// See also [TodoList].
class TodoListFamily extends Family<List<Todo>> {
  /// See also [TodoList].
  const TodoListFamily();

  /// See also [TodoList].
  TodoListProvider call({
    required String title,
    required String id,
    bool completed = false,
  }) {
    return TodoListProvider(
      title: title,
      id: id,
      completed: completed,
    );
  }

  @override
  TodoListProvider getProviderOverride(
    covariant TodoListProvider provider,
  ) {
    return call(
      title: provider.title,
      id: provider.id,
      completed: provider.completed,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todoListProvider';
}

/// See also [TodoList].
class TodoListProvider extends NotifierProviderImpl<TodoList, List<Todo>> {
  /// See also [TodoList].
  TodoListProvider({
    required this.title,
    required this.id,
    this.completed = false,
  }) : super.internal(
          () => TodoList()
            ..title = title
            ..id = id
            ..completed = completed,
          from: todoListProvider,
          name: r'todoListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$todoListHash,
          dependencies: TodoListFamily._dependencies,
          allTransitiveDependencies: TodoListFamily._allTransitiveDependencies,
        );

  final String title;
  final String id;
  final bool completed;

  @override
  bool operator ==(Object other) {
    return other is TodoListProvider &&
        other.title == title &&
        other.id == id &&
        other.completed == completed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, completed.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<Todo> runNotifierBuild(
    covariant TodoList notifier,
  ) {
    return notifier.build(
      title: title,
      id: id,
      completed: completed,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
