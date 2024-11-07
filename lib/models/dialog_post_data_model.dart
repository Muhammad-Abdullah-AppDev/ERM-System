class PostDataModelDialog {
  final String? theamountDialog;
  final String? srnoDialog;
  final String? fkMastDialog;
  final String? remksDialog;

  PostDataModelDialog({
    required this.theamountDialog,
    required this.srnoDialog,
    required this.fkMastDialog,
    required this.remksDialog,
  });

  Map<String, dynamic> toJson() {
    return {
      'AMNTD': theamountDialog ,
      'SRNO': srnoDialog ,
      'FKMAST': fkMastDialog ,
      'RMKS': remksDialog,
    };
  }
}
