import 'dart:convert';

import 'package:applicaiton/api_config.dart' as configURL;
import 'package:applicaiton/screen/Accident.dart';
import 'package:applicaiton/screen/ProductList.dart';
import 'package:applicaiton/screen/TakePhoto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Profile.dart';
import 'TravelList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String titlename = '';
  late String firstname = '';
  late String surname = '';
  late String username;
  bool _isLoading = true;
  late String picture; // Added this line to declare picture variable

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? '';
    setState(() {
      username = storedUsername;
    });
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final url = Uri.parse(
        '${configURL.deployApiUrl}/home.php?username=$username');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer API@Application1234!',
      },
    );

    if (response.statusCode == 200) {
      final userProfile = jsonDecode(response.body);
      setState(() {
        titlename = userProfile['titlename'];
        firstname = userProfile['firstname'];
        surname = userProfile['surname'];
        picture = userProfile['picture'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xFF0464F5),
          unselectedItemColor: const Color(0xFF526480),
          selectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(username: username),
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "ข้อมูลผู้ใช้"),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          /*gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              /*Color(0xFFABC0FF),
              Color(0xFF28316C),*/
              Color(0xFF040512),
              Color(0xFF28316C),
              Color(0xFF040512),
            ],
          ),*/
          color: Color(0xFF17203A),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFF0464F5),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          backgroundImage:
                              _isLoading ? null : NetworkImage(picture),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ยินดีต้อนรับ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$titlename$firstname $surname',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TravelListScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFFCE4F),
                                      Color(0xFFFFB904),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(60),
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'รายการเดินทาง',
                                        style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.network(
                                        'http://teamproject.ddns.net/application/assets/images/destination2.png',
                                        height: 70,
                                        width: 70,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AccidentScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFF4C4C),
                                      Color(0xFFFF0404),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(60),
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'อุบัติเหตุ',
                                        style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.network(
                                        'http://teamproject.ddns.net/application/assets/images/alarm1.png',
                                        height: 70,
                                        width: 70,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF2DD8C4),
                                      Color(0xFF0CC0AB),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(60),
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'รายการสินค้า',
                                        style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.network(
                                        'http://teamproject.ddns.net/application/assets/images/features.png',
                                        height: 70,
                                        width: 70,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TakePhotoScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF8196FF),
                                      Color(0xFF5E79FF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(60),
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'เช็คสต็อกสินค้า',
                                        style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.network(
                                        'http://teamproject.ddns.net/application/assets/images/scanner.png',
                                        height: 70,
                                        width: 70,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
