class InventoryVcListModel {
  final String? fKPCD;
  final String? fKMCD;
  final String? fKUNIT;
  final String? sRNO;
  final String? vDT;
  final String? vTYP;
  final String? fKFSCD;
  final String? pARTYNAME;
  final dynamic rDNO;
  final dynamic rDDT;
  final String? rMKS;
  final String? pST;
  final String? sTATUS;

  InventoryVcListModel({
    this.fKPCD,
    this.fKMCD,
    this.fKUNIT,
    this.sRNO,
    this.vDT,
    this.vTYP,
    this.fKFSCD,
    this.pARTYNAME,
    this.rDNO,
    this.rDDT,
    this.rMKS,
    this.pST,
    this.sTATUS,
  });

  InventoryVcListModel.fromJson(Map<String, dynamic> json)
      : fKPCD = json['FKPCD'] as String?,
        fKMCD = json['FKMCD'] as String?,
        fKUNIT = json['FKUNIT'] as String?,
        sRNO = json['SRNO'] as String?,
        vDT = json['VDT'] as String?,
        vTYP = json['VTYP'] as String?,
        fKFSCD = json['FKFSCD'] as String?,
        pARTYNAME = json['PARTY_NAME'] as String?,
        rDNO = json['RDNO'],
        rDDT = json['RDDT'],
        rMKS = json['RMKS'] as String?,
        pST = json['PST'] as String?,
        sTATUS = json['STATUS'] as String?;

  Map<String, dynamic> toJson() => {
    'FKPCD' : fKPCD,
    'FKMCD' : fKMCD,
    'FKUNIT' : fKUNIT,
    'SRNO' : sRNO,
    'VDT' : vDT,
    'VTYP' : vTYP,
    'FKFSCD' : fKFSCD,
    'PARTY_NAME' : pARTYNAME,
    'RDNO' : rDNO,
    'RDDT' : rDDT,
    'RMKS' : rMKS,
    'PST' : pST,
    'STATUS' : sTATUS
  };
}