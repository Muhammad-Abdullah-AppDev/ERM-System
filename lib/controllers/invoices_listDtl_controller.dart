import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scarlet_erm/models/sales_listdtl_model.dart';

import '../models/list_details_model.dart';
import '../services/api_service.dart';

class ListDataController extends GetxController {
  var data = <ListDetailsModel>[].obs;
  var data2 = <SalesListDtlModel>[].obs;

  Future<List<ListDetailsModel>> fetchPaymentListDetails(String text) async {

    debugPrint('Voucher Number is : $text');
    var url = Uri.parse(
        '${ApiService.baseUrl}FinancialVoucher/GetListDtl?srno=$text');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var listData =
      jsonResponse.map((data) => ListDetailsModel.fromJson(data)).toList();
      data.value = listData;
      return jsonResponse
          .map((data) => ListDetailsModel.fromJson(data))
          .toList();
    } else {
      debugPrint('Failed to load list details');
      throw Exception('Failed to load list details');
    }
  }

  Future<List<SalesListDtlModel>> fetchSalesListDetails(String text) async {

    debugPrint('Voucher Number is : $text');
    var url = Uri.parse(
        '${ApiService.baseUrl}DirectSaleInvoice/GetListDtl?srno=$text');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      debugPrint("Success");
      List jsonResponse = json.decode(response.body);
      var listData =
      jsonResponse.map((data) => SalesListDtlModel.fromJson(data)).toList();
      data2.value = listData;
      return jsonResponse
          .map((data) => SalesListDtlModel.fromJson(data))
          .toList();
    } else {
      debugPrint('Failed to load list details');
      throw Exception('Failed to load list details');
    }
  }
}