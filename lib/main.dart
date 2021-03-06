import 'package:flutter/material.dart';
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
        title: const Text('Lime test'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => controller.connect(),
                child: const Text('Connect'),
              ),
              TextButton(
                onPressed: () => controller.disconnect(),
                child: const Text('Disconnect'),
              ),
              TextButton(
                onPressed: () => controller.sendCommand1(),
                child: const Text('Send command'),
              ),
              TextButton(
                onPressed: () => controller.sendCommand2(),
                child: const Text('Send command 2'),
              ),
              TextButton(
                onPressed: () => controller.sendMessage(),
                child: const Text('Send Message'),
              ),
              Obx(
                () {
                  return Text(
                    controller.status.value,
                  );
                },
              ),
              const SizedBox(
                height: 100,
              ),
              Obx(() => Text(controller.state.value)),
              const SizedBox(
                height: 100,
              ),
              Obx(() => Text(controller.message.value)),
            ],
          ),
        ),
      ),
    );
  }
}
