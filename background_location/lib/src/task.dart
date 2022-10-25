// part of background_location;

// class GeolocatingTaskHandler extends TaskHandler {
//   SendPort? _sendPort;
//   int _eventCount = 0;

//   @override
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     _sendPort = sendPort;

//     // You can use the getData function to get the stored data.
//     final customData =
//         await FlutterForegroundTask.getData<String>(key: 'customData');
//     print('customData: $customData');
//   }

//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
//     FlutterForegroundTask.updateService(
//       notificationTitle: 'Geolocator',
//       notificationText: 'Proccessing update your location.',
//     );

//     // Send data to the main isolate.
//     sendPort?.send(_eventCount);

//     _eventCount++;
//     // TODO: handle update location to server in here
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
//     // You can use the clearAllData function to clear all the stored data.
//     await FlutterForegroundTask.clearAllData();
//   }

//   @override
//   void onButtonPressed(String id) {
//     // Called when the notification button on the Android platform is pressed.
//     print('onButtonPressed >> $id');
//     // TODO: Handle event by Npotification button ID
//     // handle by event registered in singleton instace
//     // locator<PermissionSevice>();
//   }

//   @override
//   void onNotificationPressed() {
//     // Called when the notification itself on the Android platform is pressed.
//     //
//     // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//     // this function to be called.

//     // Note that the app will only route to "root" when it is exited so
//     // it will usually be necessary to send a message through the send port to
//     // signal it to restore state when the app is already started.
//     FlutterForegroundTask.launchApp("root");
//     _sendPort?.send('onNotificationPressed');
//   }

//   static Future initialTask() async {
//     FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'notification_channel_id',
//         channelName: 'Foreground Notification',
//         channelDescription:
//             'This notification appears when the foreground service is running.',
//         channelImportance: NotificationChannelImportance.LOW,
//         priority: NotificationPriority.HIGH,
//         iconData: const NotificationIconData(
//           resType: ResourceType.mipmap,
//           resPrefix: ResourcePrefix.ic,
//           name: 'launcher',
//           backgroundColor: Colors.orange,
//         ),
//         buttons: [
//           const NotificationButton(id: 'mapButton', text: 'Map'),
//           const NotificationButton(id: 'closeButton', text: 'Close'),
//         ],
//       ),
//       iosNotificationOptions: const IOSNotificationOptions(
//         showNotification: true,
//         playSound: false,
//       ),
//       foregroundTaskOptions: const ForegroundTaskOptions(
//         interval: 5000, //TODO : can mofify
//         autoRunOnBoot: true,
//         allowWakeLock: true,
//         allowWifiLock: true,
//       ),
//     );
//   }
// }
