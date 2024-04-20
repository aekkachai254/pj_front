import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_config.dart' as configURL;
import 'Accident.dart';
import 'CheckproductScan.dart';
import 'Intro.dart';
import 'Profile.dart';
import 'Trip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String titlename = '';
  late String firstname = '';
  late String surname = '';
  late String username = '';
  bool _isLoading = true;
  late String picture = '';
  bool _serverError = false;

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
    if (username.isNotEmpty) {
      _fetchUserProfile();
    } else {
      // Handle case where username is empty
    }
  }

  void _showAlert(String message) {
    if (!_serverError) {
      setState(() {
        _serverError = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือนระบบ'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด AlertDialog เดิม
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroScreen(),
                    ),
                  );
                },
                child: Text("เข้าใจแล้ว"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _fetchUserProfile() async {
    final url = Uri.parse('${configURL.deployUrl}/home.php?username=$username');

    try {
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
        _showAlert('มีปัญหาในการเชื่อมต่อกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      _showAlert('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_serverError) {
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "หน้าหลัก"),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "ข้อมูลผู้ใช้",
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF040512),
                Color(0xFF28316C),
                Color(0xFF040512),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(username: username),
                            ),
                          );
                        },
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
                            SizedBox(width: 20),
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
                    ],
                  ),
                ),
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
                              builder: (context) => TripScreen(
                                username: username,
                                trip_id: '1',
                              ),
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
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${configURL.imageUrl}/destination2.png',
                                  height: 90,
                                  width: 90,
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
                                  AccidentScreen(username: username),
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
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${configURL.imageUrl}/alarm1.png',
                                  height: 90,
                                  width: 90,
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
                              builder: (context) => CheckproductScanScreen(),
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
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ตรวจสอบสินค้า',
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.network(
                                  '${configURL.imageUrl}/features.png',
                                  height: 90,
                                  width: 90,
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
        ),
      );
    } else {
      return Scaffold();
    }
  }
}
