import 'dart:async';
import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:lime/lime.dart' as lime;
import 'package:blip_sdk/blip_sdk.dart' as blip_sdk;

class TodoController extends GetxController {
  final state = lime.SessionState.isNew.toString().obs;
  final status = "".obs;
  late blip_sdk.Client sdkClient;

  final message = ''.obs;

  final sessionFinishedHandler = StreamController<lime.Session>();
  final onMessageListener = StreamController<lime.Message>();
  void Function()? onRemoveMessageListener;

  TodoController() {
    blip_sdk.ClientBuilder sdkClientBuilder = blip_sdk.ClientBuilder(transport: lime.TCPTransport())
        .withIdentifier('leonardo.gabriel%40take.net')
        .withEcho(false)
        .withNotifyConsumed(false)
        .withDomain('blip.ai')
        .withHostName('contrato-test-msqz9.hmg-ws.blip.ai')
        .withInstance('!desk')
        .withToken(
            'eyJhbGciOiJSUzI1NiIsImtpZCI6IjRlY2RmZmViNjJlYjA0ZWYwMzE1OWI0OGZiNTNiZGZjIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2NDYxNDAwMDUsImV4cCI6MTY0NjIyNjQwNSwiaXNzIjoiaHR0cHM6Ly9obWctYWNjb3VudC5ibGlwLmFpIiwiYXVkIjoiaHR0cHM6Ly9obWctYWNjb3VudC5ibGlwLmFpL3Jlc291cmNlcyIsImNsaWVudF9pZCI6ImJsaXAtZGVzayIsInN1YiI6ImVlMTU5ODQyLTAxYjQtNDFkZC04OWJiLTExMjhlYmQ4MWVjNSIsImF1dGhfdGltZSI6MTY0NjEzNzYyNiwiaWRwIjoiZ29vZ2xlIiwiUHJvdmlkZXJEaXNwbGF5TmFtZSI6Imdvb2dsZSIsIkZ1bGxOYW1lIjoiTGVvbmFyZG8gR2FicmllbCIsIlVzZXJOYW1lIjoibGVvbmFyZG8uZ2FicmllbEB0YWtlLm5ldCIsImN1bHR1cmUiOiJwdC1CUiIsIkNyZWF0ZWRCeU5ld0FjY291bnRSZWdpc3RlciI6IkZhbHNlIiwiRW1haWwiOiJsZW9uYXJkby5nYWJyaWVsQHRha2UubmV0IiwiRW1haWxDb25maXJtZWQiOiJUcnVlIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsImVtYWlsIl0sImFtciI6WyJleHRlcm5hbCJdfQ.tVO3e4XWCkCMz2nCh50QBT69zQSCOD2ryxpEcQlwBeXufsztc8me2P3whED19DdI_EFc_339iVAb5ISnk6Li9MmgL1btzlOSBSKbrB0fvHFoLFED66SME2qcrkeCqqj1Dm4Q17zaBxi_ilsMU_LwSZhRZQKhlN8IdQp2LfzsX3NVNlmGR0qpabKs3ysv0TCqBQWg6LUs1UoDEBjpMHpnBjR7IE4sCUMUSt-KR6BlxUfh20z-VrM-_jGQUTYIaHoYafg6cMP2oR_0Qdfnf-DXRKlYqcypH6tN1S1A4tYMIcKLBKlrBJo0dFfD0ToeT5RlwfkOneHeN932AiZkFgNu0IglupavSgiYWVeQSNv0CZaRVklPsIznWFMSH2VL4Qb_UYeiEIsLVcxJnUvJTmfYUEe7PuEd4AV4qW_9wmXi6ZkSjNgN29_MAxDoIpa1PAlXY_-mDw7EhCI1y-fPqLu9btgHOfJCLiqYmpoGqq_3TEsx8agy-0OuCibvruGWUHWBGPmnLoS0MRj8-h8m9ohTRBL8_SS3YBerAqx2eZO6M1PlTNtgbA7jdrRqLqyTWA9Ah2SxZXNKkFTu3FW51KlW4h0rtbioaTbajErWVLbwAOUDnW8ysOqhPtNrRPQs5-6A6gayaLpbTBgHa4zDyMSNZ-RwgAbobrU1g9WO8PfCoqk',
            'account.blip.ai');

    sdkClient = sdkClientBuilder.build();

    sdkClient.addSessionFinishedHandlers(sessionFinishedHandler);

    onRemoveMessageListener = sdkClient.addMessageListener(onMessageListener);

    _initListeners();
  }

  _initListeners() {
    onMessageListener.stream.listen((message) {
      print('Message Received on Dart SDK: $message');

      this.message.value = message.content.toString();
    });

    sessionFinishedHandler.stream.listen((session) {
      print('event received successfully');
    });
  }

  connect() async {
    final result = await sdkClient.connect();

    state.value = result.state.toString();
  }

  disconnect() async {
    final result = await sdkClient.close();

    state.value = result?.state?.toString() ?? '';
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

  sendMessage() {
    sdkClient.sendMessage(lime.Message(
      to: lime.Node.parse('9c7cf250-6a56-42ee-94df-017f4583c958@desk.msging.net/Lime'),
      type: 'text/plain',
      content: "Hello! This is a message sent using our new Dart SDK!",
    ));
  }
}
