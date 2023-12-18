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
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // 這裡添加刪除Todo的邏輯
                  },
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
                    // 可以在這裡處理成功添加後的邏輯，例如顯示提示或更新界面
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
}
