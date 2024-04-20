import 'package:applicaiton/screen/CheckproductScan.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> ProductList = [
  {
    "name": "ปูไทย รสปลาหมึก",
    "shelf": "P6",
    "productCode": 1610,
    "size": "ขนาด: 55 กรัม",
    "packaging": "บรรจุ: 9 ซอง (1 ลัง)",
    "imagePath": "assets/images/Poothai.png",
    "stockQuantity": 100,
    "reservedQuantity": 10,
    "onOrderQuantity": 20,
    "unitSellingPrice": 150.0,
    "receivingDate": "2024-03-01",
    "expirationDate": "2024-04-01",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 5,
  },
  {
    "name": "เลย์ รสโนริสาหร่าย",
    "shelf": "L2",
    "productCode": 1500,
    "size": "ขนาด: 42 กรัม",
    "packaging": "บรรจุ: 6 ซอง (1 ลัง)",
    "imagePath": "assets/images/Lay.png",
    "stockQuantity": 85,
    "reservedQuantity": 15,
    "onOrderQuantity": 12,
    "unitSellingPrice": 135.0,
    "receivingDate": "2024-04-13",
    "expirationDate": "2024-05-13",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 10,
  },
  {
    "name": "มาม่าคัพ รสต้มยำกุ้ง",
    "shelf": "M5",
    "productCode": 1212,
    "size": "ขนาด: 60 กรัม",
    "packaging": "บรรจุ: 36 ถ้วย (1 ลัง)",
    "imagePath": "assets/images/MamaCup.png",
    "stockQuantity": 90,
    "reservedQuantity": 20,
    "onOrderQuantity": 31,
    "unitSellingPrice": 142.0,
    "receivingDate": "2024-04-31",
    "expirationDate": "2024-06-28",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 12,
  },
  {
    "name": "คัพโจ๊ก",
    "shelf": "J1",
    "productCode": 1320,
    "size": "ขนาด: 35 กรัม",
    "packaging": "บรรจุ: 36 ถ้วย (1 ลัง)",
    "imagePath": "assets/images/Joke.png",
    "stockQuantity": 60,
    "reservedQuantity": 10,
    "onOrderQuantity": 5,
    "unitSellingPrice": 115.0,
    "receivingDate": "2024-05-12",
    "expirationDate": "2024-06-7",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 7,
  },
  {
    "name": "เนสกาแฟ เรดคัพ",
    "shelf": "C7",
    "productCode": 1493,
    "size": "ขนาด: 100 กรัม",
    "packaging": "บรรจุ: 10 ขวด (1 ลัง)",
    "imagePath": "assets/images/Nescafe.png",
    "stockQuantity": 168,
    "reservedQuantity": 8,
    "onOrderQuantity": 12,
    "unitSellingPrice": 120.0,
    "receivingDate": "2024-07-12",
    "expirationDate": "2024-09-7",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 9,
  },
  {
    "name": "น้ำตาลทรายขาว",
    "shelf": "S8",
    "productCode": 1222,
    "size": "ขนาด: 1 กิโลกรัม",
    "packaging": "บรรจุ: 20 ถุง (1 ลัง)",
    "imagePath": "assets/images/Sugar.png",
    "stockQuantity": 168,
    "reservedQuantity": 8,
    "onOrderQuantity": 12,
    "unitSellingPrice": 120.0,
    "receivingDate": "2024-07-12",
    "expirationDate": "2024-09-7",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 9,
  },
  {
    "name": "น้ำมันถั่วเหลือง",
    "shelf": "W1",
    "productCode": 1010,
    "size": "ขนาด: 1 ลิตร",
    "packaging": "บรรจุ: 12 ขวด (1 ลัง)",
    "imagePath": "assets/images/SoybeanOil.png",
    "stockQuantity": 168,
    "reservedQuantity": 8,
    "onOrderQuantity": 12,
    "unitSellingPrice": 120.0,
    "receivingDate": "2024-07-12",
    "expirationDate": "2024-09-7",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 9,
  },
  {
    "name": "น้ำปลาทิพรส",
    "shelf": "W3",
    "productCode": 1228,
    "size": "ขนาด: 700 มิลลิลิตร",
    "packaging": "บรรจุ: 12 ขวด (1 ลัง)",
    "imagePath": "assets/images/Tiparos.png",
    "stockQuantity": 168,
    "reservedQuantity": 8,
    "onOrderQuantity": 12,
    "unitSellingPrice": 120.0,
    "receivingDate": "2024-07-12",
    "expirationDate": "2024-09-7",
    "productStatus": "มีจำหน่าย",
    "recentSalesQuantity": 9,
  },
];

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final void Function() closeScreen;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.closeScreen,
    required Map<String, dynamic> ProductDetail,
    required Map productDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'รายละเอียดสินค้า',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CheckproductScanScreen()),
            );
          },
          iconSize: 25,
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 250,
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Image.asset(
              product["imagePath"],
            ),
          ),
          //SizedBox(height: 15),
          Center(
            child: Container(
              height: 200.0,
              width: 280.0,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Color.fromARGB(255, 38, 238, 11),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "คงเหลือในสต๊อก",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${product["stockQuantity"]} ลัง",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                    ),
                                    color: Colors.orange,
                                  ),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "กำลังจัดส่ง",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${product["onOrderQuantity"]} ลัง",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Color.fromARGB(255, 236, 54, 41),
                                  ),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "จอง",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${product["reservedQuantity"]} ลัง",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
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
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "รหัสสินค้า : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["productCode"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "ชื่อสินค้า : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["name"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "วันที่รับเข้าสต๊อก : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["receivingDate"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "วันหมดอายุ : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["expirationDate"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "รายละเอียดสินค้า",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "${product["size"]}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "${product["packaging"]}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "ที่อยู่ที่เก็บสินค้าในสต๊อก : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["shelf"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "ราคาขายต่อหน่วย : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["unitSellingPrice"]} บาท",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "สถานะสินค้า : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["productStatus"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF0D99FF),
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "ปริมาณการขายล่าสุด : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${product["recentSalesQuantity"]} ลัง",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 35),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CheckproductScanScreen();
                    },
                  ),
                );
              },
              child: Container(
                child: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
