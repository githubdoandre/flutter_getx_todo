import 'dart:async';

import 'package:lime/lime.dart';
import 'package:lime/network/transport.dart';
import 'package:lime/security/key_authentication.dart';

class SDKClient extends ClientChannel {
  SDKClient(Transport transport) : super(transport);

  final List<Map<String, dynamic>> _commandResolves = [];

  connect() async {
    await open();

    final keyAuthentication = KeyAuthentication();
    keyAuthentication.key = 'eERTalhFc3gzSkgxc0hXdUNGeTM=';

    await establishSession(
        'andrehumano@msging.net', '!desk', keyAuthentication);

    await _sendPresenceCommand();
  }

  close() async {
    if (state == SessionState.established) {
      await sendFinishingSession();
    }
  }

  Future<Command> _sendPresenceCommand() async {
    //TODO: fix fixed params
    final resource = {
      "echo": false,
      "routingRule": "promiscuous",
      "status": "available"
    };

    return sendCommand(
      Command(
          method: CommandMethod.set,
          uri: '/presence',
          type: 'application/vnd.lime.presence+json',
          resource: resource),
    );
  }

  @override
  Future<Command> sendCommand(Command command) async {
    //TODO: add logic to resolve commands here?

    final Map<String, dynamic> metadata = <String, dynamic>{};
    StreamController<Command> stream = StreamController<Command>();
    metadata['command'] = command.id;
    metadata['stream'] = stream;
    _commandResolves.add(metadata);

    super.sendCommand(command);

    await for (Command value in stream.stream) {
      return value;
    }
    throw Exception('sendCommand error');
  }

  @override
  void onMessage(message) {}
  @override
  void onNotification(notification) {}
  @override
  void onCommand(command) {
    if (_commandResolves.isEmpty) return;

    final Map<String, dynamic> data = _commandResolves
        .firstWhere((element) => element['command'] == command.id);

    if (data.isNotEmpty) {
      _commandResolves.remove(data);
      final StreamController<Command> stream = data['stream'];
      stream.sink.add(command);
    }
  }
}
