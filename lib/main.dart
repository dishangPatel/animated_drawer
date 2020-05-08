import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  final pi = math.pi;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        value: 0, vsync: this, duration: Duration(milliseconds: 250));
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp
        ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();
  void close() {
    animationController.reverse();
  }

  void open() {
    animationController.forward();
  }

  double minDragStartEdge = 300.0;
  double maxDragStartEdge = 150;
  double maxSlide = 225.0;
  bool canBeDragged;

  void _onDragStart(DragStartDetails details) {
    print(details.globalPosition);
    bool _isDragOpenedFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool _isDragClosedFromRight = animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;
    canBeDragged = _isDragOpenedFromLeft || _isDragClosedFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted)
      return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5)
      close();
    else
      open();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.blue,
              body: Container(
                padding: EdgeInsets.only(left: 5.0, top: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 25.0, left: 10.0),
                        child: Text(
                          "Dishang",
                          style: TextStyle(color: Colors.white, fontSize: 45.0),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "@dishang09",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                          textAlign: TextAlign.left,
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Favourite",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Divider(
                        color: Colors.white,
                        thickness: .7,
                        endIndent: 180.0,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title:
                          Text("Info", style: TextStyle(color: Colors.white)),
                      subtitle: Divider(
                        color: Colors.white,
                        thickness: .7,
                        endIndent: 180.0,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      title: Text("Setting",
                          style: TextStyle(color: Colors.white)),
                      subtitle: Divider(
                        color: Colors.white,
                        thickness: .7,
                        endIndent: 180.0,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      title:
                          Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, _) {
                double slide = animationController.value * maxSlide;
                double scale = 1 - (animationController.value * 0.3);
                return Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..scale(scale)
                    ..translate(slide),
                  child: GestureDetector(
                    onTap: toggle,
                    child: Scaffold(
                      appBar: AppBar(
                        leading: Icon(Icons.menu),
                      ),
                      body: Container(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
