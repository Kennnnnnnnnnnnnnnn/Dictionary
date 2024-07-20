import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'data.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class Words extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Words> {
  final controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
    await flutterTts.setLanguage('km-KH');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Color favoriteIconColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 249, 211, 212),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Wordwise Dictionary',
                style: TextStyle(
                  color: Color.fromARGB(255, 158, 62, 62),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.grid_view, color: Colors.black),
            ],
          ),
        ),
        body: Container(
          color: Color.fromARGB(255, 226, 224, 255),
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Get.find<MyData>().item['word'],
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: 100,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: Get.find<MyData>().item['word']),
                        );
                        Get.snackbar(
                          'Copied!',
                          'Word has been copied',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.grey,
                          colorText: Colors.white,
                        );
                      },
                      child: Icon(Icons.copy, color: Colors.black, size: 30),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                         
                          favoriteIconColor = favoriteIconColor == Colors.black
                              ? Colors.red
                              : Colors.black;
                        });
                      },
                      child: Icon(
                        Icons.favorite,
                        color: favoriteIconColor,
                        size: 30,
                      ),
                    ),

                    // Icon(Icons.volume_down, color: Colors.black, size: 30),
                    GestureDetector(
                      onTap: () {
                        // speak('hello ');
                        speak(Get.find<MyData>().item['word']);
                      },
                      child: Icon(Icons.volume_down,
                          color: Colors.black, size: 30),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(),
              ),
              SizedBox(height: 5),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(),
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(),
              ),
              SizedBox(height: 5),
              Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextBlack(
                                  Get.find<MyData>().item['definition']),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Words() {
    return Container(
      width: 350,
      height: 150,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 228, 204, 204),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.sunny, color: Colors.black),
          TextBlack(Get.find<MyData>().item['word']),
          Icon(Icons.favorite, color: Colors.black),
        ],
      ),
    );
  }

  Widget TextBlack(String val) {
    return HtmlWidget(
      val,
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
