import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Real-time WebSocket service using Socket.io.
///
/// Connect after user login, disconnect on logout.
class SocketService {
  IO.Socket? _socket;
  bool _isConnected = false;

  // Event names matching backend implementation
  static const String eventAppointmentCreated = 'appointment:created';
  static const String eventAppointmentUpdated = 'appointment:updated';
  static const String eventPrescriptionCreated = 'prescription:created';

  /// Check if socket is connected.
  bool get isConnected => _isConnected;

  /// Connect to the socket server with authentication token.
  void connect(String baseUrl, String token) {
    // Vercel serverless does not support persistent WebSockets
    // We disable this to prevent continuous error logs
    // debugPrint(
    //     'SocketService: Socket disabled for Vercel deployment (using Push Notifications instead)');
    // return;

    if (_socket != null && _isConnected) {
      debugPrint('SocketService: Already connected');
      return;
    }

    // Parse baseUrl to get socket URL (remove /api if present)
    String socketUrl = baseUrl.replaceAll('/api', '');

    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['polling'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _isConnected = true;
      debugPrint('SocketService: Connected');
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      debugPrint('SocketService: Connection error - $error');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      debugPrint('SocketService: Disconnected');
    });

    _socket!.onError((error) {
      debugPrint('SocketService: Error - $error');
    });
  }

  /// Listen for doctor-specific events.
  ///
  /// [onAppointmentCreated] - Called when a new appointment is booked by a patient.
  void listenForDoctorEvents({
    required Function(dynamic data) onAppointmentCreated,
  }) {
    if (_socket == null) {
      debugPrint('SocketService: Socket not initialized');
      return;
    }

    _socket!.on(eventAppointmentCreated, (data) {
      debugPrint('SocketService: New appointment received - $data');
      onAppointmentCreated(data);
    });
  }

  /// Listen for patient-specific events.
  ///
  /// [onAppointmentUpdated] - Called when appointment status changes.
  /// [onPrescriptionCreated] - Called when doctor creates a prescription.
  void listenForPatientEvents({
    required Function(dynamic data) onAppointmentUpdated,
    required Function(dynamic data) onPrescriptionCreated,
  }) {
    if (_socket == null) {
      debugPrint('SocketService: Socket not initialized');
      return;
    }

    _socket!.on(eventAppointmentUpdated, (data) {
      debugPrint('SocketService: Appointment updated - $data');
      onAppointmentUpdated(data);
    });

    _socket!.on(eventPrescriptionCreated, (data) {
      debugPrint('SocketService: Prescription created - $data');
      onPrescriptionCreated(data);
    });
  }

  /// Remove all event listeners.
  void removeListeners() {
    _socket?.off(eventAppointmentCreated);
    _socket?.off(eventAppointmentUpdated);
    _socket?.off(eventPrescriptionCreated);
  }

  /// Disconnect from the socket server.
  void disconnect() {
    if (_socket != null) {
      removeListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      debugPrint('SocketService: Disconnected and disposed');
    }
  }
}
