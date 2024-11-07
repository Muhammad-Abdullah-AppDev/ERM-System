class ReceiptPostModel {
  final String? theamountDialog;
  final String? srnoDialog;
  final String? fkMastDialog;
  final String? remksDialog;

  ReceiptPostModel({
    required this.theamountDialog,
    required this.srnoDialog,
    required this.fkMastDialog,
    required this.remksDialog,
  });

  Map<String, dynamic> toJson() {
    return {
      'AMNTC': theamountDialog ,
      'SRNO': srnoDialog ,
      'FKMAST': fkMastDialog ,
      'RMKS': remksDialog,
    };
  }
}
