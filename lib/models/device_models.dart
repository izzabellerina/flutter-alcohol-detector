enum DeviceConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

enum DeviceKind { alcoholAnalyzer, cardReader }

class DeviceInfo {
  const DeviceInfo({
    required this.id,
    required this.name,
    required this.kind,
  });

  final String id;
  final String name;
  final DeviceKind kind;
}

class DeviceState {
  const DeviceState({
    this.connectionState = DeviceConnectionState.disconnected,
    this.device,
    this.errorMessage,
  });

  final DeviceConnectionState connectionState;
  final DeviceInfo? device;
  final String? errorMessage;

  bool get isConnected =>
      connectionState == DeviceConnectionState.connected && device != null;
  bool get isConnecting => connectionState == DeviceConnectionState.connecting;
  bool get hasError => connectionState == DeviceConnectionState.error;

  DeviceState copyWith({
    DeviceConnectionState? connectionState,
    DeviceInfo? device,
    String? errorMessage,
    bool clearDevice = false,
    bool clearError = false,
  }) {
    return DeviceState(
      connectionState: connectionState ?? this.connectionState,
      device: clearDevice ? null : device ?? this.device,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
