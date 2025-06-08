import 'package:easy_localization/easy_localization.dart';

String calculateTimeDifference(String? startTime, String? endTime) {
  if (startTime == null || endTime == null) return 'time.na'.tr();
  try {
    DateTime start = DateTime.parse(startTime);
    DateTime end = DateTime.parse(endTime);

    Duration duration = end.difference(start);

    if (duration.inDays > 0) {
      return '${duration.inDays}\n${'time.day'.tr()}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}\n${'time.hour'.tr()}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}\n${'time.minute'.tr()}';
    } else {
      return '${duration.inSeconds}\n${'time.second'.tr()}';
    }
  } catch (e) {
    return 'time.na'.tr();
  }
}
