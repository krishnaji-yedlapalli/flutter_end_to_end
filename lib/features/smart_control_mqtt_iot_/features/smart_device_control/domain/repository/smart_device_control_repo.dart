
abstract class SmartDeviceControlRepository {

  Future<bool> getStatus(String ip);
  Future<bool> on(String ip);
  Future<bool> off(String ip);
}