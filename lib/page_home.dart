import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:you_and_me/page_setting.dart';
import 'package:you_and_me/resources/string.dart';
import 'package:you_and_me/utils.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext context;
  File _personOneImage;
  File _personTwoImage;
  DateTime _selectedDate = DateTime.now();
  bool _isShowTotalDate = false;
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
              relationShipTime = getDifferentYear(_selectedDate),
            },
          );
          getBoolean(SHARE_PREF_IS_SHOW_TOTAL_DAYS).then(
                (value) => _isShowTotalDate = value,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(0xfffd7f75)));
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
                  splashColor: Color(0xfffdaaa3).withOpacity(0.3),
                  child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.settings,
                        color: Color(0xfffdaaa3),
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
              Expanded(flex: 1, child: relationshipTime()),
            ],
          ),
        ),
      ),
    );
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
            color: Color(0xfffdaaa3),
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

  relationshipTime() {
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
            _isShowTotalDate
                ? CommonTextView(
                    getTotalDate(_selectedDate),
                    Color(0xffff495a),
                    fontWeight: FontWeight.w700,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RelationYMWDItem(relationShipTime.years.toString(),
                          getExtension(relationShipTime.years, "Year")),
                      SizedBox(
                        width: 12.0,
                      ),
                      RelationYMWDItem(relationShipTime.months.toString(),
                          getExtension(relationShipTime.months, "Month")),
                      SizedBox(
                        width: 12.0,
                      ),
                      RelationYMWDItem(relationShipTime.weeks.toString(),
                          getExtension(relationShipTime.weeks, "Week")),
                      SizedBox(
                        width: 12.0,
                      ),
                      RelationYMWDItem(relationShipTime.days.toString(),
                          getExtension(relationShipTime.days, "Day")),
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
                      Text(
                        "100",
                        style: TextStyle(
                          color: Color(0xff7E7175),
                          fontFamily: "Montserrat",
                        ),
                      ),
                      Spacer(),
                      Text(
                        "200",
                        style: TextStyle(
                          color: Color(0xff7E7175),
                          fontFamily: "Montserrat",
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 4.0,
                    progressColor: Color(0xffff495a),
                    backgroundColor: Color(0xfff6dbd7),
                    percent: 0.7,
                    animation: true,
                  ),
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
                relationShipTime = getDifferentYear(_selectedDate),
              });
          getBoolean(SHARE_PREF_IS_SHOW_TOTAL_DAYS).then(
            (value) => _isShowTotalDate = value,
          );
        },
      );
    }
  }
}

class RelationYMWDItem extends StatelessWidget {
  final text, data;

  RelationYMWDItem(this.text, this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonTextView(
          text,
          Color(0xffff495a),
          fontWeight: FontWeight.w700,
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
