import 'package:lime/lime.dart';
import 'package:lime/network/transport.dart';

class SDKClient extends ClientChannel {
  SDKClient(Transport transport) : super(transport);

  connect() async {
    await open();
    await establishSession();
  }

  close() async {
    if (state == SessionState.established) {
      await sendFinishingSession();
    }
  }

  @override
  void onMessage(message) {}
  @override
  void onNotification(notification) {}
  @override
  void onCommand(command) {}
}
