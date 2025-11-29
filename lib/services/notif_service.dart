import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotifService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// INITIALIZATION
  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Makassar'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);

    await _plugin.initialize(initSettings);

    // Notification Permission Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Exact Alarm Android 12+
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  /// 🔔 Notifikasi langsung (manual test)
  static Future<void> showNow(String title, String body) async {
    const android = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifikasi',
      channelDescription: 'Notifikasi langsung',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: android),
    );
  }

  /// ⏰ Jadwalkan notifikasi + pre-alert
  static Future<void> scheduleWithPreAlert({
    required int idBase,
    required String title,
    required String body,
    required DateTime scheduledDate,
    Future<void> Function()? onTimeAction,
  }) async {
    const android = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Terjadwal',
      channelDescription: 'Notifikasi alarm waktu tertentu',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );

    final details = const NotificationDetails(android: android);

    final tzSchedule = tz.TZDateTime.from(scheduledDate, tz.local);
    final tzNow = tz.TZDateTime.now(tz.local);

    // 🔹 PRE-ALERT (3 menit sebelumnya)
    final preAlertTime = tzSchedule.subtract(const Duration(minutes: 3));
    if (preAlertTime.isAfter(tzNow)) {
      await _plugin.zonedSchedule(
        idBase + 1000,
        '⚠️ 3 menit lagi: $title',
        body,
        preAlertTime,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    // 🔹 NOTIFIKASI UTAMA
    await _plugin.zonedSchedule(
      idBase,
      '⏰ Waktunya: $title',
      body,
      tzSchedule,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // 🔹 Auto open link jika enable
    final delay = scheduledDate.difference(DateTime.now());
    if (delay.inSeconds > 0 && onTimeAction != null) {
      Timer(delay, () async {
        await onTimeAction();
      });
    }
  }

  /// ❌ CANCEL ALL
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
