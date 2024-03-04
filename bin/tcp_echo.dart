#! /usr/bin/env dart

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

/// Listen on the passed tcp port and echo any data back to the client.
void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('port',
        abbr: 'p', defaultsTo: '3001', help: 'set the port to listen on.');

  late final int port;
  try {
    final parsed = parser.parse(args);
    port = int.tryParse(parsed['port'] as String) ?? 3001;
  } on FormatException catch (e) {
    showUsage(parser);
  }
  try {
    final serverSocket = await ServerSocket.bind('0.0.0.0', port);
    print('Server listening on ${serverSocket.address}:${serverSocket.port}');

    await for (final socket in serverSocket) {
      await handleConnection(socket);
    }
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> handleConnection(Socket socket) async {
  final remoteAddress = socket.remoteAddress;
  final remotePort = socket.remotePort;
  print('Client connected: $remoteAddress:$remotePort');

  socket.listen(
    (data) async {
      final receivedString = utf8.decode(data);
      print('Received: $receivedString');

      // Echo back the received data
      socket.write('Echo: $receivedString');
      await socket.close();
    },
    onDone: () async {
      print('Client disconnected: $remoteAddress:$remotePort');
      await socket.close();
    },
    // ignore: avoid_types_on_closure_parameters
    onError: (Object error) async {
      print('Error: $error');
      await socket.close();
    },
    cancelOnError: true,
  );
}

void showUsage(ArgParser parser) {
  print('''
Listens to the passed TCP port and echos any request back to the client.
Defaults to port 3001.
''');
  print(parser.usage);
  exit(1);
}
