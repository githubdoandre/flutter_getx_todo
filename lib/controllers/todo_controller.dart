import 'dart:convert';

import 'package:flutter_getx_todo/sdk/sdk_client.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:lime/lime.dart' as lime;

class TodoController extends GetxController {
  var status = "".obs;

  final sdkClient = SDKClient(lime.TCPTransport());

  connect() {
    sdkClient.connect();
  }

  disconnect() {
    sdkClient.close();
  }

  sendCommand1() async {
    final ret = await sdkClient.sendCommand(
      lime.Command(method: lime.CommandMethod.get, uri: '/account'),
    );
    status.value = (jsonEncode(ret.resource));
  }

  sendCommand2() async {
    final ret = await sdkClient.sendCommand(
      lime.Command(
        method: lime.CommandMethod.get,
        uri: '/tickets',
        to: lime.Node.parse('postmaster@desk.msging.net'),
      ),
    );
    status.value = (jsonEncode(ret.resource));
  }
}
