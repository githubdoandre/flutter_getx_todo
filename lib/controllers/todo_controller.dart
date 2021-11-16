import 'package:flutter_getx_todo/models/todo_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  RxList todos = [].obs;

  void add(Todo todo) {
    todos.add(todo);
  }

  void remove(Todo todo) {
    todos.remove(todo);
  }
}
