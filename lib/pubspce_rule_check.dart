enum DateType { day, month, year }

enum RuleType { normal, warning, error }

RuleType updateCheck(String update,
    {int num1 = 6, int num2 = 12, DateType type = DateType.month}) {
  if (update == "unknown") {
    return RuleType.normal;
  }
  if (type == DateType.month) {
    var date = 0;
    try {
      date = int.parse(update.split(" ")[0]);
    } catch (_) {}
    if (update.contains("month")) {
      if (date <= num1) {
        return RuleType.normal;
      } else if (date <= num2) {
        return RuleType.warning;
      } else {
        return RuleType.error;
      }
    } else if (update.contains("day")) {
      return updateCheck("${date ~/ 30} months ago",
          num1: num1, num2: num2, type: DateType.month);
    } else if (update.contains("year")) {
      return updateCheck("${date * 12} months ago",
          num1: num1, num2: num2, type: DateType.month);
    }
  } else if (type == DateType.day) {
    var date = 0;
    try {
      date = int.parse(update.split(" ")[0]);
    } catch (_) {}
    if (update.contains("day")) {
      if (date < num1) {
        return RuleType.normal;
      } else if (date < num2) {
        return RuleType.warning;
      } else {
        return RuleType.error;
      }
    } else if (update.contains("month")) {
      return updateCheck("${date * 30} days ago",
          num1: num1, num2: num2, type: DateType.day);
    } else if (update.contains("year")) {
      return updateCheck("${date * 360} days ago",
          num1: num1, num2: num2, type: DateType.day);
    }
  } else {
    var date = 0;
    try {
      date = int.parse(update.split(" ")[0]);
    } catch (_) {}
    if (update.contains("year")) {
      if (date < num1) {
        return RuleType.normal;
      } else if (date < num2) {
        return RuleType.warning;
      } else {
        return RuleType.error;
      }
    } else if (update.contains("month")) {
      return updateCheck("${date ~/ 12} year ago",
          num1: num1, num2: num2, type: DateType.day);
    } else if (update.contains("day")) {
      return updateCheck("${date ~/ 360} year ago",
          num1: num1, num2: num2, type: DateType.day);
    }
  }

  return RuleType.normal;
}

RuleType openIssueCheck(String issue, {int num1 = 20, int num2 = 50}) {
  var issueCnt = 0;
  try {
    issueCnt = int.parse(issue.split(" ")[0]);
  } catch (_) {}
  if (issueCnt < num1) {
    return RuleType.normal;
  } else if (issueCnt < num2) {
    return RuleType.warning;
  } else {
    return RuleType.error;
  }
}
