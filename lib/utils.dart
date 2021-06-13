import 'dart:io';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_and_me/resources/string.dart';

setImage(String key, String imagePath) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, imagePath);
}

Future<File> getImage(String personShareKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return File(prefs.getString(personShareKey));
}

Future<bool> getBoolean(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

setBoolean(String key, bool state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, state);
}

setRelationTime(DateTime time) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(SHARE_PREF_RS_DATE, time.toString());
}

setPrefInt(String key, int data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, data);
}

Future<int> getPrefInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future<DateTime> getRelationTime(String sharePrefRSDate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString(SHARE_PREF_RS_DATE) != null) {
    return DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(prefs.getString(SHARE_PREF_RS_DATE)) ??
        DateTime.now();
  } else {
    return DateTime.now();
  }
}

int getTotalDate(DateTime startDate) {
  DateTime endDate = DateTime.now();
  return endDate.difference(startDate).inDays;
}

String getExtension(int tempNum, String text) {
  if (tempNum > 1) {
    return text + "s";
  } else
    return text;
}

RelationShipTime getDifferentYear(DateTime selectedDate) {
  var birthDate = selectedDate;
  final now = new DateTime.now();

  int years = now.year - birthDate.year;
  int months = now.month - birthDate.month;
  int days = now.day - birthDate.day;

  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += (days < 0 ? 11 : 12);
  }

  if (days < 0) {
    final monthAgo = new DateTime(now.year, now.month - 1, birthDate.day);
    days = now.difference(monthAgo).inDays + 1;
  }

  return RelationShipTime(
      years: years, months: months, weeks: days ~/ 7.round(), days: (days % 7));
}

class RelationShipTime {
  int years;
  int months;
  int weeks;
  int days;

  RelationShipTime({
    this.years = 0,
    this.months = 0,
    this.weeks = 0,
    this.days = 0,
  });
}
