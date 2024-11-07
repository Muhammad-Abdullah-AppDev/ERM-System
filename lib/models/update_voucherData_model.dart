class UpdateVoucherDataModel {
  final String? fkMast;
  final String? rmks;
  final String? usid;
  final String? srno;
  final String? chqNO;
  final String? chqDT;

  UpdateVoucherDataModel({
    this.fkMast,
    required this.rmks,
    required this.usid,
    required this.srno,
    this.chqNO,
    this.chqDT,
  });

  Map<String, dynamic> toJson() {
    return {
      'FKMAST': fkMast,
      'RMKS': rmks,
      'USID': usid,
      'SRNO': srno,
      'CHQNO': chqNO,
      'CHQDT': chqDT,
    };
  }
}
