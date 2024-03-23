import 'package:applicaiton/screen/ProductDetail.dart';
import 'package:applicaiton/screen/PurchaseOrder.dart';
import 'package:applicaiton/screen/Scan.dart';
import 'package:applicaiton/screen/TravelDetail.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatelessWidget {
  final Map<String, dynamic> ProductDetail;

  VerifyScreen(
      {required this.ProductDetail,
      required Map<String, dynamic> productDetail});

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF17203A),
      centerTitle: true,
      title: const Text(
        'รายการสินค้า',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ),
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TravelDetailScreen(id: '1');
              },
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_present_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PurchaseOrder()),
            );
          },
          iconSize: 30,
        ),
        const SizedBox(
          width: 2,
        ),
        IconButton(
          icon: const Icon(Icons.crop_free_sharp, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanScreen()),
            );
          },
          iconSize: 30,
        ),
      ],
    );
  }

  Widget listviewHeading() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'รายการ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          const Text(
            'ทั้งหมด',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.only(left: 9),
            child: const Text(
              'ตรวจสอบ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 9),
            child: const Text(
              'สถานะ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToProductDetails(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          ProductDetail: ProductList[index],
          productDetail: {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            listviewHeading(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: ProductList.length,
                itemBuilder: (context, index) {
                  bool isQuantityEqualShelf = ProductList[index]['quantity'] ==
                      int.parse(ProductList[index]['total']);
                  bool isTotalNotZero = ProductList[index]['quantity'] != 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ProductList[index]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 0),
                            Text(
                              ProductList[index]['total'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 45),
                            Text(
                              ProductList[index]['quantity'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 45),
                            Container(
                              width: 35,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: (ProductList[index]['quantity'] > 0)
                                  ? (isTotalNotZero
                                      ? (isQuantityEqualShelf
                                          ? const Icon(Icons.check_circle,
                                              color: Colors.green)
                                          : const Icon(Icons.warning,
                                              color: Colors.yellow))
                                      : const Icon(Icons.warning,
                                          color: Colors.yellow))
                                  : const SizedBox(), // Show an empty container if quantity is 0
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> ProductList = [
  {"name": "1.ปูไทย รสปลาหมึก", "shelf": "P6", "total": "6", "quantity": 6},
  {"name": "2.ดินสอ", "shelf": "C2", "total": "4", "quantity": 0},
  {"name": "3.น้ำปลาทิพรส", "shelf": "W3", "total": "3", "quantity": 0},
  {"name": "4.น้ำมันถั่วเหลือง", "shelf": "W1", "total": "3", "quantity": 2},
  {"name": "5.ปลากระป๋องโรซ่า", "shelf": "F7", "total": "1", "quantity": 0},
  {"name": "6.นมถั่วเหลือง", "shelf": "M10", "total": "5", "quantity": 5},
  {
    "name": "7.มาม่าคัพ รสต้มยำกุ้ง",
    "shelf": "M15",
    "total": "5",
    "quantity": 2
  },
  {"name": "8.เนสกาแฟเรดคัพ", "shelf": "C7", "total": "4", "quantity": 4},
  {"name": "9.น้ำตาลทรายขาว", "shelf": "S8", "total": "3", "quantity": 3},
  {"name": "10.เลย์ รสโนริสาหร่าย", "shelf": "L2", "total": "3", "quantity": 0},
];
