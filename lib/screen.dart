import 'package:dictionary/words.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dictionary/data.dart';
import 'package:dictionary/db.dart';
import 'package:translator/translator.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  TextEditingController _inputController = TextEditingController();
  TextEditingController _outputController = TextEditingController();
  final controller = TextEditingController();
  int _selectedIndex = 0;
  String searchVal = '';
  bool isKhmerToEnglish = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  
  Future<void> searchWords(String query) async {
    DBUtil db = DBUtil();
    List<Map<String, Object?>> results = await db
        .select("SELECT * FROM items WHERE word LIKE '$query%' LIMIT 100");
    Get.find<MyData>().list = results;
    setState(() {});
  }

  void _translate() async {
    String text = _inputController.text.trim();
    if (text.isEmpty) return;

    final translator = GoogleTranslator();

    String fromLang = isKhmerToEnglish ? 'km' : 'en';
    String toLang = isKhmerToEnglish ? 'en' : 'km';

    Translation translation = await translator.translate(
      text,
      from: fromLang,
      to: toLang,
    );

    setState(() {
      _outputController.text = translation.text;
    });
  }

  void toggleTranslationDirection() {
    setState(() {
      isKhmerToEnglish = !isKhmerToEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary',
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 226, 224, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 249, 211, 212),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.translate),
              Text(
                'Wordwise Dictionary',
                style: TextStyle(
                  color: Color.fromARGB(255, 158, 62, 62),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.grid_view),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Column(
              children: [
                SizedBox(height: 30),
                Container(
                  // color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300.0,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  controller.clear();
                                  searchWords(''); 
                                },
                              ),
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 10.0,
                              ),
                            ),
                            onChanged: (value) {
                              searchWords(
                                  value); 
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [ListWordWidget()])),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Language(isKhmerToEnglish ? 'Khmer' : 'English'),
                          IconButton(
                            icon: Icon(Icons.swap_horiz),
                            onPressed: () {
                              toggleTranslationDirection(); 
                            },
                          ),
                          Language(isKhmerToEnglish ? 'English' : 'Khmer'),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: double
                            .infinity, 
                        child: TextField(
                          controller: _inputController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: isKhmerToEnglish
                                ? 'បញ្ចូលអក្សរខ្មែរ...'
                                : 'Enter English text...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _translate,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Color.fromARGB(255, 143, 105, 105), 
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // 
                          ),
                        ),
                        child: Text(
                          isKhmerToEnglish
                              ? 'បកប្រែជាភាសាអង់គ្លេស'
                              : 'Translate to Khmer',
                          style: TextStyle(
                            fontSize: 16, 
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: double
                            .infinity, 
                        child: TextField(
                          controller: _outputController,
                          maxLines: 5,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: isKhmerToEnglish
                                ? 'អត្ថបទដែលបានបកប្រែនឹងបង្ហាញនៅទីនេះ...'
                                : 'Translated text will be appear here...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [HistoryTab()],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Get in touch with  the Developer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Your Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Message Sent'),
                              content: Text('Your message has been sent!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        nameController.clear();
                        emailController.clear();
                        messageController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Color.fromARGB(255, 143, 105, 105), 
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), 
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), 
                        ),
                      ),
                      child: Text(
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.asset(
                                'assets/cat.png',
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Heng Panha',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                width: 200, 
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FaIcon(FontAwesomeIcons.facebook,
                                        color: Color.fromARGB(255, 0, 82, 236)),
                                    FaIcon(FontAwesomeIcons.instagram,
                                        color:
                                            Color.fromARGB(255, 255, 25, 90)),
                                    FaIcon(FontAwesomeIcons.telegram,
                                        color:
                                            Color.fromARGB(215, 35, 147, 179)),
                                    FaIcon(FontAwesomeIcons.twitter,
                                        color:
                                            Color.fromARGB(255, 13, 127, 233)),
                                    FaIcon(FontAwesomeIcons.github,
                                        color: Color.fromARGB(255, 45, 5, 13)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment
                                  .center, 
                              child: Text(
                                'Have fun learning new words!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign
                                    .center, 
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: FlashyTabBar(
          backgroundColor: Color.fromARGB(255, 249, 211, 212),
          selectedIndex: _selectedIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
          }),
          items: [
            FlashyTabBarItem(
              icon: Icon(Icons.auto_stories,
                  size: MediaQuery.of(context).size.width * 0.05),
              title: Text(
                'Dictionary',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.030),
              ),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.translate,
                  size: MediaQuery.of(context).size.width * 0.05),
              title: Text(
                'Translate',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.030),
              ),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.history,
                  size: MediaQuery.of(context).size.width * 0.05),
              title: Text(
                'History',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.030),
              ),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.more_horiz,
                  size: MediaQuery.of(context).size.width * 0.05),
              title: Text(
                'More',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.030),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget ListWordWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: Get.find<MyData>()
        .list
        .map(
          (e) => Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Set the selected word item
                  Get.find<MyData>().item = e;
                  // Check if the word is already in history
                  if (!isWordInHistory(e)) {
                    // Add the word to history if it's not already there
                    Get.find<MyData>().history.add(e);
                  }
                  // Navigate to the 'Words' screen
                  Get.to(Words());
                },
                child: Container(
                  width: 300,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 143, 105, 105),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e['word'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .toList(),
  );
}

Widget HistoryTab() {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Get.find<MyData>()
          .history
          .map(
            (e) => GestureDetector(
              onTap: () {
                Get.find<MyData>().item = e;
                Get.to(Words());
              },
              child: Container(
                width: 300,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 143, 105, 105),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e['word'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

Widget Language(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

bool isWordInHistory(Map<String, Object?> word) {
  var history = Get.find<MyData>().history;
  // Check if the word's 'id' or 'word' already exists in history
  return history.any((element) =>
      element['id'] == word['id'] || element['word'] == word['word']);
}
