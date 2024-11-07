class SalesVcListModel {
  final String? sRNO;
  final String? vDT;
  final String? fKPCD;
  final String? fKMCD;
  final String? fKUNIT;
  final String? vTYP;
  final int? vNO;
  final String? fKFSCD;
  final String? rMKS;
  final dynamic rDNO;
  final dynamic rDDT;
  final String? pST;
  final String? sOSTATUS;
  final String? cUSTNAME;

  SalesVcListModel({
    this.sRNO,
    this.vDT,
    this.fKPCD,
    this.fKMCD,
    this.fKUNIT,
    this.vTYP,
    this.vNO,
    this.fKFSCD,
    this.rMKS,
    this.rDNO,
    this.rDDT,
    this.pST,
    this.sOSTATUS,
    this.cUSTNAME,
  });

  SalesVcListModel.fromJson(Map<String, dynamic> json)
      : sRNO = json['SRNO'] as String?,
        vDT = json['VDT'] as String?,
        fKPCD = json['FKPCD'] as String?,
        fKMCD = json['FKMCD'] as String?,
        fKUNIT = json['FKUNIT'] as String?,
        vTYP = json['VTYP'] as String?,
        vNO = json['VNO'] as int?,
        fKFSCD = json['FKFSCD'] as String?,
        rMKS = json['RMKS'] as String?,
        rDNO = json['RDNO'],
        rDDT = json['RDDT'],
        pST = json['PST'] as String?,
        sOSTATUS = json['SO_STATUS'] as String?,
        cUSTNAME = json['CUST_NAME'] as String?;

  Map<String, dynamic> toJson() => {
    'SRNO' : sRNO,
    'VDT' : vDT,
    'FKPCD' : fKPCD,
    'FKMCD' : fKMCD,
    'FKUNIT' : fKUNIT,
    'VTYP' : vTYP,
    'VNO' : vNO,
    'FKFSCD' : fKFSCD,
    'RMKS' : rMKS,
    'RDNO' : rDNO,
    'RDDT' : rDDT,
    'PST' : pST,
    'SO_STATUS' : sOSTATUS,
    'CUST_NAME' : cUSTNAME
  };
}