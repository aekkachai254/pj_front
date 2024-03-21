import 'package:applicaiton/screen/PurchaseOrder.dart';
import 'package:applicaiton/screen/Scan.dart';
import 'package:applicaiton/screen/TravelDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> ProductList = [
  {
    "name": "1. ปูไทย รสปลาหมึก",
    "shelf": "P6",
    "total": "6",
    "quantity": 6,
    "productCode": 1610,
    "size": "ขนาด: 55 กรัม",
    "packaging": "บรรจุ: 9 ซอง (1 ลัง)",
    "imagePath": "assets/images/Poothai.png",
  },
  {
    "name": "2. เลย์ รสโนริสาหร่าย",
    "shelf": "L2",
    "total": "3",
    "quantity": 2,
    "productCode": 1500,
    "size": "ขนาด: 42 กรัม",
    "packaging": "บรรจุ: 6 ซอง (1 ลัง)",
    "imagePath": "assets/images/Lay.png",
  },
  {
    "name": "3. มาม่าคัพ รสต้มยำกุ้ง",
    "shelf": "M5",
    "total": "5",
    "quantity": 5,
    "productCode": 1212,
    "size": "ขนาด: 60 กรัม",
    "packaging": "บรรจุ: 36 ถ้วย (1 ลัง)",
    "imagePath": "assets/images/MamaCup.png",
  },
  {
    "name": "4. คัพโจ๊ก",
    "shelf": "J1",
    "total": "4",
    "quantity": 4,
    "productCode": 1320,
    "size": "ขนาด: 35 กรัม",
    "packaging": "บรรจุ: 36 ถ้วย (1 ลัง)",
    "imagePath": "assets/images/Joke.png",
  },
  {
    "name": "5. เนสกาแฟ เรดคัพ",
    "shelf": "C7",
    "total": "4",
    "quantity": 4,
    "productCode": 1493,
    "size": "ขนาด: 100 กรัม",
    "packaging": "บรรจุ: 10 ขวด (1 ลัง)",
    "imagePath": "assets/images/Nescafe.png",
  },
  {
    "name": "6. น้ำตาลทรายขาว",
    "shelf": "S8",
    "total": "3",
    "quantity": 0,
    "productCode": 1222,
    "size": "ขนาด: 1 กิโลกรัม",
    "packaging": "บรรจุ: 20 ถุง (1 ลัง)",
    "imagePath": "assets/images/Sugar.png",
  },
  {
    "name": "7. น้ำมันถั่วเหลือง",
    "shelf": "W1",
    "total": "3",
    "quantity": 3,
    "productCode": 1010,
    "size": "ขนาด: 1 ลิตร",
    "packaging": "บรรจุ: 12 ขวด (1 ลัง)",
    "imagePath": "assets/images/SoybeanOil.png",
  },
  {
    "name": "8. น้ำปลาทิพรส",
    "shelf": "W3",
    "total": "3",
    "quantity": 1,
    "productCode": 1228,
    "size": "ขนาด: 700 มิลลิลิตร",
    "packaging": "บรรจุ: 12 ขวด (1 ลัง)",
    "imagePath": "assets/images/Tiparos.png",
  },
];

Future<void> fetchDataFromApi() async {
  try {
    final response = await http.get(Uri.parse(
        'http://teamproject.ddns.net/application/api/productlist.php'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> apiData =
          List<Map<String, dynamic>>.from(response.body as List);
      ProductList = apiData;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TravelDetailScreen();
                },
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "รายการสินค้า",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PurchaseOrder()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xFF212325),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFF0D99FF),
                    width: 3,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'ใบสั่งซื้อ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.file_open,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: fetchDataFromApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.51,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(ProductList.length, (index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ProductList[index]["imagePath"],
                              height: 80,
                            ),
                            SizedBox(height: 10),
                            Text(
                              ProductList[index]["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Shelf: ${ProductList[index]["shelf"]}',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Total: ${ProductList[index]["total"]}',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Quantity: ${ProductList[index]["quantity"]}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 16, right: 16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: IconButton(
          icon: Icon(
            Icons.crop_free_sharp,
            size: 34,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScanScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
