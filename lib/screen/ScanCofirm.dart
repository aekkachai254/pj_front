import 'package:applicaiton/screen/ProductDetail.dart';
import 'package:applicaiton/screen/PurchaseOrder.dart';
import 'package:applicaiton/screen/TravelDetail.dart';
import 'package:flutter/material.dart';

class ScanconfirmScreen extends StatelessWidget {
  const ScanconfirmScreen(
      {Key? key, required String code, required void Function() closeScreen})
      : super(key: key);

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
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
                return const TravelDetailScreen(id: '1',);
              },
            ),
          );
        },
      ),
      /*leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: 25,
      ),*/
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
            'ชั้นวาง',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.only(left: 9),
            child: const Text(
              'จำนวน',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 9),
            child: const Text(
              'รายละเอียด',
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
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(width: 0),
                            Text(
                              ProductList[index]['shelf'],
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
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 45),
                            Container(
                              width: 35,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF567BAE),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  navigateToProductDetails(context, index);
                                },
                                child: const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                              ),
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
  {"name": "1.ปูไทย รสปลาหมึก", "shelf": "P6", "quantity": 2},
  {"name": "2.ดินสอ", "shelf": "C2", "quantity": 1},
  {"name": "3.น้ำปลาทิพรส", "shelf": "W3", "quantity": 2},
  {"name": "4.น้ำมันถั่วเหลือง", "shelf": "W1", "quantity": 3},
  {"name": "5.ปลากระป๋องโรซ่า", "shelf": "F7", "quantity": 3},
  {"name": "6.นมถั่วเหลือง", "shelf": "M10", "quantity": 1},
  {"name": "7.มาม่าคัพ รสต้มยำกุ้ง", "shelf": "M15", "quantity": 2},
  {"name": "8.เนสกาแฟเรดคัพ", "shelf": "C7", "quantity": 1},
  {"name": "9.น้ำตาลทรายขาว", "shelf": "S8", "quantity": 3},
  {"name": "10.เลย์ รสโนริสาหร่าย", "shelf": "L2", "quantity": 2},
];
