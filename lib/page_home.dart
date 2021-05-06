import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_and_me/page_setting.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext context;
  File _personOneImage;
  File _personTwoImage;
  DateTime _selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _getImage("image1", 1);
    _getImage("image2", 2);
    _getRelationTime();

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
            // Icon(Icons.settings, color: Color(0xfffd7f75))
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
                    child:
                    personPhoto("images/male.jpg", _personTwoImage, id: 1)),
                Positioned(
                    top: 60,
                    child: personPhoto("images/female.jpg", _personOneImage,
                        id: 1)),
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

  personPhoto(String image, File _personImage, {int id = 1}) {
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
            Text(
              "1,761 days",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  color: Color(0xffff495a)),
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
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Setting()),
    );
    setState(() {
      _getImage("image1", 1);
      _getImage("image2", 2);
    });
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
