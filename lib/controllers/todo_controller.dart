import 'dart:async';
import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:lime/lime.dart' as lime;
import 'package:blip_sdk/blip_sdk.dart' as blip_sdk;

class TodoController extends GetxController {
  var status = "".obs;
  late blip_sdk.Client sdkClient;

  final sessionFinishedHandler = StreamController<lime.Session>();

  TodoController() {
    blip_sdk.ClientBuilder sdkClientBuilder =
        blip_sdk.ClientBuilder(transport: lime.TCPTransport()).withApplication(
      blip_sdk.Application(
        hostName: 'contrato-test-msqz9.hmg-ws.msging.net',
        identifier: 'andrehumano',
        domain: 'msging.net',
        instance: '!desk',
        authentication:
            lime.KeyAuthentication(key: 'eERTalhFc3gzSkgxc0hXdUNGeTM='),
      ),
    );

    sdkClient = sdkClientBuilder.build();

    sdkClient.addSessionFinishedHandlers(sessionFinishedHandler);

    sessionFinishedHandler.stream.listen((session) {
      print('event received successfully');
    });
  }

  connect() {
    sdkClient.connect();
  }

  disconnect() {
    sdkClient.close();
  }

  sendCommand1() async {
    try {
      final ret = await sdkClient.sendCommand(
        lime.Command(method: lime.CommandMethod.get, uri: '/account'),
      );

      status.value = (jsonEncode(ret.resource));
    } on Error catch (e) {
      print('erro ao enviar comando: $e');
    }
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
