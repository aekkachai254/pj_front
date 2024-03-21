import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'Home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool logoutConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ออกจากระบบ'),
          content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการออกจากระบบ
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // ยืนยันการออกจากระบบ
              },
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );

    if (logoutConfirmed) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              const Text("กำลังออกจากระบบ โปรดรอสักครู่..."),
            ],
          ),
        ),
      );

      final response = await http.post(
        Uri.parse('http://teamproject.ddns.net/application/api/logout.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer API@Application1234!', // แทนที่ด้วย Token ที่จริง
        },
        body: json.encode({'username': widget.username}),
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        await Future.delayed(const Duration(seconds: 2)); // รอเวลา 2 วินาที
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        print('ไม่สามารถออกจากระบบได้. สถานะ: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomeScreen();
                },
              ),
            );
          },
        ),
        title: const Text(
          "ข้อมูลผู้ใช้",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: _fetchUserProfile(widget.username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                    } else {
                      final Map<String, dynamic> userProfile = snapshot.data!;
                      String id = userProfile['id'].toString();
                      String titlename = userProfile['titlename'].toString();
                      String firstname = userProfile['firstname'].toString();
                      String surname = userProfile['surname'].toString();
                      String picture = userProfile['picture'].toString();
                      String birthday = userProfile['birthday'].toString();
                      String email = userProfile['email'].toString();
                      String telephone = userProfile['telephone'].toString();
                      String position = userProfile['position'].toString();
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: const Color(0xFF0464F5),
                            child: ClipOval(
                              child: picture.isNotEmpty
                                  ? Image.network(
                                      picture,
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    )
                                  : Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$titlename$firstname $surname',
                            style: const TextStyle(
                                fontSize: 28, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'ไอดีผู้ใช้ : $id',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                            subtitle: const Text(
                              "ตำแหน่ง",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              position,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(
                              Icons.cake,
                              size: 30,
                              color: Colors.white,
                            ),
                            subtitle: const Text(
                              "วันเกิด",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              birthday,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              size: 30,
                              color: Colors.white,
                            ),
                            subtitle: const Text(
                              "อีเมล",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              email,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              size: 30,
                              color: Colors.white,
                            ),
                            subtitle: const Text(
                              "หมายเลขโทรศัพท์",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              telephone,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                InkWell(
                  onTap: () async {
                    try {
                      setState(() {
                        _isLoading = true; // เริ่มแสดงสถานะการโหลด
                      });
                      await _logout(context);
                    } catch (e) {
                      print('Error updating user profile: $e');
                    } finally {
                      setState(() {
                        _isLoading = false; // สิ้นสุดการแสดงสถานะการโหลด
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Container(
                      width: 250.0,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    _isLoading
                                        ? 'กำลังออกจากระบบ ...'
                                        : 'ออกจากระบบ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchUserProfile(String username) async {
    final response = await http.get(
      Uri.parse(
          'http://teamproject.ddns.net/application/api/profile.php?username=$username'),
      headers: {
        'Authorization':
            'Bearer API@Application1234!', // Replace with your actual token
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userProfile = json.decode(response.body);
      return userProfile;
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
