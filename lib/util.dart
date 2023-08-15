class Util {
  // Format duration using "X year, Y weeks, Z days, W hours",
  // only displaying number X,Y,Z if they're different from 0
  static String formatDuration(Duration duration) {
    int years = duration.inDays ~/ 365;
    int weeks = (duration.inDays - years * 365) ~/ 7;
    int days = duration.inDays - (years * 365 + weeks * 7);
    int hours = duration.inHours - (years * 365 + weeks * 7 + days) * 24;

    String result = "";

    if (years > 0) {
      result += "$years ${years == 1 ? "year" : "years"}, ";
    }
    if (weeks > 0) {
      result += "$weeks ${weeks == 1 ? "week" : "weeks"}, ";
    }
    if (days > 0) {
      result += "$days ${days == 1 ? "day" : "days"}, ";
    }
    result += "$hours ${hours == 1 ? "hour" : "hours"} ";

    return result;
  }
}
