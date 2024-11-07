class FinancialVoucher {
  final String? fKUNIT;
  final String? fKPCD;
  final String? fKMCD;
  final String? sRNO;
  final String? vDT;
  final String? vTYP;
  final dynamic rDNO;
  final dynamic rDDT;
  final dynamic cHQNO;
  final dynamic cHQDT;
  final String? pAYE;
  final String? rMKS;
  final String? iNUSID;
  final String? pST;
  final String? nAME;
  final num? dEBIT; // Allow both int and double for dEBIT
  final num? cREDIT;
  final String? fKMAST;

  FinancialVoucher({
    this.fKUNIT,
    this.fKPCD,
    this.fKMCD,
    this.sRNO,
    this.vDT,
    this.vTYP,
    this.rDNO,
    this.rDDT,
    this.cHQNO,
    this.cHQDT,
    this.pAYE,
    this.rMKS,
    this.iNUSID,
    this.pST,
    this.nAME,
    this.dEBIT,
    this.cREDIT,
    this.fKMAST,
  });

  FinancialVoucher.fromJson(Map<String, dynamic> json)
      : fKUNIT = json['FKUNIT'] as String?,
        fKPCD = json['FKPCD'] as String?,
        fKMCD = json['FKMCD'] as String?,
        sRNO = json['SRNO'] as String?,
        vDT = json['VDT'] as String?,
        vTYP = json['VTYP'] as String?,
        rDNO = json['RDNO'],
        rDDT = json['RDDT'],
        cHQNO = json['CHQNO'],
        cHQDT = json['CHQDT'],
        pAYE = json['PAYE'] as String?,
        rMKS = json['RMKS'] as String?,
        iNUSID = json['INUSID'] as String?,
        pST = json['PST'] as String?,
        nAME = json['NAME'] as String?,
        dEBIT = json['DEBIT']?.toDouble(), // Convert to double if it's not null
        cREDIT = json['CREDIT']?.toDouble(), // Convert to double if it's not null
        fKMAST = json['FKMAST'] as String?;

  Map<String, dynamic> toJson() => {
    'FKUNIT': fKUNIT,
    'FKPCD': fKPCD,
    'FKMCD': fKMCD,
    'SRNO': sRNO,
    'VDT': vDT,
    'VTYP': vTYP,
    'RDNO': rDNO,
    'RDDT': rDDT,
    'CHQNO': cHQNO,
    'CHQDT': cHQDT,
    'PAYE': pAYE,
    'RMKS': rMKS,
    'INUSID': iNUSID,
    'PST': pST,
    'NAME': nAME,
    'DEBIT': dEBIT,
    'CREDIT': cREDIT,
    'FKMAST': fKMAST
  };
}
