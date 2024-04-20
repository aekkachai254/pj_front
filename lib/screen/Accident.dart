import 'dart:async';
import 'dart:convert';

import 'package:applicaiton/screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class AccidentScreen extends StatefulWidget {
  final String username;
  const AccidentScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<AccidentScreen> createState() => _AccidentScreenState();
}

class _AccidentScreenState extends State<AccidentScreen>
    with TickerProviderStateMixin {
  bool isPressed = false;
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  late Animation<double> _innerAnimation;
  bool isDataSent = false;
  bool isReportReceived = false;
  GoogleMapController? mapController;
  LocationData? currentLocation;
  String currentAddress = "";
  TextEditingController _textEditingController = TextEditingController();
  Color backgroundColor = Color(0xFF385194);
  String statusText = "สถานะ: ปกติ";
  String currentText = "";
  String contactText = "";
  Color middle = Color(0xFF17203A);
  Color edge1 = Color(0xFF54B9C7);
  Color edge2 = Color(0xFF0D99FF);
  Color button = Color(0xFF0D99FF);
  bool isButtonEnabled = true;
  late Timer timer;

  void setReportReceived() {
    isReportReceived = true;

    Timer(Duration(seconds: 8), () {
      setState(() {
        if (statusText == "สถานะ: รับการแจ้งเตือน") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AccidentScreen(username: widget.username),
            ),
          );
        }
      });
    });
  }

  void onPressedButton() {
    Future.delayed(Duration(seconds: 8), () {
      if (statusText == "สถานะ: รอการแจ้งเตือน") {
        setReportReceived();
      }
    });
  }

  void onTapButton() async {
    if (isButtonEnabled) {
      isButtonEnabled = false;
      if (_textEditingController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("แจ้งเตือน"),
              content: Text("กรุณาใส่ข้อความแจ้งเหตุ"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isButtonEnabled = true;
                  },
                  child: Text("ตกลง"),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("การยืนยัน"),
              content: Text(isPressed
                  ? "คุณต้องการยกเลิกการรายงานอุบัติเหตุ"
                  : "คุณแน่ใจหรือไม่ว่าต้องการารายงานอุบัติเหตุ"),
              actions: [
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isPressed = !isPressed;
                      if (isDataSent) {
                        isDataSent = false;
                      }
                    });
                    Navigator.of(context).pop();
                    await postData(
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      _textEditingController.text,
                    );
                  },
                  child: Text("ยกเลิก"),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isPressed = !isPressed;
                      if (isPressed) {
                        _controller.repeat(reverse: true);
                      } else {
                        _controller.stop();
                      }
                    });
                    Navigator.of(context).pop();
                    onPressedButton(); // เรียกใช้ onPressedButton() เมื่อกดปุ่ม
                  },
                  child: Text("ยืนยัน"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void getCurrentLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
        ),
      );

      setState(() {
        getAddressFromLatLng(
            currentLocation!.latitude!, currentLocation!.longitude!);
      });
    } catch (e) {
      print('Error getting location: $e');
    }

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
        mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
          ),
        );

        getAddressFromLatLng(
            currentLocation!.latitude!, currentLocation!.longitude!);
      });
    });
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    String apiKey = "e3dc6cdb0b9f0eb660a9ba4baffc64f3";
    String url =
        "https://api.longdo.com/map/services/address?lon=$longitude&lat=$latitude&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null) {
          String aoi = jsonData['aoi'] ?? '';
          String subdistrict = jsonData['subdistrict'] ?? '';
          String district = jsonData['district'] ?? '';
          String province = jsonData['province'] ?? '';
          String postcode = jsonData['postcode'] ?? '';
          String country = jsonData['country'] ?? '';

          setState(() {
            currentAddress =
                "$aoi $subdistrict $district $province $postcode $country\n พิกัด: ${currentLocation!.latitude}, ${currentLocation!.longitude} ";
            backgroundColor = isPressed
                ? isReportReceived
                    ? Color(0xFF3F9438)
                    : Color(0xFFB5404D)
                : Color(0xFF385194);
            statusText = isPressed
                ? isReportReceived
                    ? "สถานะ: รับการแจ้งเตือน"
                    : "สถานะ: รอการแจ้งเตือน"
                : "สถานะ: ปกติ";
            contactText = isPressed
                ? isReportReceived
                    ? "ได้รับการรับเรื่องแจ้งเหตุแล้ว"
                    : "กำลังติดต่อไปที่ศูนย์ควบคุม"
                : "กรุณากดแจ้งเตือน เมื่ออุบัติเหตุ";
            currentText = isPressed
                ? isReportReceived
                    ? "ตำแหน่งที่อยู่:  $currentAddress"
                    : "ตำแหน่งที่อยู่:  $currentAddress"
                : " ";
            middle = isPressed
                ? isReportReceived
                    ? Color(0xFF163B1E)
                    : Color(0xFFEF1A1A)
                : Color(0xFF17203A);
            edge1 = isPressed
                ? isReportReceived
                    ? Color(0xFF75CE8E)
                    : Color(0xFFC55460)
                : Color(0xFF54B9C7);
            edge2 = isPressed
                ? isReportReceived
                    ? Color(0xFF5CC753)
                    : Color(0xFFCF7680)
                : Color(0xFF75C8CD);
            button = isPressed
                ? isReportReceived
                    ? Color(0xFF13FF0E)
                    : Color(0xFFE62935)
                : Color(0xFF0D99FF);
          });

          await postData(
            aoi,
            subdistrict,
            district,
            province,
            postcode,
            country,
            _textEditingController.text,
          );
        } else {
          setState(() {
            currentAddress = "ไม่สามารถดึงข้อมูลตำแหน่งได้";
          });
        }
      }
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        currentAddress = "ไม่สามารถดึงข้อมูลตำแหน่งได้ (เกิดข้อผิดพลาด)";
        backgroundColor = isPressed ? Color(0xFF847916) : Color(0xFF385194);
        statusText = isPressed ? "สถานะ: แจ้งข้อผิดพลาด" : "สถานะ: ปกติ";
        contactText = isPressed
            ? "เกิดข้อผิดพลาด\nกรุณาลองใหม่อีกครั้ง"
            : "กรุณากดแจ้งเตือน เมื่ออุบัติเหตุ";
        currentText = isPressed ? "ตำแหน่งที่อยู่:  $currentAddress" : " ";
        middle = isPressed ? Colors.yellow : Color(0xFF17203A);
        edge1 = isPressed ? Color(0xFFCECA76) : Color(0xFF54B9C7);
        edge2 = isPressed ? Color(0xFFB5BE48) : Color(0xFF75C8CD);
        button = isPressed ? Color(0xFFDDFF0E) : Color(0xFF0D99FF);
      });
    }
  }

  Future<void> postData(String aoi, String subdistrict, String district,
      String province, String postcode, String country, String detail) async {
    if (!isDataSent) {
      String url = "http://teamproject.ddns.net/application/api/accident.php";
      Map<String, String> data = {
        "username": widget.username,
        "aoi": aoi,
        "subdistrict": subdistrict,
        "district": district,
        "province": province,
        "postcode": postcode,
        "country": country,
        "currentlocation_latitude": currentLocation!.latitude.toString(),
        "currentlocation_longitude": currentLocation!.longitude.toString(),
        "detail": detail, // เพิ่มข้อความจาก TextField
      };

      try {
        var response = await http.post(
          Uri.parse(url),
          body: data,
        );

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          // เช็คว่ามีค่า 'error' ใน response หรือไม่
          if (responseData.containsKey('error')) {
            print("Failed to post data. Error: ${responseData['error']}");
          } else {
            // เช็คว่ามีค่า 'message' ใน response หรือไม่
            if (responseData.containsKey('message')) {
              print(responseData['message']);
              setState(() {
                isDataSent = true;
              });
            }
            // เช็คว่ามีค่า 'status' ใน response หรือไม่
            if (responseData.containsKey('status')) {
              if (responseData['status'] != 'N/A') {
                setState(() {
                  isPressed = true;
                  isReportReceived =
                      responseData['status'] == '1' ? true : false;
                });
                onPressedButton(); // เมื่อกดปุ่ม
              }
            }
          }
        } else {
          print("Failed to post data. Error code: ${response.statusCode}");
        }
      } catch (e) {
        print("Error posting data: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _borderAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(_controller);
    _innerAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: GestureDetector(
                  onTap: onTapButton,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: middle,
                        border: Border.all(
                          color: edge1,
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
                                    color: edge2,
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
            Text(
              contactText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: Text(
                  currentText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // จัดข้อความให้อยู่ตรงกลาง
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF0D99FF),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                      ),
                      child: TextField(
                        readOnly: isPressed,
                        decoration: InputDecoration(
                          hintText:
                              isPressed ? null : 'กรุณากรอกข้อความแจ้งเหตุ',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _textEditingController,
                      ))),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Container(
                  width: 250.0,
                  decoration: BoxDecoration(
                    color: button,
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
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
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
    );
  }
}
