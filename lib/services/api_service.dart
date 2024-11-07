import 'dart:convert';
import 'package:scarlet_erm/models/bank_balance_model.dart';
import 'package:scarlet_erm/models/cash_balance_model.dart';
import 'package:scarlet_erm/models/financial_voucher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scarlet_erm/models/inventory_vcList_model.dart';
import 'package:scarlet_erm/models/party_balance_model.dart';

import '../models/customer-items_model.dart';
import '../models/customer_balance_mode.dart';
import '../models/customer_ledger_model.dart';
import '../models/getcustomer_model.dart';
import '../models/pending_order_model.dart';
import '../models/receipt_list_model.dart';
import '../models/sales_vcList_model.dart';

class ApiService {
  static const baseUrl = "http://79.110.232.25:1235/Api/";

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
        return json.decode(response.body);
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        //throw Exception("Failed to load data from API");
        return null;
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl$endpoint"),
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<CustomerBalanceModel>> getCustomerBalance(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        debugPrint('Response: ${response.statusCode}');
        final List<dynamic> jsonList = json.decode(response.body);
        List<CustomerBalanceModel> customerBalance = jsonList
            .map((json) => CustomerBalanceModel.fromJson(json))
            .toList();

        return customerBalance;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<BankBalanceModel>> getBankBalance(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));
      debugPrint("Response: $response");
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<BankBalanceModel> bankBalance = jsonList
            .map((json) => BankBalanceModel.fromJson(json))
            .toList();

        return bankBalance;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<CashBalanceModel>> getCashBalance(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<CashBalanceModel> cashBalance = jsonList
            .map((json) => CashBalanceModel.fromJson(json))
            .toList();

        return cashBalance;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<PartyBalanceModel>> getPartyBalance(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<PartyBalanceModel> partyBalance = jsonList
            .map((json) => PartyBalanceModel.fromJson(json))
            .toList();

        return partyBalance;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<CustomerItemsModel>> getCustomerItems(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => CustomerItemsModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<GetCustomersModel>> getCustomers(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => GetCustomersModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // get Pendings order
  static Future<List<PendingOrderModel>> getPendingOrders(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => PendingOrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // customer ledger api
  static Future<List<CustomerLegderModel>> getCustomerLedger(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        debugPrint('$jsonList');
        return jsonList
            .map((json) => CustomerLegderModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // ReceiptList api
  static Future<List<RecieptListModel>> getReceiptList(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // print(jsonList);
        return jsonList.map((json) => RecieptListModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<List<FinancialVoucher>> getFinancialVouchers(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        List<dynamic> data = json.decode(response.body);

        // Map the dynamic list to a list of FinancialVoucher objects
        List<FinancialVoucher> financialVouchers = data
            .map((json) => FinancialVoucher.fromJson(json))
            .toList();

        return financialVouchers;
      } else {
        throw Exception('\nFailed to load Vouchers Data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<SalesVcListModel>> getSalesVouchers(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        List<dynamic> data = json.decode(response.body);

        // Map the dynamic list to a list of FinancialVoucher objects
        List<SalesVcListModel> salesVouchers = data
            .map((json) => SalesVcListModel.fromJson(json))
            .toList();

        return salesVouchers;
      } else {
        throw Exception('\nFailed to load Vouchers Data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<InventoryVcListModel>> getInventoryVouchers(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        List<dynamic> data = json.decode(response.body);
        // Map the dynamic list to a list of FinancialVoucher objects
        List<InventoryVcListModel> inventoryVouchers = data
            .map((json) => InventoryVcListModel.fromJson(json))
            .toList();

        return inventoryVouchers;
      } else {
        throw Exception('\nFailed to load Vouchers Data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
