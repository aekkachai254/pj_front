//import 'package:applicaiton/screen/ProductList.dart';
//import 'package:application/screen/ScanCofirm.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:vibration/vibration.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final AudioPlayer player = AudioPlayer();
  bool isProcessing = false;
  bool isScanCompleted = false;
  bool isFirstScan = true;
  bool isFlashOn = false; // Added this line
  bool isFrontCamera = false; // Added this line

  MobileScannerController cameraController = MobileScannerController();

  bool isAllItemsComplete() {
    // Check if quantity of each item in ProductList is equal to total
    return ProductList.every(
        (item) => item['quantity'] == int.parse(item['total']));
  }

  bool foundProduct = false;
  List<int> scannedProductCodes = [];

  List<Map<String, dynamic>> ProductList = [
    {
      "name": "1.ปูไทย รสปลาหมึก",
      "shelf": "P6",
      "total": "6",
      "quantity": 3,
      "productCode": 1610,
      "imagePath": "assets/images/Poothai.png",
    },
    {
      "name": "2.เลย์ รสโนริสาหร่าย",
      "shelf": "L2",
      "total": "3",
      "quantity": 0,
      "productCode": 1500,
      "imagePath": "assets/images/Lay.png",
    },
    {
      "name": "3.มาม่าคัพ รสต้มยำกุ้ง",
      "shelf": "M5",
      "total": "5",
      "quantity": 2,
      "productCode": 1212,
      "imagePath": "assets/images/MamaCup.png",
    },
    {
      "name": "4.คัพโจ๊ก",
      "shelf": "J1",
      "total": "4",
      "quantity": 0,
      "productCode": 1320,
      "imagePath": "assets/images/Joke.png",
    },
    {
      "name": "5.เนสกาแฟ เรดคัพ",
      "shelf": "C7",
      "total": "4",
      "quantity": 2,
      "productCode": 1493,
      "imagePath": "assets/images/Nescafe.png",
    },
    {
      "name": "6.น้ำตาลทรายขาว",
      "shelf": "S8",
      "total": "3",
      "quantity": 1,
      "productCode": 1222,
      "imagePath": "assets/images/Sugar.png",
    },
    {
      "name": "7.น้ำมันถั่วเหลือง",
      "shelf": "W1",
      "total": "3",
      "quantity": 2,
      "productCode": 1010,
      "imagePath": "assets/images/SoybeanOil.png",
    },
    {
      "name": "8.น้ำปลาทิพรส",
      "shelf": "W3",
      "total": "3",
      "quantity": 0,
      "productCode": 1228,
      "imagePath": "assets/images/Tiparos.png",
    },
  ];

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    bool exit = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากหน้าสแกน'),
          content: Text(
              'คุณยังเหลือรายการที่ยังตรวจสอบไม่สำเร็จอีก ${getTotalRemainingItems()} '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Do not exit
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.red,
                      width: 3,
                    ),
                  ),
                  child: const Text(
                    'ไม่',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Exit
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xFF0D99FF),
                    border: Border.all(
                      color: Color(0xFF0D99FF),
                      width: 3,
                    ),
                  ),
                  child: const Text(
                    'ใช่',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        );
      },
    ).then((value) {
      exit = value ?? false;
    });

    return exit;
  }

  String getTotalRemainingItems() {
    // ดึงรายการที่เหลือใน List ที่ currentQuantity < totalQuantity
    List<Map<String, dynamic>> remainingItems = ProductList.where(
            (product) => product['quantity'] < int.parse(product['total']))
        .toList();

    // นับจำนวนรายการที่เหลือ
    int totalRemainingItems = remainingItems.length;

    // สร้าง String ที่รวมทั้งจำนวนรายการ
    return '$totalRemainingItems รายการ';
  }

  String getRemainingItemsDetails() {
    // ดึงรายการที่เหลือใน List ที่ currentQuantity < totalQuantity
    List<String> remainingItems = ProductList.where(
            (product) => product['quantity'] < int.parse(product['total']))
        .map<String>((product) {
      // Change the format to display the quantity of each remaining item
      return ' ${product['name']} เหลือ (${int.parse(product['total']) - product['quantity']} ชิ้น) ';
    }).toList();

    // นำรายการที่เหลือมาเชื่อมต่อเป็น String
    return remainingItems.join('\n');
  }

  int currentIndex = 0; // Initialize with the first item

  void handleScannedCode(String code) async {
    int scannedCode = int.parse(code);

    Vibration.vibrate(duration: 500);
    //player.play('https://jmp.sh/s/OPNEqdxex8AHixmuYdFG');

    try {
      if (!scannedProductCodes.contains(scannedCode)) {
        scannedProductCodes.add(scannedCode);

        // ตรวจสอบว่ารหัสสินค้าตรงกับ List หรือไม่
        var product = ProductList.firstWhere(
          (element) => element['productCode'] == scannedCode,
          orElse: () => {},
        );

        if (product.isNotEmpty) {
          int currentQuantity = product['quantity'];
          int totalQuantity = int.parse(product['total']);

          if (currentQuantity < totalQuantity) {
            // กรณีตรวจสอบรายการสินค้าสำเร็จ
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 385, // Set your desired max height
                          ),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.green),
                                      SizedBox(width: 5),
                                      Text(
                                        'สแกนสินค้าสำเร็จ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'ข้อมูลสินค้า:\n ${product['name']}\n - รหัสสินค้า: $code พบที่ชั้น ${product['shelf']}',
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 43),
                                        child: Row(
                                          children: [
                                            Text('- ตรวจสอบ: '),
                                            Text(
                                              '${product['quantity']}',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text('/${product['total']} ชิ้น'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  '${product['imagePath']}',
                                  width: 110,
                                  height: 110,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'รายการที่เหลือ:\n${getRemainingItemsDetails()}'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close AlertDialog
                        setState(() {
                          isScanCompleted = false;
                          isProcessing = false; // Set isProcessing to false

                          // Increment the counter for the scanned product
                          currentQuantity++;

                          // Check if the current product is fully scanned
                          if (currentQuantity >= totalQuantity) {
                            // Reset the counter for the next product
                            currentQuantity = 0;

                            // Check if there are more products in the list
                            if (currentIndex < ProductList.length - 1) {
                              // Increment the index to display the next product
                              currentIndex++;
                              // Update the 'product' variable with the new product data
                              product = ProductList[currentIndex];
                            } else {
                              // You have reached the end of the list, handle accordingly
                              // You may want to reset the index or perform some other action
                            }
                          }
                        });
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFF0D99FF),
                            border: Border.all(
                              color: Color(0xFF0D99FF),
                              width: 3,
                            ),
                          ),
                          child: const Text(
                            'ตกลง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                );
              },
            );

            // Update the quantity in ProductList
            setState(() {
              ProductList[ProductList.indexOf(product)]['quantity'] =
                  currentQuantity + 1;

              // Check if all items are complete after updating quantity
              if (isAllItemsComplete()) {
                // กรณีที่รายการสินค้าครบตามจำนวน
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.check, color: Colors.blue),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            // Flexible widget เพื่อป้องกัน overflow
                            child: Text(
                              'รายการสินค้าครบตามจำนวน',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: Text('ทุกรายการสินค้าครบตามจำนวนที่กำหนด'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // ปิด AlertDialog
                            setState(() {
                              isScanCompleted = false;
                              isProcessing = false; // Set isProcessing to false
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFF0D99FF),
                                border: Border.all(
                                  color: Color(0xFF0D99FF),
                                  width: 3,
                                ),
                              ),
                              child: const Text(
                                'ตกลง',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ],
                    );
                  },
                );
              }
            });
          } else {
            // Handle the case where quantity is equal to or greater than total
            // Show a different dialog or perform other actions if needed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        Icons.block_flipped,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'สินค้าเกินจำนวน',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  content: Text('รหัสสินค้า: $code ครบจำนวนทั้งหมดแล้ว'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิด AlertDialog
                        setState(() {
                          isScanCompleted = false;
                          isProcessing = false; // Set isProcessing to false
                        });
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFF0D99FF),
                            border: Border.all(
                              color: Color(0xFF0D99FF),
                              width: 3,
                            ),
                          ),
                          child: const Text(
                            'ตกลง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                );
              },
            );

            // Clear the scanned code from the list to allow scanning again
            scannedProductCodes.remove(scannedCode);
          }

          // Clear the scanned code from the list to allow scanning again
          scannedProductCodes.remove(scannedCode);
        } else {
          // ถ้าไม่พบรหัสสินค้า
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'สินค้าผิดรายการ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                content: Text('รหัสสินค้า: $code ไม่ตรงกับรายการที่ต้องการ'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด AlertDialog
                      setState(() {
                        isScanCompleted = false;
                        isProcessing = false; // Set isProcessing to false
                      });
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF0D99FF),
                          border: Border.all(
                            color: Color(0xFF0D99FF),
                            width: 3,
                          ),
                        ),
                        child: const Text(
                          'ตกลง',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ],
              );
            },
          );

          // Clear the scanned code from the list to allow scanning again
          scannedProductCodes.remove(scannedCode);
        }
      }
    } catch (error) {
      print('Error handling scanned code: $error');
      // Handle the error condition, show an error dialog or perform other actions if needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            content: Text('Error handling scanned code: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the error dialog
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF0D99FF),
                      border: Border.all(
                        color: Color(0xFF0D99FF),
                        width: 3,
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if all items are complete before showing the exit confirmation dialog
        if (!isAllItemsComplete()) {
          // Show a confirmation dialog when the back button is pressed
          return await showExitConfirmationDialog(context);
        } else {
          // Allow navigation without showing the dialog if all items are complete
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black, //Color(0xFF212325),
        appBar: AppBar(
          leading: IconButton(
            iconSize: 30,
            color: Colors.white,
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //    MaterialPageRoute(builder: (context) =>ProductList()),
              //  );
            },
            icon: Icon(Icons.arrow_back),
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
          padding: EdgeInsets.all(1),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: double.infinity,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'รายการ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              '${ProductList[currentIndex]['name']}(${ProductList[currentIndex]['shelf']})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'ตรวจสอบ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  ProductList[currentIndex]['quantity']
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  '/',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ProductList[currentIndex]['total'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
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
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MobileScanner(
                        controller: cameraController,
                        allowDuplicates: true,
                        onDetect: (barcode, args) {
                          if (!isScanCompleted && !isProcessing) {
                            setState(() {
                              isScanCompleted = true;
                              isProcessing = true;
                            });

                            String code = barcode.rawValue ?? "---";
                            // Call the function to handle the scanned code
                            handleScannedCode(code);

                            setState(() {
                              isProcessing =
                                  false; // Set isProcessing to false after processing
                            });
                          }
                        },
                      ),
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "สแกนเพื่อตรวจสอบสินค้า",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
