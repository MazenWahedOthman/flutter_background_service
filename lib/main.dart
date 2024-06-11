import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background WebSocket Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebSocketChannel? channel;
  StreamSubscription<Position>? positionStream;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initBackgroundExecution();
    initWebSocket();
    startLocationUpdates();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    channel?.sink.close();
    super.dispose();
  }

  Future<void> initBackgroundExecution() async {
    await FlutterBackground.initialize();
    await FlutterBackground.enableBackgroundExecution();
  }

  void initWebSocket() {
    channel = IOWebSocketChannel.connect('ws://188.245.52.195:3000');
  }

  void startLocationUpdates() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      sendLocation(1, 2);
    });
  }

  void sendLocation(double latitude, double longitude) {
    if (channel != null && channel?.sink != null) {
      log("dsdfef");
      try {
        channel?.sink.add('driver_5_${latitude}_$longitude');
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background WebSocket Example'),
      ),
      body: const Center(
        child: Text('App running in the background.'),
      ),
    );
  }
}
