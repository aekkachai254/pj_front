import 'dart:convert';

import 'package:applicaiton/screen/ProductList.dart';
import 'package:applicaiton/screen/Verify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productDetail;

  ProductDetailScreen(
      {required this.productDetail,
      required Map<String, dynamic> ProductDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'รายละเอียดสินค้า',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProductListScreen()),
            );
          },
          iconSize: 25,
        ),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: fetchProductDetails(productDetail['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic>? productDetails = snapshot.data;
            return ListView(
              children: [
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 250,
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Image.network(
                    productDetails?['picture_1'],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "รหัสสินค้า : ${productDetails?['id']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${productDetails?['name']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "รายละเอียดสินค้า",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "ขนาด ${productDetails?['size']} กรัม",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "บรรจุ ${productDetails?['package']} ซอง (1 ลัง)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "จำนวนสินค้าที่ต้องการเช็ค",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "จำนวน ${productDetails?['product_amount']} ลัง",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
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
                            return VerifyScreen(
                              productDetail: productDetail,
                              ProductDetail: {},
                            );
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
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final String apiUrl =
        'http://teamproject.ddns.net/application/api/ProductDetail.php?';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load product details. Status Code: ${response.statusCode}');
    }
  }
}
