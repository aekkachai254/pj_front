import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // เพิ่มไลบรารีใหม่
import 'package:http/http.dart' as http;
import '../api_config.dart' as configURL;
import 'Login.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isLoading = true;
  late String _systemLogo;
  late String _systemName;
  bool _serverError = false;

  @override
  void initState() {
    super.initState();
    // Fetch data from API
    _fetchSystem();
  }

  void _fetchSystem() async {
    try {
      final response =
          await http.get(Uri.parse('${configURL.deployUrl}/intro.php'));
      if (response.statusCode == 200) {
        final dataSystem = json.decode(response.body);
        setState(() {
          _systemLogo = dataSystem['logo'];
          _systemName = dataSystem['name'];
          _isLoading = false;
        });
      } else {
        _showConnectionErrorDialog();
      }
    } catch (e) {
      _showConnectionErrorDialog();
    }
  }

  void _showConnectionErrorDialog() {
    if (!_serverError) {
      setState(() {
        _serverError = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false, // prevent dismissing dialog on tap outside
        builder: (context) => AlertDialog(
          title: Text('ขาดการเชื่อมต่อ'),
          content: Text(
              'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ โปรดตรวจสอบเครือข่ายของคุณ'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the app when "ปิดแอป" button is pressed
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Text('ปิดแอป'),
            ),
          ],
        ),
      );
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
                          _systemLogo,
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
                if (!_serverError)
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
