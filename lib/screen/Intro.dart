import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isLoading = true;
  late String _systemName;

  @override
  void initState() {
    super.initState();
    // Fetch data from API
    _fetchSystemName();
  }

  void _fetchSystemName() async {
    final response = await http.get(
        Uri.parse('http://teamproject.ddns.net/application/api/intro.php'));
    if (response.statusCode == 200) {
      final dataSystem = json.decode(response.body);
      setState(() {
        _systemName = dataSystem['name'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load system name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.only(top: 100, bottom: 40),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, -100),
                child: Transform.scale(
                  scale: 1.50,
                  child: _isLoading
                      ? CircularProgressIndicator() // Show CircularProgressIndicator while loading
                      : Image.network(
                          "http://teamproject.ddns.net/application/assets/images/intro_picture.png",
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: const Offset(4, 7),
                  child: _isLoading
                      ? CircularProgressIndicator() // Show CircularProgressIndicator while loading
                      : Text(
                          _systemName,
                          style: const TextStyle(
                            fontFamily: 'Pacifico',
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 80),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
    );
  }
}
