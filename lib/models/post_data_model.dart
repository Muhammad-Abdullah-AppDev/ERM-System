class PostDataModel {
  final String? vdt;
  final String? vtyp;
  final String? fkMast;
  final String? rmks;
  final String? usid;
  final String? chqNO;
  final String? chqDT;

  PostDataModel({
    required this.vdt,
    required this.vtyp,
    this.fkMast,
    required this.rmks,
    required this.usid,
    this.chqNO,
    this.chqDT
  });

  Map<String, dynamic> toJson() {
    return {
      'VDT': vdt,
      'VTYP': vtyp,
      'FKMAST': fkMast,
      'RMKS': rmks,
      'USID': usid,
      'CHQNO': chqNO,
      'CHQDT': chqDT
    };
  }
}
