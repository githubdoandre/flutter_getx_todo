import 'package:flutter_getx_todo/models/todo_model.dart';
import 'package:flutter_getx_todo/sdk/sdk_client.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:lime/network/tcp_transport.dart';

class TodoController extends GetxController {
  var status = "".obs;

  final sdkClient =
      SDKClient(TCPTransport(uri: 'contrato-test-msqz9.hmg-ws.msging.net'));

  connect() {
    sdkClient.connect();
  }

  disconnect() {
    sdkClient.close();
  }
}
