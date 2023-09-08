import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UI',
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 88,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Svg(
                        "assets/wave-top.svg",
                        size: Size(
                          MediaQuery.of(context).size.width,
                          100,
                        ), // Size
                      ), // Svg
                    ), // DecorationImage
                  ), // BoxDecoration
                ), // Container
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/lock.png"),
                    ), // DecorationImage
                  ), // BoxDecoration
                ), // Container
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ), // TextStyle
                ), // Text
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 40),
                  width: MediaQuery.of(context).size.width * .75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .2),
                        blurRadius: 5,
                        spreadRadius: 4,
                        offset: Offset(2, 4),
                      ), // BoxShadow
                    ], // <BoxShadow>[]
                  ), // BoxDecoration
                  child: const Column(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ), // UnderlineInputBorder
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ), // UnderlineInputBorder
                          hintText: "Email",
                          contentPadding: EdgeInsets.fromLTRB(12, 20, 2, 20),
                        ), // InputDecoraion
                      ), // TextField
                      TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(12, 20, 2, 20),
                        ), // InputDecoration
                      ), // TextField
                    ], // <Widget>[]
                  ), // Column
                ), // Container
                InkWell(
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(233, 45, 45, 1),
                          Color.fromRGBO(233, 45, 45, .8),
                        ], // <Color>[]
                      ), // LinearGradient
                    ), // BoxDecoration
                    child: const Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ), // TextStyle
                      ), // Text
                    ), // Center
                  ), // Container
                ), // InkWell
                SizedBox(
                  height: MediaQuery.of(context).size.height - 698,
                ), // SizedBox
                Container(
                  height: 88,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Svg(
                        "assets/wave-bot.svg",
                        size: Size(
                          MediaQuery.of(context).size.width,
                          100,
                        ), //Size
                      ), //Svg
                    ), // DecorationImage
                  ), // BoxDecoration
                ), // Container
              ], // <Widget>[]
            ), // Column
          ), // SingleChildScrollView
        ), // Scaffold
      ), // SafeArea
    ); // MaterialApp
  }
}