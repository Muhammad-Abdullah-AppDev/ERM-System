class ListDetailsModel {
  final String? accholder;
  final int? trno;
  final double? debitAmount;
  final double? creditAmount;
  final String? finalRemarks;
  final String? fkmast;

  ListDetailsModel({required this.accholder, required this.debitAmount,
    this.creditAmount,
    required this.finalRemarks, required this.fkmast, required this.trno});

  factory ListDetailsModel.fromJson(Map<String, dynamic> json) {
    return ListDetailsModel(
      accholder: json['ACCOUNT_NAME'] as String,
      debitAmount: json['AMNTD'] as double,
      creditAmount: json['AMNTC'] as double,
      finalRemarks: json['RMKS'] as String,
      fkmast: json['FKMAST'] as String,
      trno: json['TRNO'] as int
    );
  }
}