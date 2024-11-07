class CashBalanceAccountNumberModel {

  final String? pkcodesendcash;
  final String? cashbalancename;

  CashBalanceAccountNumberModel({
    required this.pkcodesendcash,
    required this.cashbalancename,
  });

  factory CashBalanceAccountNumberModel.fromJson(Map<String, dynamic> json) {
    return CashBalanceAccountNumberModel(
      pkcodesendcash: json['PKCODE'] as String,
      cashbalancename: json['NAME'] as String,

    );
  }

}