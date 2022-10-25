part of background_location;

class LocationCallbackHandler {
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.init(params);
  }

  static Future<void> disposeCallback() async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  static void callback(LocationDto locationDto) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    myLocationCallbackRepository.callback(locationDto);
  }

  static Future<void> notificationCallback() async {}
}
