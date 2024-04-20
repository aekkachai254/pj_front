import 'package:applicaiton/screen/Takephoto.dart';
// แก้จาก 'package:applicaiton/screen/Takephoto.dart';
import 'package:flutter/material.dart';

class TakephotoConfirmScreen extends StatefulWidget {
  const TakephotoConfirmScreen({
    Key? key, // เพิ่ม Key? key
    required this.username,
    required this.tripId,
    required this.purchaseorderId,
  }) : super(key: key); // เพิ่ม super(key: key)

  final String username;
  final String tripId;
  final String purchaseorderId;

  @override
  State<TakephotoConfirmScreen> createState() => _TakephotoConfirmScreenState();
}

class _TakephotoConfirmScreenState extends State<TakephotoConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TakephotoScreen(
                    username: widget.username,
                    tripId: widget.tripId,
                    purchaseorderId: widget.purchaseorderId,
                  );
                },
              ),
            );
          },
        ),
        title: const Text(
          "ส่งรูปสินค้า",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                "สำเร็จ ! ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Image(
              image: AssetImage("assets/images/success.png"),
              height: 250,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "06/06/2566 ",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "13:45 น. ",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(
              height: 80,
            ),
            InkWell(
              onTap: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripScreen(
                      username: username,
                    ),
                  ),
                );*/
              },
              child: Expanded(
                child: Container(
                  width: 250.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF567BAE),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Center(
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
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
}
