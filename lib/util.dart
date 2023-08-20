class Util {
  static String formatDuration(Duration duration) {
    int years = duration.inDays ~/ 365;
    int weeks = (duration.inDays - years * 365) ~/ 7;
    int days = duration.inDays - (years * 365 + weeks * 7);
    int hours = duration.inHours - duration.inDays * 24;
    int minutes = duration.inMinutes - duration.inHours * 60;
    int seconds = duration.inSeconds - duration.inMinutes * 60;

    // The number of time measures to use
    // (years, weeks, days) or (weeks, days, hours) etc.
    int count = 3;
    String result = "";

    if (count > 0 && years > 0) {
      result += "$years ${years == 1 ? "year" : "years"}, ";
      count--;
    }
    if (count > 0 && weeks > 0) {
      result += "$weeks ${weeks == 1 ? "week" : "weeks"}, ";
      count--;
    }
    if (count > 0 && days > 0) {
      result += "$days ${days == 1 ? "day" : "days"}, ";
      count--;
    }
    if (count > 0 && hours > 0) {
      result += "$hours ${hours == 1 ? "hour" : "hours"}, ";
      count--;
    }
    if (count > 0 && minutes > 0) {
      result += "$minutes ${minutes == 1 ? "minute" : "minutes"}, ";
      count--;
    }
    if (count > 0) {
      result += "$seconds ${seconds == 1 ? "second" : "seconds"}, ";
    }
    return result;
  }
}
