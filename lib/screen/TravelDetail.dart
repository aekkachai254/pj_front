import 'dart:convert';

import 'package:applicaiton/screen/Map.dart';
import 'package:applicaiton/screen/TakePhoto.dart';
import 'package:applicaiton/screen/TravelList.dart';
import 'package:applicaiton/screen/dream.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TravelDetailScreen extends StatefulWidget {
  @override
  _TravelDetailScreenState createState() => _TravelDetailScreenState();
}

class _TravelDetailScreenState extends State<TravelDetailScreen> {
  List<String> location = [];
  List<String> address1 = [];
  List<String> invoice = [];
  List<String> images = [];

  final List<String> location2 = [
    "สถานที่ 1: Big C",
    "สถานที่ 2: Lotus's",
  ];
  final List<String> address2 = [
    "ที่อยู่ 90/041 ตำบลบ้านหลวง อำเภอจอมทอง จังหวัดเชียงใหม่ 50160",
    "ที่อยู่ 80/121 ตำบลแม่เมาะ อำเภอแม่เมาะ จังหวัดเชียงใหม่ 50160",
  ];

  final List<String> invoice2 = [
    "INV10000100000001",
    "INV10000100000002",
  ];
  final List<String> images2 = [
    "http://teamproject.ddns.net/application/assets/images/BigC.jpg",
    "http://teamproject.ddns.net/application/assets/images/Lotus.jpg",
  ];

  // Fetch data from API
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://teamproject.ddns.net/application/api/trip_detail.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        location = List<String>.from(data['location']);
        address1 = List<String>.from(data['address1']);
        invoice = List<String>.from(data['invoice']);
        images = List<String>.from(data['images']);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, //Color(0xFF17203A),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TravelListScreen()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "รายละเอียดการเดินทาง",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black, //Color(0xFF17203A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom +
                95, //เพิ่มขึ้นที่ด้านล่างเวลาเลื่อนขึ้น ไม่ให้ข้อมูลทับซ้อนกับ Bar ล่าง
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    color: Color(0xff0A8ED9),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ข้อมูลพนักงาน",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        0, 21, 29, 37), //Color.fromRGBO(0, 14, 19, 26),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Color(0xFF0D99FF),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      ("http://teamproject.ddns.net/application/assets/images/Avatar.jpg"),
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 15),
                                  child: Expanded(
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ทะเบียนรถ: ตก7587",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "คนขับรถ: นายวิเชียร์ พลไทย",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "หมายเลขโทรศัพท์: 0985248562",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color(0xff0A8ED9),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapScreen(),
                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, color: Colors.white, size: 20),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "เส้นทาง",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
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
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: location.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 21, 29, 37),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFF0D99FF),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            child: Image.network(
                              images[index],
                              height: 200,
                              width: 250,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text(
                              location[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              address1[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "รายการสินค้า",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              invoice[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 2, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 9),
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
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
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_alt,
                                              color: Colors.white, size: 20),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "ยืนยันการส่งสินค้า",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 60,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xff0A8ED9),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductListScreen(),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.visibility,
                                              color: Colors.white, size: 20),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "ดู",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19,
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
