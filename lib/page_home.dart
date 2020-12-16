import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  onTap: () {},
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
                child: coupleImages(context),
              ),
              Expanded(flex: 1, child: relationshipTime()),
            ],
          ),
        ),
      ),
    );
  }
}

coupleImages(BuildContext context) {
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
                  right: 0, bottom: 60, child: personPhoto("images/male.jpg")),
              Positioned(top: 60, child: personPhoto("images/female.jpg")),
              Positioned(top: 0, left: 30, child: loveCircle()),
              Positioned(
                  top: 40,
                  left: 138,
                  child: loveCircle(height: 48, width: 48, iconSize: 28)),
              Positioned(
                  bottom: 166,
                  left: 128,
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

personPhoto(String image) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    elevation: 12.0,
    child: Container(
      width: 160,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
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
            style: TextStyle(fontSize: 18, color: Color(0xff7E7175)),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "2741 days",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xffff495a)),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Since 16/06/2013",
            style: TextStyle(fontSize: 18, color: Color(0xff7E7175)),
          ),
        ],
      ),
    ),
  );
}
