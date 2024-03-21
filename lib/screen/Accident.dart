import 'dart:convert';

import 'package:applicaiton/screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccidentScreen extends StatefulWidget {
  const AccidentScreen({Key? key}) : super(key: key);

  @override
  State<AccidentScreen> createState() => _AccidentState();
}

class _AccidentState extends State<AccidentScreen>
    with TickerProviderStateMixin {
  bool isPressed = false;
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  late Animation<double> _innerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create separate animations for border width and inner circle scale
    _borderAnimation = Tween<double>(begin: 1.0, end: 1.4)
        .animate(_controller); // Increased pulse range
    _innerAnimation = Tween<double>(begin: 1.0, end: 0.7)
        .animate(_controller); // Adjusted end scale for sharper pulse
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendAccidentReport() async {
    final url =
        Uri.parse('http://teamproject.ddns.net/application/api/accident.php');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'isAccident': isPressed,
        }),
      );

      if (response.statusCode == 200) {
        print('Accident report sent successfully');
      } else {
        print(
            'Failed to send accident report. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isPressed ? Color(0xFFB5404D) : Color(0xFF385194),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("การยืนยัน"),
                          content: Text(isPressed
                              ? "คุณต้องการยกเลิกการรายงานอุบัติเหตุ"
                              : "คุณแน่ใจหรือไม่ว่าต้องการายงานอุบัติเหตุ"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("ยกเลิก"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isPressed = !isPressed;
                                  if (isPressed) {
                                    _controller.repeat(reverse: true);
                                  } else {
                                    _controller.stop();
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text("ยืนยัน"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isPressed ? Color(0xFFEF1A1A) : Color(0xFF17203A),
                        border: Border.all(
                          color:
                              isPressed ? Color(0xFFC55460) : Color(0xFF54B9C7),
                          width: _borderAnimation.value * (15 - 4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.7),
                            spreadRadius: -5,
                            blurRadius: 7,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _borderAnimation,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: isPressed
                                        ? Color(0xFFCF7680)
                                        : Color(0xFF75C8CD),
                                    width: _borderAnimation.value * (15 - 5),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _innerAnimation,
                            builder: (context, child) {
                              return ScaleTransition(
                                scale: _innerAnimation,
                                child: Center(
                                  child: Text(
                                    "SOS",
                                    style: TextStyle(
                                      color: isPressed
                                          ? Colors.white
                                          : Colors.white,
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              isPressed
                  ? "กำลังติดต่อไปที่ศูนย์ควบคุม"
                  : "กรุณากดแจ้งเตือน เมื่ออุบัติเหตุ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Center(
                child: Text(
                  isPressed
                      ? "ตำแหน่งของคุณ: 9/1 หมู่ที่ 5 ถ.พหลโยธิน คลองหนึ่ง อำเภอคลองหลวง ปทุมธานี 12120"
                      : "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Container(
                    width: 250.0,
                    decoration: BoxDecoration(
                      color: isPressed ? Color(0xFFE62935) : Color(0xFF0D99FF),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.white, width: 1.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'กลับ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
