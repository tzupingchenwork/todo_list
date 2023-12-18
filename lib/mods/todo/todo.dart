import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/mods/todo/todo_provider.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TodoProvider>(context, listen: false);
    provider.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '菜單',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Cat'),
              onTap: () {
                context.go('/cat');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Todo'),
              onTap: () {
                context.go('/todo');
              },
            ),
          ],
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          // 檢查是否有數據
          if (provider.todos.isEmpty) {
            return const Center(child: Text('開始建立代辦事項!'));
          }

          return ListView.builder(
            itemCount: provider.todos.length,
            itemBuilder: (context, index) {
              final todo = provider.todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditTodoDialog(context, todo);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteTodoById(todo.id!).then((_) {
                          Provider.of<TodoProvider>(context, listen: false)
                              .fetchTodos();
                        }).catchError((error) {
                          // 處理錯誤情況，例如顯示錯誤提示
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final String title = titleController.text;
                final String content = contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  final Todo newTodo = Todo(
                    title: title,
                    content: content,
                    state: 'Pending',
                  );

                  Provider.of<TodoProvider>(context, listen: false)
                      .addTodo(newTodo)
                      .then((_) {
                    Provider.of<TodoProvider>(context, listen: true)
                        .fetchTodos();
                  }).catchError((error) {
                    // 處理錯誤情況，例如顯示錯誤提示
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final TextEditingController titleController =
        TextEditingController(text: todo.title);
    final TextEditingController contentController =
        TextEditingController(text: todo.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final String updatedTitle = titleController.text;
                final String updatedContent = contentController.text;
                inspect(todo);

                if (updatedTitle.isNotEmpty && updatedContent.isNotEmpty) {
                  final Todo updatedTodo = Todo(
                    id: todo.id,
                    title: updatedTitle,
                    content: updatedContent,
                    state: todo.state,
                  );

                  Provider.of<TodoProvider>(context, listen: false)
                      .updateTodoById(todo.id!, updatedTodo)
                      .then((_) {
                    Provider.of<TodoProvider>(context, listen: true)
                        .fetchTodos();
                  }).catchError((error) {
                    // 顯示錯誤提示
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
