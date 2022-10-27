part of background_location;

/// Provide access to location data while the app is in the background.
///
/// Use as a singleton:
///
///  `LocationManager()...`
///
class LocationManager {
  ReceivePort _port = ReceivePort();
  Stream<LocationDto>? _locationStream;
  String _channelName = "BackgroundLocationChannel",
      _notificationTitle = "Background Location",
      _notificationMsg =
          "Background location is on to keep the app up-to-date with your location.",
      _notificationBigMsg =
          "Background location is on to keep the app up-to-date with your location. "
          "This is required for main features to work properly when the app is not running.";

  int _interval = 5;
  double _distanceFilter = 0;
  LocationAccuracy _accuracy = LocationAccuracy.NAVIGATION;

  static final LocationManager _instance = LocationManager._();

  /// Get the singleton [LocationManager] instance
  factory LocationManager() => _instance;
  static const String _isolateName = "LocatorIsolate";

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

//Optional
  static void notificationCallback() {
    print('User clicked on the notification');
  }

  LocationManager._() {
    // Check if the port is already used
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    // Register the service to the port name
    IsolateNameServer.registerPortWithName(
        _port.sendPort, LocationServiceRepository.isolateName);

    initPlatformState();
  }

  /// Get the status of the location manager.
  /// Will return `true` if a location service is currently running.
  Future<bool> get isRunning async =>
      await BackgroundLocator.isServiceRunning();

  /// A stream of location data updates.
  /// Call [start] before using this stream.
  Stream<LocationDto> get locationStream {
    if (_locationStream == null) {
      Stream<dynamic> dataStream = _port.asBroadcastStream();
      _locationStream = dataStream
          .where((event) => event != null)
          .map((location) => location as LocationDto);
    }
    return _locationStream!;
  }

  /// Get the current location.
  Future<LocationDto> getCurrentLocation() async {
    if (!await BackgroundLocator.isRegisterLocationUpdate()) {
      await start();
      LocationDto dto = await locationStream.first;
      stop();
      return dto;
    }
    return await locationStream.first;
  }

  Future<void> updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: _notificationTitle,
        msg: "$_notificationMsg ${DateTime.now()}",
        bigMsg: "$_notificationBigMsg : ${data.latitude}, ${data.longitude}");
  }

  /// Start the location manager.
  /// Will have no effect if it is already running.
  Future<bool> start() async {
    bool running = await isRunning;
    if (!running) {
      Map<String, dynamic> data = {'countInit': 1};
      await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          distanceFilter: _distanceFilter,
          stopWithTerminate: true,
        ),
        autoStop: false,
        androidSettings: AndroidSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          interval: _interval,
          distanceFilter: _distanceFilter,
          client: LocationClient.google,
          androidNotificationSettings: AndroidNotificationSettings(
            notificationChannelName: 'Location tracking',
            notificationTitle: _notificationTitle,
            notificationMsg: _notificationMsg,
            notificationBigMsg: _notificationBigMsg,
            notificationIconColor: Colors.grey,
            notificationTapCallback:
                LocationCallbackHandler.notificationCallback,
          ),
        ),
      );
    }
    return running;
  }

  /// Stop the location manager.
  Future<void> stop() async =>
      await BackgroundLocator.unRegisterLocationUpdate();

  /// Set the title of the notification for the background service.
  /// Android only.
  set notificationTitle(value) => _notificationTitle = value;

  /// Set the message of the notification for the background service.
  /// Android only.
  set notificationMsg(value) => _notificationMsg = value;

  /// Set the long message of the notification for the background service.
  /// Android only.
  set notificationBigMsg(value) => _notificationBigMsg = value;

  /// Set the update interval in seconds.
  /// Android only.
  set interval(int value) => _interval = value;

  /// Set the update distance, i.e. the distance the user needs to move
  /// before an update is fired.
  set distanceFilter(double value) => _distanceFilter = value;

  /// Set the update accuracy. See [LocationAccuracy] for options.
  // set accuracy(LocationAccuracy value) => _accuracy = value;
}
