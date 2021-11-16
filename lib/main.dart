import 'package:flutter/material.dart';
import 'package:flutter_getx_todo/models/todo_model.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import 'controllers/todo_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            return Text(
              controller.todos.length.toString(),
            );
          },
        ),
      ),
      body: Obx(
        () {
          return ListView.builder(
            itemCount: controller.todos.length,
            itemBuilder: (c, i) => ListTile(
              trailing: IconButton(
                  onPressed: () => controller.remove(controller.todos[i]),
                  icon: const Icon(Icons.delete)),
              title: Text(
                controller.todos[i].title.toString(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => controller.add(
          Todo(id: 1, title: 'todo ${controller.todos.length + 1}'),
        ),
      ),
    );
  }
}
