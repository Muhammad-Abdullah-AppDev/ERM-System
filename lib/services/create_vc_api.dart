import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:scarlet_erm/models/journal_post_detail_model.dart';
import 'package:scarlet_erm/models/receipt_post_model.dart';
import '../models/dialog_post_data_model.dart';
import 'api_service.dart';

Future<void> sendPostRequestPaymentDialog(PostDataModelDialog postDataDialog, [BuildContext? context]) async {
  var url = Uri.parse('${ApiService.baseUrl}PaymentVoucher/PostDetailVoucher');

  var response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(postDataDialog.toJson()),
  );

  if (response.statusCode == 200) {
    Navigator.pop(context!);
    Fluttertoast.showToast(
        msg: "Data Saved Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0
    );
    // Optionally, log that the request was successful
    debugPrint('Request successful with status code: ${response.statusCode}');
  } else {
    debugPrint('Error: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    Fluttertoast.showToast(
        msg: "Failed To Save Record",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0
    );
  }
}

Future<void> sendPostRequestReceiptDialog(ReceiptPostModel postDataDialog, BuildContext context) async {
  var url = Uri.parse('${ApiService.baseUrl}ReceiptVoucher/PostDetailVoucher');
  var response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(postDataDialog.toJson()),
  );
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Data Saved Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0
    );// Optionally, log that the request was successful
    debugPrint('Request successful with status code: ${response.statusCode}');
    Navigator.pop(context);
  } else {
    debugPrint('Error: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    Fluttertoast.showToast(
        msg: "Failed To Save Data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0
    );
  }
}

Future<void> sendPostRequestJournalDialog(JournalPostDetailModel postDataDialog, BuildContext context) async {
  var url = Uri.parse('${ApiService.baseUrl}JournalVoucher/PostDetailVoucher');
  var response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(postDataDialog.toJson()),
  );

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Data Saved Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0
    );
    // Optionally, log that the request was successful
    debugPrint('Request successful with status code: ${response.statusCode}');
    Navigator.pop(context);
  } else {
    debugPrint('Error: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    Fluttertoast.showToast(
        msg: "Failed To Save Data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0
    );
  }
}

