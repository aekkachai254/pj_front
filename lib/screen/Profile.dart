import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart' as configURL;
import 'package:shared_preferences/shared_preferences.dart';
import 'Intro.dart';
import 'Home.dart';
import 'Login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _serverError = false;
  late Map<String, dynamic> _userProfile = {};

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    if (_serverError) {
      return Scaffold();
    } else {
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
                  _buildUserProfile(),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        if (_isLoading)
          CircularProgressIndicator()
        else
          Container(
            width: 115,
            height: 115,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue, // สีของกรอบ
                width: 2, // ขนาดของกรอบ
              ),
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: const Color(0xFF0464F5),
              child: CircleAvatar(
                radius: 53,
                backgroundColor: Colors.white,
                backgroundImage: _userProfile['picture'] != null &&
                        _userProfile['picture'].isNotEmpty
                    ? NetworkImage(_userProfile['picture'])
                    : NetworkImage('${configURL.imageUrl}/placeholder.png'),
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          '${_userProfile['titlename']}${_userProfile['firstname']} ${_userProfile['surname']}',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          'เลขประจำตัว : ${_userProfile['id']}',
          style: const TextStyle(fontSize: 18, color: Colors.white),
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
            _userProfile['position'] ?? '',
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
            _userProfile['birthday'] ?? '',
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
            _userProfile['email'] ?? '',
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
            _userProfile['telephone'] ?? '',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () async {
        bool logoutConfirmed = await _showLogoutDialog(context);
        if (logoutConfirmed) {
          _logout();
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'ออกจากระบบ',
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
    );
  }

  Future<void> _fetchUserProfile(String username) async {
    try {
      final response = await http.get(
        Uri.parse('${configURL.deployUrl}/profile.php?username=$username'),
        headers: {
          'Authorization':
              'Bearer API@Application1234!', // Replace with your actual token
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        _userProfile = json.decode(response.body);
      } else {
        _showAlert('มีปัญหาในการเชื่อมต่อกับเซิร์ฟเวอร์');
        throw Exception('มีปัญหาในการเชื่อมต่อกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      _showAlert('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
      throw Exception('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ออกจากระบบ'),
              content: const Text('คุณต้องการออกจากระบบหรือไม่ ?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // ยืนยันการออกจากระบบ
                  },
                  child: const Text('ออกจากระบบ'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // ยกเลิกการออกจากระบบ
                  },
                  child: const Text('ยกเลิก'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('${configURL.deployUrl}/logout.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer API@Application1234!', // Replace with actual token
        },
        body: json.encode({'username': widget.username}),
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        Map<String, dynamic> responseData = json.decode(response.body);
        _showLogoutSuccessAlert(responseData['message']);
        await Future.delayed(const Duration(seconds: 2)); // รอเวลา 2 วินาที
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        _showAlert(errorData['error']);
      }
    } catch (e) {
      _showAlert('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLogoutSuccessAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16.0),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showAlert(String message) {
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
