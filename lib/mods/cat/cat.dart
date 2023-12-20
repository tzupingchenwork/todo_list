import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const Cat());

class Cat extends StatelessWidget {
  const Cat({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '貓貓',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('貓貓'),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        body: const ImageDisplayPage(),
      ),
    );
  }
}

class ImageDisplayPage extends StatelessWidget {
  const ImageDisplayPage({Key? key}) : super(key: key);
  final String imageUrl = 'http://192.168.12.111:3000/cat';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(imageUrl),
    );
  }
}
