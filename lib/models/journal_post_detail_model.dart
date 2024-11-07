class JournalPostDetailModel {
  final String? creditDialog;
  final String? debitDialog;
  final String? srnoDialog;
  final String? fkMastDialog;
  final String? remksDialog;

  JournalPostDetailModel({
    required this.creditDialog,
    required this.debitDialog,
    required this.srnoDialog,
    required this.fkMastDialog,
    required this.remksDialog,
  });

  Map<String, dynamic> toJson() {
    return {
      'AMNTC': creditDialog,
      'AMNTD': debitDialog,
      'SRNO': srnoDialog,
      'FKMAST': fkMastDialog,
      'RMKS': remksDialog,
    };
  }
}
