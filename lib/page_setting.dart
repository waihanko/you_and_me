import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:you_and_me/generate_color.dart';
import 'package:you_and_me/resources/enum.dart';
import 'package:you_and_me/resources/string.dart';
import 'package:you_and_me/utils.dart';
import 'preson_placeholder.dart';
import 'resources/colors.dart';
import 'widget_input_dialog.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isShowDaySwitched = false;
  bool isRemindMeSwitched = false;
  bool isWidgetSwitched = false;
  DateTime _selectedDate = DateTime.now();
  String _person1Name = "Adam";
  String _person2Name = "Eve";
  File _personOneImage;
  File _personTwoImage;
  Color _bgColor;
  Color _statusBarColor;
  Color _cardColor;
  Color _totalDayColor;
  Color _iconColorLight;
  Color _iconColorDeep;
  Color _placeHolderBgColor;
  Color _placeHolderBorderColor;
  Color _placeHolderIconColor;
  TextEditingController name1EditingController = TextEditingController();
  TextEditingController name2EditingController = TextEditingController();

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        setState(() {
          getImage(SHARE_PREF_PERSON_1_IMAGE)
              .then((value) => _personOneImage = value);
          getImage(SHARE_PREF_PERSON_2_IMAGE)
              .then((value) => _personTwoImage = value);
          getRelationTime(SHARE_PREF_RS_DATE)
              .then((value) => _selectedDate = value);
          getBoolean(SHARE_PREF_IS_SHOW_TOTAL_DAYS)
              .then((value) => _isShowDaySwitched = value);
          getString(SHARE_PREF_PERSON_1_NAME).then((value) =>
              value == null ? _person1Name = "Adam" : _person1Name = value);
          getString(SHARE_PREF_PERSON_2_NAME).then((value) =>
              value == null ? _person2Name = "Eve" : _person2Name = value);
        });
        getPrefInt(SHARE_PREF_THEME).then(
          (value) => changeThemeData(
              value != null ? ThemeType.values[value] : ThemeType.THEME_PINK),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: _statusBarColor));
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, true);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: _cardColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: _bgColor,
            leading: ClipOval(
              child: Material(
                color: _bgColor,
                child: InkWell(
                  splashColor: _bgColor,
                  child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: _iconColorLight,
                        size: 18,
                      )),
                  onTap: () {
                    Navigator.pop(context, true);
                    return Future.value(false);
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
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18),
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
                            personPhoto(
                              _personOneImage,
                              SHARE_PREF_PERSON_1_IMAGE,
                            ),
                            personPhoto(
                              _personTwoImage,
                              SHARE_PREF_PERSON_2_IMAGE,
                            ),
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
                                  color: _totalDayColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            ClipOval(
                              child: Material(
                                color: _bgColor,
                                child: InkWell(
                                  splashColor: _bgColor,
                                  child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: _iconColorLight,
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
                              "Show total days",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            FlutterSwitch(
                              width: 40.0,
                              height: 20.0,
                              toggleSize: 16.0,
                              activeColor: _iconColorDeep,
                              inactiveColor: _iconColorLight,
                              value: _isShowDaySwitched == null
                                  ? false
                                  : _isShowDaySwitched,
                              borderRadius: 30.0,
                              onToggle: (val) {
                                setState(() {
                                  _isShowDaySwitched = val;
                                  setBoolean(SHARE_PREF_IS_SHOW_TOTAL_DAYS,
                                      _isShowDaySwitched);
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
                          "Nick Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(
                              _person1Name,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            ClipOval(
                              child: Material(
                                color: _bgColor,
                                child: InkWell(
                                  splashColor: _bgColor,
                                  child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: Icon(
                                        Icons.edit,
                                        color: _iconColorLight,
                                        size: 16,
                                      )),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WidgetInputDialog(
                                          name1EditingController,
                                          _person1Name,
                                          _iconColorDeep,
                                          _placeHolderBorderColor,
                                          _placeHolderBgColor,
                                          savePerson1Name,
                                        );
                                      },
                                    );
                                    //_chooseName(SHARE_PREF_PERSON_1_NAME);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              _person2Name,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            ClipOval(
                              child: Material(
                                color: _bgColor,
                                child: InkWell(
                                  splashColor: _bgColor,
                                  child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: Icon(
                                        Icons.edit,
                                        color: _iconColorLight,
                                        size: 16,
                                      )),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WidgetInputDialog(
                                            name2EditingController,
                                            _person2Name,
                                            _iconColorDeep,
                                            _placeHolderBorderColor,
                                            _placeHolderBgColor,
                                            savePerson2Name);
                                      },
                                    );
                                  },
                                ),
                              ),
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
                            ThemeSelectorItem(
                              pinkColor[PROGRESS_COLOR],
                              changeThemeData,
                              themeColorData: ThemeType.THEME_PINK,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ThemeSelectorItem(
                              blueColor[PROGRESS_COLOR],
                              changeThemeData,
                              themeColorData: ThemeType.THEME_BLUE,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ThemeSelectorItem(
                              greenColor[PROGRESS_COLOR],
                              changeThemeData,
                              themeColorData: ThemeType.THEME_GREEN,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ThemeSelectorItem(
                              purpleColor[PROGRESS_COLOR],
                              changeThemeData,
                              themeColorData: ThemeType.THEME_PURPLE,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Center(
                  child: Text(
                    "version 1.0",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  personPhoto(File _personImage, String imageName) {
    return GestureDetector(
      onTap: () => _pickImageFromGallery(imageName),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        elevation: 1.0,
        child: _personImage == null
            ? PersonPlaceHolder(
                _placeHolderBgColor,
                _placeHolderBorderColor,
                _placeHolderIconColor,
                imageWidth: 80,
                imageHeight: 100,
                iconSize: 24,
              )
            : Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  image: DecorationImage(
                    image: FileImage(_personImage),
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
                onSurface: _statusBarColor,
                primary: _statusBarColor,
                secondaryVariant: _statusBarColor,
                secondary: _statusBarColor,
              ),
              dialogBackgroundColor: _bgColor,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        setRelationTime(newSelectedDate);
      });
    }
  }

  _pickImageFromGallery(String imageName) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    String dirFullPath = '$path/$imageName${DateTime.now()}';
    await image.copy(dirFullPath);
    setState(
      () {
        if (imageName == SHARE_PREF_PERSON_1_IMAGE) {
          _personOneImage = image;
        } else {
          _personTwoImage = image;
        }
        setImage(imageName, dirFullPath);
      },
    );
  }

  changeThemeData(ThemeType themeColorData) {
    GenerateColors generateColors = GenerateColors(themeColorData);
    setState(() {
      _bgColor = generateColors.getColor(BODY_BG_COLOR);
      _statusBarColor = generateColors.getColor(STATUS_BAR_COLOR);
      _iconColorDeep = generateColors.getColor(ICON_COLOR_DEEP);
      _iconColorLight = generateColors.getColor(ICON_COLOR_LIGHT);
      _totalDayColor = generateColors.getColor(TOTAL_DAY_COLOR);
      _cardColor = generateColors.getColor(CARD_COLOR);
      _placeHolderBgColor = generateColors.getColor(BODY_BG_COLOR);
      _placeHolderBorderColor = generateColors.getColor(ICON_COLOR_LIGHT);
      _placeHolderIconColor = generateColors.getColor(PROGRESS_COLOR);
    });
    setPrefInt(SHARE_PREF_THEME, themeColorData.index);
  }

  savePerson2Name(String person2Name) {
    setString(SHARE_PREF_PERSON_2_NAME, person2Name);
    setState(
      () {
        _person2Name = person2Name;
      },
    );
  }

  savePerson1Name(String person1Name) {
    setString(SHARE_PREF_PERSON_1_NAME, person1Name);
    setState(
      () {
        _person1Name = person1Name;
      },
    );
  }
}

class ThemeSelectorItem extends StatefulWidget {
  final ThemeType themeColorData;
  final Color color;
  final Function changeThemeData;

  ThemeSelectorItem(
    this.color,
    this.changeThemeData, {
    this.themeColorData = ThemeType.THEME_PINK,
  });

  @override
  _ThemeSelectorItemState createState() => _ThemeSelectorItemState();
}

class _ThemeSelectorItemState extends State<ThemeSelectorItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.changeThemeData(widget.themeColorData);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: new BoxDecoration(
          color: widget.color,
          borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }
}
