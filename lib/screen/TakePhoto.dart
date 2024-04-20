import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api_config.dart' as configURL;
import 'TakephotoConfirm.dart';

class TakephotoScreen extends StatefulWidget {
  final String username;
  final String tripId;
  final String purchaseorderId;

  const TakephotoScreen({
    Key? key,
    required this.username,
    required this.tripId,
    required this.purchaseorderId,
  }) : super(key: key);

  @override
  State<TakephotoScreen> createState() => _TakephotoScreenState();
}

enum AppState { clear, picking, picked, cropped }

class _TakephotoScreenState extends State<TakephotoScreen> {
  bool isLoading = false;
  bool isUploading = false;

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
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "ถ่ายรูปสินค้า",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  alignment: Alignment.center,
                  child: isLoading
                      ? const Text('Loading...')
                      : mainImageFile != null
                          ? Image.file(mainImageFile!, fit: BoxFit.cover)
                          : Image.network(
                              '${configURL.imageUrl}/take_photo.png',
                              height: 300,
                            ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        _pickImage(ImageSource.camera);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Image.network(
                            '${configURL.imageUrl}/camera1.png',
                            color: Colors.white,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Image.network(
                            '${configURL.imageUrl}/image1.png',
                            height: 40,
                            width: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isUploading
                    ? null
                    : () async {
                        if (mainImageFile != null) {
                          setState(() {
                            isUploading = true;
                          });
                          await _uploadImage(mainImageFile!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('กรุณาเลือกรูปภาพ')),
                          );
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onPrimary: isUploading ? Colors.grey : null,
                ),
              ),
            ],
          ),
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

  Future<void> _uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${configURL.apiUrl}/Takephoto.php'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('picture', imageFile.path),
      );

      request.fields['trip_id'] = widget.tripId;

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var data = json.decode(jsonResponse);

        if (data['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakephotoConfirmScreen(
                username: widget.username,
                tripId: widget.tripId,
                purchaseorderId: widget.purchaseorderId,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('มีข้อผิดพลาดเกิดขึ้นในการอัปโหลดรูปภาพ'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ'),
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }
}
