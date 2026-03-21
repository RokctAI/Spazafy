import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:rokctapp/printer/models/data/printer_device.dart';


class TcpConnector {
  static final TcpConnector _instance = TcpConnector._internal();
  factory TcpConnector() => _instance;
  TcpConnector._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Socket? _socket;

  Future<List<PrinterDevice>> discover() async {
    // TODO: Implement TCP discovery logic
    return [];
  }

  Future<bool> connect(String ipAddress, {int port = 9100}) async {
    try {
      _socket = await Socket.connect(
        ipAddress,
        port,
        timeout: const Duration(seconds: 5),
      );
      _isConnected = true;
      return true;
    } catch (e) {
      debugPrint('==> TCP connection failure: $e');
      _isConnected = false;
      _socket?.destroy();
      _socket = null;
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_socket != null) {
      try {
        await _socket!.flush();
        await _socket!.close();
      } catch (e) {
        debugPrint('==> TCP disconnect failure: $e');
      } finally {
        _socket!.destroy();
        _socket = null;
        _isConnected = false;
      }
    } else {
      _isConnected = false;
    }
  }

  Future<void> sendBytes(List<int> bytes) async {
    if (!_isConnected || _socket == null) return;
    try {
      _socket!.add(bytes);
      await _socket!.flush();
    } catch (e) {
      debugPrint('==> TCP send failure: $e');
      _isConnected = false;
      _socket?.destroy();
      _socket = null;
    }
  }
}
