import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {
  DeepLinkBloc() {
    startUri().then(_onRedirected);
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  // Initial event channel
  static const platform = MethodChannel('initial');

  // Runtime Event channel
  static const stream = EventChannel('eventWhileAppIsRunning');

  final StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;

  //Adding the listener into constructor

  void _onRedirected(String uri) {
    debugPrint(uri);
    stateSink.add(uri);
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<String> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
