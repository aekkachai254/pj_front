import 'dart:convert';

import 'package:applicaiton/screen/Invoice.dart';
import 'package:applicaiton/screen/Takephoto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_config.dart' as configURL;
import 'Scan.dart';
import 'TripDetail.dart';

class PurchaseorderScreen extends StatefulWidget {
  final String username;
  final String tripId;
  final String purchaseorderId;

  const PurchaseorderScreen({
    Key? key,
    required this.username,
    required this.tripId,
    required this.purchaseorderId,
  }) : super(key: key);

  @override
  _PurchaseorderScreenState createState() => _PurchaseorderScreenState();
}

class _PurchaseorderScreenState extends State<PurchaseorderScreen> {
  late Future<Map<String, dynamic>> _purchaseOrderFuture;

  @override
  void initState() {
    super.initState();
    _purchaseOrderFuture = fetchPurchaseOrder();
  }

  Future<Map<String, dynamic>> fetchPurchaseOrder() async {
    final apiUrl =
        '${configURL.deployUrl}/purchaseorder.php?purchaseorder_id=${widget.purchaseorderId.toString()}&username=${widget.username.toString()}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Received data from API: $data');

      if (data.containsKey('error')) {
        throw Exception('API Error: ${data['error']}');
      } else {
        return data as Map<String, dynamic>;
      }
    } else {
      throw Exception(
          'Failed to load เลขที่ใบสั่งซื้อ. Status code: ${response.statusCode}');
    }
  }

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
                builder: (context) => TripDetailScreen(
                  username: widget.username,
                  trip_id: widget.tripId,
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "ใบจัดสินค้า",
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
                  MaterialPageRoute(
                    builder: (context) => InvoiceScreen(
                      purchaseorderId: widget.purchaseorderId,
                    ),
                  ),
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
                child: Icon(
                  Icons.file_open,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _purchaseOrderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final purchaseOrderData = snapshot.data!;
            final purchaseOrder =
                purchaseOrderData['purchaseorder'] as Map<String, dynamic>;
            final products = purchaseOrderData['products'] as List<dynamic>;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'เลขที่ใบสั่งซื้อ: ${purchaseOrder['document_no']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.48,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: products.map((product) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 7, right: 7, top: 20, bottom: 1),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF212325),
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(
                            color: Color(0xFF0D99FF),
                            width: 3,
                          ),
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(0.5),
                                child: Image.network(
                                  product['picture_1'].toString(),
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2, top: 10),
                              child: Text(
                                product['name'].toString(),
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "รหัสสินค้า: ${product['id'].toString()}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'ขนาด: ${product['size'].toString()}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'ประเภท: ${product['package'].toString()}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'จำนวน: ${product['product_amount']} ลัง',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Color(0xff0A8ED9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 35,
                                      child: Center(
                                        child: Text(
                                          product['shelf'].toString(),
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanScreen(),
                ),
              );
            },
            backgroundColor: Colors.red,
            child: Icon(Icons.crop_free_sharp),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TakephotoScreen(
                    username: widget.username,
                    tripId: widget.tripId,
                    purchaseorderId: widget.purchaseorderId,
                  ),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}
