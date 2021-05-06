import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isShowDaySwitched = false;
  bool isNotificationSwitched = false;
  bool isRemindMeSwitched = false;
  bool isWidgetSwitched = false;
  DateTime _selectedDate = DateTime.now();
  File _personOneImage;
  File _personTwoImage;

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _getNotificationSwitch("show_days", 1);
    _getNotificationSwitch("notification", 2);
    _getNotificationSwitch("remind_me", 3);
    _getNotificationSwitch("widget", 4);
    _getRelationTime();
    _getImage("image1", 1);
    _getImage("image2", 2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xfffff6f5),
          leading: ClipOval(
            child: Material(
              color: Color(0xfffff6f5),
              child: InkWell(
                splashColor: Color(0xfffff6f5),
                child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xfffdaaa3),
                      size: 18,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          title: Text(
            "Setting",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff7E7175),
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          color: Color(0xfffff6f5),
          child: Column(
            children: [
              Card(
                elevation: 0.1,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You & Me",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "Images",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          personPhoto("images/male.jpg", _personOneImage,
                              id: 1),
                          personPhoto("images/female.jpg", _personTwoImage,
                              id: 2),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "Since",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${formatter.format(_selectedDate.toLocal())}"
                                .split(' ')[0],
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Montserrat",
                                color: Color(0xffff495a),
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          ClipOval(
                            child: Material(
                              color: Color(0xfffff6f5),
                              child: InkWell(
                                splashColor: Color(0xfffff6f5),
                                child: SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Color(0xfffdaaa3),
                                      size: 16,
                                    )),
                                onTap: () {
                                  _selectDate(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Text(
                            "Show days",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          FlutterSwitch(
                            width: 40.0,
                            height: 20.0,
                            toggleSize: 16.0,
                            activeColor: Color(0xfffd7f75),
                            inactiveColor: Color(0xfffdaaa3),
                            value: isShowDaySwitched,
                            borderRadius: 30.0,
                            onToggle: (val) {
                              setState(() {
                                isShowDaySwitched = val;
                                _setNotificationSwitch("show_days", val);
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0.1,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notification",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(
                      //   height: 18,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Notification",
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //     Spacer(),
                      //     FlutterSwitch(
                      //       width: 40.0,
                      //       height: 20.0,
                      //       toggleSize: 16.0,
                      //       activeColor: Color(0xfffd7f75),
                      //       inactiveColor: Color(0xfffdaaa3),
                      //       value: isNotificationSwitched,
                      //       borderRadius: 30.0,
                      //       onToggle: (val) {
                      //         setState(() {
                      //           isNotificationSwitched = val;
                      //           _setNotificationSwitch("notification", val);
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            "Remind me",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          FlutterSwitch(
                            width: 40.0,
                            height: 20.0,
                            toggleSize: 16.0,
                            activeColor: Color(0xfffd7f75),
                            inactiveColor: Color(0xfffdaaa3),
                            value: isRemindMeSwitched,
                            borderRadius: 30.0,
                            onToggle: (val) {
                              setState(() {
                                isRemindMeSwitched = val;
                                _setNotificationSwitch("remind_me", val);
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            "Widget",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          FlutterSwitch(
                            width: 40.0,
                            height: 20.0,
                            toggleSize: 16.0,
                            activeColor: Color(0xfffd7f75),
                            inactiveColor: Color(0xfffdaaa3),
                            value: isWidgetSwitched,
                            borderRadius: 30.0,
                            onToggle: (val) {
                              setState(() {
                                isWidgetSwitched = val;
                                _setNotificationSwitch("widget", val);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0.1,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Theme",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _themeItem(Colors.deepOrange, isHighlight: true),
                          SizedBox(
                            width: 8,
                          ),
                          _themeItem(Colors.blue),
                          SizedBox(
                            width: 8,
                          ),
                          _themeItem(Colors.green),
                          SizedBox(
                            width: 8,
                          ),
                          _themeItem(Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minWidth: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      splashColor: Color(0xfffdaaa3),
                      onPressed: () {},
                      child: Text(
                        "Clear Default",
                        style:
                            TextStyle(color: Color(0xff7E7175), fontSize: 16),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  personPhoto(String image, File _personImage, {int id = 1}) {
    return GestureDetector(
      onTap: () => {_pickImageFromGallery(id: id)},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        elevation: 1.0,
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            image: DecorationImage(
              image: _personImage == null
                  ? AssetImage(image)
                  : FileImage(_personImage),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                onSurface: Color(0xffff495a),
                primary: Color(0xffff495a),
                secondaryVariant: Color(0xffff495a),
                secondary: Color(0xffff495a),
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        _setRelationTime(newSelectedDate);
      });
    }
  }

  _pickImageFromGallery({int id = 1}) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    String tempFileName;
    if (id == 1) {
      tempFileName = "image1";
    } else {
      tempFileName = "image2";
    }
    String dirFullPath = '$path/$tempFileName';
    await image.copy(dirFullPath);
    setState(() {
      if (id == 1) {
        _personOneImage = image;
        _setImage("image1", dirFullPath);
      } else {
        _personTwoImage = image;
        _setImage("image2", dirFullPath);
      }
    });
  }

  _setImage(String key, String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, imagePath);
  }

  _getImage(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString(key) != null && id == 1) {
        _personOneImage = File(prefs.getString(key));
      } else if (prefs.getString(key) != null && id == 2) {
        _personTwoImage = File(prefs.getString(key));
      }
    });
  }

  _setNotificationSwitch(String switchName, bool switchState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(switchName, switchState);
  }

  _getNotificationSwitch(String switchName, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool data = prefs.getBool(switchName) ?? false;
    setState(() {
      if (id == 1)
        isShowDaySwitched = data;
      else if (id == 2)
        isNotificationSwitched = data;
      else
        isRemindMeSwitched = data;
    });
  }

  _setRelationTime(DateTime time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("relationship_time", time.toString());
  }

  _getRelationTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("relationship_time") != null) {
        _selectedDate = DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(prefs.getString("relationship_time")) ??
            DateTime.now();
      }
    });
  }
}

_themeItem(MaterialColor color, {bool isHighlight = false}) {
  return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        border: isHighlight ? Border.all(color: Colors.black) : null,
      ));
}
