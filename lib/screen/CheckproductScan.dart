import 'dart:convert';

import 'package:applicaiton/screen/CheckproductDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import "Home.dart";

class CheckproductScanScreen extends StatefulWidget {
  const CheckproductScanScreen({Key? key}) : super(key: key);

  @override
  State<CheckproductScanScreen> createState() => _CheckproductScanScreenState();
}

class _CheckproductScanScreenState extends State<CheckproductScanScreen> {
  bool isScanCompleted = false;
  bool isFlashOn = false; // Added this line
  bool isFrontCamera = false; // Added this line
  bool isProcessing = false;
  MobileScannerController cameraController = MobileScannerController();

  Future<void> fetchDataFromApi() async {
    try {
      final response = await http.get(
          Uri.parse('http://teamproject.ddns.net/application/api/Scan.php'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data['message'] == 'ไม่พบรหัสสินค้านี้') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('ไม่พบสินค้า'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด AlertDialog
                      setState(() {
                        isScanCompleted = false; // Set isScanCompleted to false
                      });
                    },
                    child: const Text('ตกลง'),
                  ),
                ],
              );
            },
          );
        } else if (data['message'] == 'รหัสสินค้านี้ถูกสแกนไปแล้ว') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('รหัสสินค้าถูกตรวจสอบแล้ว'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด AlertDialog
                      setState(() {
                        isScanCompleted = false; // Set isScanCompleted to false
                      });
                    },
                    child: const Text('ตกลง'),
                  ),
                ],
              );
            },
          );
        } else if (data['message'] == 'ตรวจสอบรายการสินค้าสำเร็จ') {
          // Handle successful product verification
        }
      } else {
        print(
            'Failed to load data from API. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data from API: $error');
    }
  }

  void closeScreen() {
    setState(() {
      isScanCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, //Color(0xFF212325),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "สแกนสินค้า",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              cameraController.toggleTorch();
            },
            icon: Icon(
              Icons.flash_on,
              color: isFlashOn ? Colors.white : Colors.lightBlue,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
              cameraController.switchCamera();
            },
            icon: Icon(
              Icons.flip_camera_android,
              color: isFrontCamera ? Colors.white : Colors.lightBlue,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "วางรหัส QR Code ในพื้นที่ที่กำหนดไว้",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ปล่อยให้การสแกนเริ่มทำงานอัตโนมัติ!",
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    allowDuplicates: true,
                    onDetect: (barcode, args) {
                      if (!isScanCompleted) {
                        setState(() {
                          isScanCompleted = true;
                          isProcessing = false;
                        });

                        String code = barcode.rawValue ?? "---";
                        Map<String, dynamic>? selectedProduct =
                            ProductList.firstWhere(
                          (product) =>
                              product["productCode"].toString() == code,
                          orElse: () => {},
                        );

                        if (selectedProduct != {} &&
                            selectedProduct.containsKey("productCode")) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailScreen(
                                  product: selectedProduct,
                                  closeScreen: closeScreen,
                                  ProductDetail: {},
                                  productDetail: {},
                                );
                              },
                            ),
                          ).then((_) {
                            // This code will be executed when the ProductDetailScreen is popped
                            closeScreen(); // Close the ProductDetailScreen
                          });
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.black12,
                    borderColor: Colors.grey,
                    borderRadius: 20,
                    borderStrokeWidth: 10,
                    scanAreaWidth: 270,
                    scanAreaHeight: 270,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "สแกนเพื่อตรวจสอบสินค้า",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
