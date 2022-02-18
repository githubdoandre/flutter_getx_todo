import 'dart:async';

import 'package:lime/lime.dart' as lime;

class SDKClient extends lime.ClientChannel {
  SDKClient(lime.Transport transport) : super(transport);

  final List<Map<String, dynamic>> _commandResolves = [];

  connect() async {
    await open();

    final keyAuthentication = lime.KeyAuthentication();
    keyAuthentication.key = 'eERTalhFc3gzSkgxc0hXdUNGeTM=';

    await establishSession(
        'andrehumano@msging.net', '!desk', keyAuthentication);

    await _sendPresenceCommand();
  }

  close() async {
    if (state == lime.SessionState.established) {
      await sendFinishingSession();
    }
  }

  Future<lime.Command> _sendPresenceCommand() async {
    //TODO: fix fixed params
    final resource = {
      "echo": false,
      "routingRule": "promiscuous",
      "status": "available"
    };

    return sendCommand(
      lime.Command(
          method: lime.CommandMethod.set,
          uri: '/presence',
          type: 'application/vnd.lime.presence+json',
          resource: resource),
    );
  }

  @override
  Future<lime.Command> sendCommand(lime.Command command) async {
    //TODO: add logic to resolve commands here?

    final Map<String, dynamic> metadata = <String, dynamic>{};
    StreamController<lime.Command> stream = StreamController<lime.Command>();
    metadata['command'] = command.id;
    metadata['stream'] = stream;
    _commandResolves.add(metadata);

    super.sendCommand(command);

    await for (lime.Command value in stream.stream) {
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
      final StreamController<lime.Command> stream = data['stream'];
      stream.sink.add(command);
    }
  }
}
