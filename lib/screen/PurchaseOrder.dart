import 'package:applicaiton/screen/ProductList.dart';
import 'package:flutter/material.dart';

class PurchaseOrder extends StatelessWidget {
  const PurchaseOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: List.generate(
                1,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Center(
                    child: Container(
                      width: 400,
                      height: 700,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/images/Purchase_Order.jpg',
                        fit: BoxFit.contain,
                      ),
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

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: const Text(
        'ใบสั่งซื้อ',
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
                return ProductListScreen();
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
    );
  }
}
