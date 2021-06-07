import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:you_and_me/page_setting.dart';
import 'package:you_and_me/resources/enum.dart';
import 'package:you_and_me/resources/string.dart';
import 'package:you_and_me/utils.dart';

import 'generate_color.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext context;
  File _personOneImage;
  File _personTwoImage;
  int progressStartValue, progressEndValue;
  double progressPercent = 0;
  int totalRelationDays = 0;
  Color _totalDayColor;
  Color _iconColorLight;
  Color _progressBarColor = Colors.deepPurple;
  Color _progressBarBgColor = Colors.red;
  Color _statusBarColor;

  DateTime _selectedDate = DateTime.now();
  bool _isShowTotalDate;
  RelationShipTime relationShipTime = new RelationShipTime();
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
          getRelationTime(SHARE_PREF_RS_DATE).then(
            (value) => {
              _selectedDate = value,
              totalRelationDays = getTotalDate(_selectedDate),
              relationShipTime = getDifferentYear(_selectedDate),
              progressStartValue = getProgressStartValue(),
              progressEndValue = getProgressEndValue(),
              progressPercent = (totalRelationDays - progressStartValue) /
                  (progressEndValue - progressStartValue)
            },
          );
          getBoolean(SHARE_PREF_IS_SHOW_TOTAL_DAYS).then(
            (value) => _isShowTotalDate = value,
          );
          getPrefInt(SHARE_PREF_THEME).then(
            (value) => changeThemeData(
                value != null ? ThemeType.values[value] : ThemeType.THEME_PINK),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: _statusBarColor));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            ClipOval(
              child: Material(
                color: Colors.white,
                child: InkWell(
                  splashColor: _progressBarBgColor,
                  child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.settings,
                        color: _iconColorLight,
                      )),
                  onTap: () {
                    _navigateToNextScreen(context);
                  },
                ),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: coupleImages(),
              ),
              Expanded(flex: 1, child: relationshipTimeView()),
            ],
          ),
        ),
      ),
    );
  }

  changeThemeData(ThemeType themeColorData) {
    GenerateColors generateColors = GenerateColors(themeColorData);
    setState(() {
      _statusBarColor = generateColors.getColor(STATUS_BAR_COLOR);
      _progressBarColor = generateColors.getColor(PROGRESS_COLOR);
     _progressBarBgColor = generateColors.getColor(PROGRESS_BG_COLOR);
      _iconColorLight = generateColors.getColor(ICON_COLOR_LIGHT);
      _totalDayColor = generateColors.getColor(TOTAL_DAY_COLOR);
    });
    setPrefInt(SHARE_PREF_THEME, themeColorData.index);
  }

  coupleImages() {
    return Center(
      child: Container(
        child: SizedBox(
          height: 400,
          width: 300,
          child: Center(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: <Widget>[
                Positioned(
                    right: 0,
                    bottom: 60,
                    child: personPhoto("images/male.jpg", _personTwoImage,
                        SHARE_PREF_PERSON_1_IMAGE)),
                Positioned(
                    top: 60,
                    child: personPhoto("images/female.jpg", _personOneImage,
                        SHARE_PREF_PERSON_2_IMAGE)),
                Positioned(top: 0, left: 30, child: loveCircle()),
                Positioned(
                    top: 40,
                    left: 138,
                    child: loveCircle(height: 48, width: 48, iconSize: 28)),
                Positioned(
                    bottom: 166,
                    left: 132,
                    child: loveCircle(height: 62, width: 62, iconSize: 42)),
                Positioned(bottom: 250, right: 20, child: loveCircle()),
                Positioned(
                    top: 276,
                    left: 70,
                    child: loveCircle(height: 52, width: 52, iconSize: 30)),
                Positioned(
                    bottom: 30,
                    right: 40,
                    child: loveCircle(height: 48, width: 48, iconSize: 28)),
              ],
            ), //Stack
          ), //Center
        ),
      ),
    );
  }

  loveCircle({double width = 40, double height = 40, double iconSize = 24}) {
    return Material(
      borderRadius: BorderRadius.circular(50), // change radius size
      color: Colors.white, //button colour
      child: InkWell(
        child: SizedBox(
          width: width, height: height, //customisable size of 'button'
          child: Icon(
            Icons.favorite,
            color: _iconColorLight,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  personPhoto(String image, File _personImage, String imageName) {
    return GestureDetector(
      onTap: () => {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        elevation: 1.0,
        child: Container(
          width: 160,
          height: 200,
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

  relationshipTimeView() {
    return Center(
      child: Container(
        child: Column(
          children: [
            Text(
              "Together for",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff7E7175),
                fontFamily: "Montserrat",
              ),
            ),
            SizedBox(
              height: 12,
            ),
            _isShowTotalDate != null && _isShowTotalDate
                ? RelationYMWDItem(
                    totalRelationDays.toString(),
                    getExtension(getTotalDate(_selectedDate), "Day"),
                    _totalDayColor,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RelationYMWDItem(
                        relationShipTime.years.toString(),
                        getExtension(relationShipTime.years, "Year"),
                        _totalDayColor,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      RelationYMWDItem(
                        relationShipTime.months.toString(),
                        getExtension(relationShipTime.months, "Month"),
                        _totalDayColor,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      RelationYMWDItem(
                        relationShipTime.weeks.toString(),
                        getExtension(relationShipTime.weeks, "Week"),
                        _totalDayColor,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      RelationYMWDItem(
                        relationShipTime.days.toString(),
                        getExtension(relationShipTime.days, "Day"),
                        _totalDayColor,
                      ),
                    ],
                  ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Since ${formatter.format(_selectedDate.toLocal())}",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff7E7175),
                fontFamily: "Montserrat",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      CommonTextView(
                        progressStartValue.toString(),
                        Color(0xff7E7175),
                        textSize: 14,
                      ),
                      Spacer(),
                      CommonTextView(
                        progressEndValue.toString(),
                        Color(0xff7E7175),
                        textSize: 14,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 4.0,
                    progressColor: _progressBarColor,
                    backgroundColor: _progressBarBgColor,
                    percent: progressPercent,
                    animation: true,
                  ) ,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _navigateToNextScreen(BuildContext context) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Setting()),
    );
    if (result == true) {
      setState(
        () {
          getImage(SHARE_PREF_PERSON_1_IMAGE)
              .then((value) => _personOneImage = value);
          getImage(SHARE_PREF_PERSON_2_IMAGE)
              .then((value) => _personTwoImage = value);
          getRelationTime(SHARE_PREF_RS_DATE).then((value) => {
                _selectedDate = value,
                totalRelationDays = getTotalDate(_selectedDate),
                relationShipTime = getDifferentYear(_selectedDate),
                progressStartValue = getProgressStartValue(),
                progressEndValue = getProgressEndValue(),
                progressPercent = (totalRelationDays - progressStartValue) /
                    (progressEndValue - progressStartValue)
              });
          getBoolean(SHARE_PREF_IS_SHOW_TOTAL_DAYS).then(
            (value) => _isShowTotalDate = value,
          );
          getPrefInt(SHARE_PREF_THEME).then(
            (value) => changeThemeData(ThemeType.values[value]),
          );
        },
      );
    }
  }

  int getProgressStartValue() {
    return (totalRelationDays ~/ 100 * 100);
  }

  int getProgressEndValue() {
    return (totalRelationDays ~/ 100 * 100) + 100;
  }
}

class RelationYMWDItem extends StatelessWidget {
  final text, data, totalDayColor;

  RelationYMWDItem(this.text, this.data, this.totalDayColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonTextView(
          text,
          totalDayColor,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          width: 2.0,
        ),
        CommonTextView(
          data,
          Color(0xff7E7175),
          textSize: 12,
        ),
      ],
    );
  }
}

class CommonTextView extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight fontWeight;

  CommonTextView(
    this.text,
    this.textColor, {
    this.textSize = 32,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: textSize,
          fontWeight: fontWeight,
          fontFamily: "Montserrat",
          color: textColor),
    );
  }
}
