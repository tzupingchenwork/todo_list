import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class Todo {
  final String? id;
  final String title;
  final String content;
  final String state;

  Todo(
      {this.id,
      required this.title,
      required this.content,
      required this.state});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'state': state,
      };
}

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    final response =
        await http.get(Uri.parse('http://192.168.12.111:3000/todos'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _todos = data.map<Todo>((json) => Todo.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse('http://192.168.12.111:3000/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todo.toJson()),
    );
    bool isOk(int statusCode) => 200 <= statusCode && statusCode < 300;
    if (isOk(response.statusCode)) {
      _todos.add(todo);

      notifyListeners();
    } else {
      throw Exception('Failed to add todo');
    }
  }

  // 這裡可以添加刪除和更新方法
  Future<void> deleteTodoById(String id) async {
    inspect(id);
    final response =
        await http.delete(Uri.parse('http://192.168.12.111:3000/todos/$id'));
    bool isOk(int statusCode) => 200 <= statusCode && statusCode < 300;
    if (isOk(response.statusCode)) {
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  Future<void> updateTodoById(String id, Todo todo) async {
    inspect(todo);
    final response = await http.patch(
      Uri.parse('http://192.168.12.111/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todo.toJson()),
    );
    bool isOk(int statusCode) => 200 <= statusCode && statusCode < 300;
    if (isOk(response.statusCode)) {
      _todos[_todos.indexWhere((todo) => todo.id == id)] = todo;
      notifyListeners();
    } else {
      throw Exception('Failed to update todo');
    }
  }
}
