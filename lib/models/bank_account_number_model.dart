class BankBalanceAccountNumberModel {

  final String? pkcodesendbank;
  final String? bankbalancename;

  BankBalanceAccountNumberModel({
    required this.pkcodesendbank,
    required this.bankbalancename,
  });

  factory BankBalanceAccountNumberModel.fromJson(Map<String, dynamic> json) {
    return BankBalanceAccountNumberModel(
      pkcodesendbank: json['PKCODE'] as String,
      bankbalancename: json['NAME'] as String,

    );
  }

}