import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_config.dart' as configURL;

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key, required this.purchaseorderId})
      : super(key: key);

  final String purchaseorderId;

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late String _pictureInvoiceUrl = '';
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url =
          '${configURL.deployUrl}/Invoice.php?purchaseorder_id=${widget.purchaseorderId}'; // ใช้ deployUrl จากไฟล์ api_config.dart
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('error')) {
          throw Exception(jsonData['error']);
        } else {
          setState(() {
            _pictureInvoiceUrl = jsonData['invoice']['picture_invoice'];
            _loading = false;
          });
        }
      } else {
        throw Exception('Failed to load data from server');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _loading = false;
      });
      // Handle error here, such as showing a snackbar or dialog to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ใบสั่งซื้อ'),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      _pictureInvoiceUrl,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ));
  }
}
