class SalesListDtlModel {
  final String? sRNO;
  final int? tRNO;
  final String? fKMAST;
  final String? iTEMNAME;
  final String? fKUOM;
  final int? fAC;
  final String? fKWLOC;
  final String? wAREHOUSE;
  final double? qTY;
  final double? uQTY;
  final double? rATE;
  final double? gRAMT;
  final double? dPER;
  final double? dAMT;
  final double? nETAMT;

  SalesListDtlModel({
    this.sRNO,
    this.tRNO,
    this.fKMAST,
    this.iTEMNAME,
    this.fKUOM,
    this.fAC,
    this.fKWLOC,
    this.wAREHOUSE,
    this.qTY,
    this.uQTY,
    this.rATE,
    this.gRAMT,
    this.dPER,
    this.dAMT,
    this.nETAMT,
  });

  SalesListDtlModel.fromJson(Map<String, dynamic> json)
      : sRNO = json['SRNO'] as String?,
        tRNO = json['TRNO'] as int?,
        fKMAST = json['FKMAST'] as String?,
        iTEMNAME = json['ITEM_NAME'] as String?,
        fKUOM = json['FKUOM'] as String?,
        fAC = json['FAC'] as int?,
        fKWLOC = json['FKWLOC'] as String?,
        wAREHOUSE = json['WAREHOUSE'] as String?,
        qTY = json['QTY'] as double?,
        uQTY = json['UQTY'] as double?,
        rATE = json['RATE'] as double?,
        gRAMT = json['GRAMT'] as double?,
        dPER = json['DPER'] as double?,
        dAMT = json['DAMT'] as double?,
        nETAMT = json['NETAMT'] as double?;

  Map<String, dynamic> toJson() => {
    'SRNO' : sRNO,
    'TRNO' : tRNO,
    'FKMAST' : fKMAST,
    'ITEM_NAME' : iTEMNAME,
    'FKUOM' : fKUOM,
    'FAC' : fAC,
    'FKWLOC' : fKWLOC,
    'WAREHOUSE' : wAREHOUSE,
    'QTY' : qTY,
    'UQTY' : uQTY,
    'RATE' : rATE,
    'GRAMT' : gRAMT,
    'DPER' : dPER,
    'DAMT' : dAMT,
    'NETAMT' : nETAMT
  };
}