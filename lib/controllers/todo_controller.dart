import 'dart:convert';

import 'package:flutter_getx_todo/sdk/sdk_client.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:lime/network/tcp_transport.dart';
import 'package:lime/protocol/command.dart';
import 'package:lime/protocol/enums/command_method.enum.dart';
import 'package:lime/protocol/node.dart' as limeNode;

class TodoController extends GetxController {
  var status = "".obs;

  final sdkClient = SDKClient(
      TCPTransport(uri: 'wss://contrato-test-msqz9.hmg-ws.msging.net'));

  connect() {
    sdkClient.connect();
  }

  disconnect() {
    sdkClient.close();
  }

  sendCommand1() async {
    final Command c = Command(method: CommandMethod.get, uri: '/account');
    final ret = await sdkClient.sendCommand(c);
    status.value = (jsonEncode(ret.resource));
  }

  sendCommand2() async {
    final Command c = Command(
        method: CommandMethod.get,
        uri: '/agents/owners',
        to: limeNode.Node.parse('postmaster@desk.msging.net'));
    final ret = await sdkClient.sendCommand(c);
    status.value = (jsonEncode(ret.resource));
  }
}
