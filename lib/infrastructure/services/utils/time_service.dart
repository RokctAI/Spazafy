import 'package:rokctapp/app_constants.dart';
import 'package:intl/intl.dart';

abstract class TimeService {
  TimeService._();

  static final String _timeFormat = AppConstants.use24Format
      ? 'HH:mm'
      : 'h:mm a';

  static String dateFormatYMD(DateTime? time) {
    return DateFormat("yyyy-MM-dd").format(time ?? DateTime.now());
  }

  static String dateFormatMDYHm(DateTime? time) {
    return DateFormat(
      "MMM d, yyyy - $_timeFormat",
    ).format(time ?? DateTime.now());
  }

  static String dateFormatDMY(DateTime? time) {
    return DateFormat("d MMM, yyyy").format(time ?? DateTime.now());
  }

  static String dateFormatMD(DateTime? time) {
    return DateFormat("MMMM dd").format(time ?? DateTime.now());
  }

  static String dateFormatEMD(DateTime? time) {
    return DateFormat("EEEE, MMM dd").format(time ?? DateTime.now());
  }

  static String dateFormatMDHm(DateTime? time) {
    return DateFormat("MMM dd, $_timeFormat").format(time ?? DateTime.now());
  }

  static String dateFormatEE(DateTime? time) {
    return DateFormat("EEEE").format(time ?? DateTime.now());
  }

  static String dateFormatDM(DateTime? time) {
    if (DateTime.now().year == time?.year) {
      return DateFormat("d MMMM").format(time ?? DateTime.now());
    }
    return DateFormat("d MMMM, yyyy").format(time ?? DateTime.now());
  }

  static String timeFormat(DateTime? time) {
    return DateFormat(_timeFormat).format(time ?? DateTime.now());
  }

  static String dateFormatForChat(DateTime? time) {
    if ((DateTime.now().difference(time ?? DateTime.now()).inHours) > 24 &&
        (DateTime.now().difference(time ?? DateTime.now()).inDays) < 7) {
      return DateFormat("EEEE").format(time ?? DateTime.now());
    }
    if ((DateTime.now().difference(time ?? DateTime.now()).inDays) > 7) {
      return DateFormat("MMM/d/yyyy").format(time ?? DateTime.now());
    }
    return DateFormat(_timeFormat).format(time ?? DateTime.now());
  }

  static String dateFormatForNotification(DateTime? time) {
    return DateFormat("d MMM, $_timeFormat").format(time ?? DateTime.now());
  }

  static String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  static String timeFormatTime(String? time) {
    if (time == null) {
      return '';
    }
    return DateFormat(_timeFormat).format(
      DateTime.now().copyWith(
        hour: int.tryParse(time.substring(0, 2)),
        minute: int.tryParse(time.substring(3, 5)),
      ),
    );
  }

  static DateTime dateFormatYMDToDateTime(DateTime? time) {
    return DateTime.tryParse(
          DateFormat("yyyy-MM-dd").format(time ?? DateTime.now()),
        ) ??
        DateTime.now();
  }

  static String dateFormatDay(DateTime? time) {
    return DateFormat("yyyy-MM-dd").format(time ?? DateTime.now());
  }

  static String dateFormat(DateTime? time) {
    return DateFormat("MMM d,yyyy").format(time ?? DateTime.now());
  }

  static String dateFormatForOrder(DateTime? time) {
    return '${DateFormat('dd.MM.yyyy').format(time?.toLocal() ?? DateTime.now())} | ${DateFormat('HH:mm').format(time?.toLocal() ?? DateTime.now())}';
  }

  static String dateFormatMulti(List<DateTime?> time) {
    String response = '';
    if (time.isEmpty) {
      return response;
    }
    for (int i = 0; i < time.length; i++) {
      if (time[i] != null) {
        response += DateFormat("d MMM yyyy").format(time[i]!);
        if (i == 0 && time.length > 1) {
          response += '  -  ';
        }
      }
    }
    return response;
  }
}
