import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart' as configURL;
import 'Intro.dart';
import 'Home.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? systemName;
  bool _serverError = false;

  @override
  void initState() {
    super.initState();
    _getSystemName();
  }

  Future<void> _getSystemName() async {
    // Fetch data from intro.php
    Uri url = Uri.parse('${configURL.deployUrl}/intro.php');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('name')) {
          setState(() {
            systemName = data['name'];
          });
        }
      } else {
        _showAlert('มีปัญหาในการเชื่อมต่อกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      _showAlert('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }

  Future<void> _authenticateUser(String phoneNumber, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Your authentication logic here
    Uri url = Uri.parse('${configURL.deployUrl}/login.php');

    try {
      var response = await http.post(
        url,
        body: {
          'username': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('error')) {
          _showUnSuccessAlert(data['error']);
        } else {
          if (data.containsKey('message')) {
            _showSuccessAlert(data['message']);
            if (data.containsKey('status_use') && data['status_use'] == 1) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);
            }
          }
        }
      } else {
        _showAlert('มีปัญหาในการเชื่อมต่อกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      _showAlert('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showSuccessAlert(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

    // เก็บ username ลงใน SharedPreferences
    await prefs.setString('username', _phoneNumberController.text);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the AlertDialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
  }

  void _showUnSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ลองอีกครั้ง'),
          ),
        ],
      ),
    );
  }

  void _showAlert(String message) {
    if (!_serverError) {
      setState(() {
        _serverError = true;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('แจ้งเตือนระบบ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroScreen(),
                  ),
                );
              },
              child: Text('เข้าใจแล้ว'),
            ),
          ],
        ),
      );
    }
  }

  Widget buildPhoneNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'หมายเลขโทรศัพท์',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Color(0xff0A8ED9),
              ),
              hintText: 'หมายเลขโทรศัพท์',
              hintStyle: TextStyle(color: Colors.black38),
              hintMaxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'รหัสผ่าน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              prefixIcon: const Icon(
                Icons.lock,
                color: Color(0xff0A8ED9),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xffBDBDBD),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              hintText: 'รหัสผ่าน',
              hintStyle: const TextStyle(color: Colors.black38),
              hintMaxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const IntroScreen();
                },
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (systemName == null)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 60.0),
                  child: const CircularProgressIndicator(),
                )
              else
                Column(
                  children: [
                    Text(
                      systemName!,
                      style: const TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    buildPhoneNumber(),
                    const SizedBox(height: 10.0),
                    buildPassword(),
                    const SizedBox(height: 30.0),
                    InkWell(
                      onTap: _isLoading
                          ? null
                          : () async {
                              String phoneNumber = _phoneNumberController.text;
                              String password = _passwordController.text;
                              await _authenticateUser(phoneNumber, password);
                            },
                      child: Container(
                        width: 240,
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
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.login,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'เข้าสู่ระบบ',
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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
