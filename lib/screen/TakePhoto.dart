import 'dart:io';

import 'package:applicaiton/screen/SendProduct.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

enum AppState { clear, picking, picked, cropped }

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  bool isLoading = false;

  AppState state = AppState.clear;
  File? mainImageFile;
  final ImagePicker imagePicker = ImagePicker();
  late String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ถ่ายรูปสินค้า",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.center,
                child: isLoading
                    ? Text('Loading...')
                    : mainImageFile != null
                        ? Image.file(mainImageFile!, fit: BoxFit.cover)
                        : const Image(
                            image: AssetImage("assets/images/take_photo.png"),
                            height: 500,
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      _pickImage(ImageSource.camera);
                    },
                    child: const Image(
                      image: AssetImage("assets/images/camera1.png"),
                      color: Colors.white,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Image(
                      image: AssetImage("assets/images/image.png"),
                      color: Colors.white,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SendProductScreen(),
                  ),
                );
              },
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      isLoading = true;
    });
    try {
      final picked = await imagePicker.pickImage(source: source);

      if (picked != null) {
        setState(() {
          mainImageFile = File(picked.path);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
