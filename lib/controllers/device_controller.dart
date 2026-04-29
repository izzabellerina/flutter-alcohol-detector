import 'package:flutter/foundation.dart';

import '../models/device_models.dart';
import '../services/alcohol_device_service.dart';
import '../services/card_reader_service.dart';

class DeviceController extends ChangeNotifier {
  DeviceController({
    required AlcoholDeviceService alcoholService,
    required CardReaderService cardReaderService,
  })  : _alcoholService = alcoholService,
        _cardReaderService = cardReaderService;

  final AlcoholDeviceService _alcoholService;
  final CardReaderService _cardReaderService;

  DeviceState _alcoholState = const DeviceState();
  DeviceState _cardReaderState = const DeviceState();

  DeviceState get alcoholState => _alcoholState;
  DeviceState get cardReaderState => _cardReaderState;

  bool get isReadyForTest => _alcoholState.isConnected;

  Future<void> connectAlcoholDevice() async {
    _alcoholState = _alcoholState.copyWith(
      connectionState: DeviceConnectionState.connecting,
      clearError: true,
    );
    notifyListeners();

    try {
      final devices = await _alcoholService.scan();
      if (devices.isEmpty) {
        throw StateError('ไม่พบอุปกรณ์เครื่องเป่าแอลกอฮอล์');
      }
      final connected = await _alcoholService.connect(devices.first);
      _alcoholState = DeviceState(
        connectionState: DeviceConnectionState.connected,
        device: connected,
      );
    } catch (e) {
      _alcoholState = _alcoholState.copyWith(
        connectionState: DeviceConnectionState.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> disconnectAlcoholDevice() async {
    await _alcoholService.disconnect();
    _alcoholState = const DeviceState();
    notifyListeners();
  }

  Future<void> connectCardReader() async {
    _cardReaderState = _cardReaderState.copyWith(
      connectionState: DeviceConnectionState.connecting,
      clearError: true,
    );
    notifyListeners();

    try {
      final devices = await _cardReaderService.scan();
      if (devices.isEmpty) {
        throw StateError('ไม่พบเครื่องอ่านใบขับขี่');
      }
      final connected = await _cardReaderService.connect(devices.first);
      _cardReaderState = DeviceState(
        connectionState: DeviceConnectionState.connected,
        device: connected,
      );
    } catch (e) {
      _cardReaderState = _cardReaderState.copyWith(
        connectionState: DeviceConnectionState.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> disconnectCardReader() async {
    await _cardReaderService.disconnect();
    _cardReaderState = const DeviceState();
    notifyListeners();
  }

  Future<DriverInfo> readDriverCard() async {
    return _cardReaderService.readCard();
  }
}
