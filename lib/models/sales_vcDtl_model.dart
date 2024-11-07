class SalesVcDtlModel {
  final String? sRNO;
  final int? tRNO;
  final String? fKMAST;
  final String? iTEM_NAME;
  final String? fKUOM;
  final int? fAC;
  final String? fKWLOC;
  final dynamic fKTOWLOC;
  final dynamic rEFQTY;
  final dynamic rCVQTY;
  final double? qTY;
  final dynamic rEJQTY;
  final double? uQTY;
  final double? rATE;
  final dynamic aVGRT;
  final dynamic tXABAMT;
  final dynamic sTPER;
  final dynamic sTAMT;
  final dynamic fEDPER;
  final dynamic fEDAMT;
  final dynamic sEDPER;
  final dynamic sEDAMT;
  final double? gRAMT;
  final double? dPER;
  final double? dAMT;
  final double? nETAMT;
  final dynamic rMKS;
  final dynamic rSRNO;
  final dynamic cOST;
  final dynamic rTRNO;
  final dynamic pERCOM;
  final dynamic cOMAMT;
  final dynamic cOSRATE;
  final dynamic cOMRATE;
  final dynamic rOLL;
  final dynamic rSIZ;
  final dynamic lQTY;
  final dynamic lRATE;
  final dynamic pRQTY;
  final String? pST;
  final dynamic fKEMP;
  final dynamic fKAGENT;
  final dynamic bEHV;
  final dynamic iNUSID;
  final dynamic iNDT;
  final dynamic uPUSID;
  final dynamic uPDT;
  final dynamic gLOSS;
  final dynamic tOQTY;
  final dynamic tOVALUE;
  final dynamic tAXES;
  final dynamic fKISR;
  final dynamic fKGPO;
  final dynamic fKGPR;
  final dynamic fKFSCD;
  final dynamic fCRATE;
  final dynamic eXCRATE;
  final dynamic fCGRAMT;
  final dynamic sNAME;
  final dynamic tORS;
  final dynamic oCOST;
  final dynamic oCHRGS;
  final dynamic rRATE;
  final dynamic rGRAMT;
  final dynamic rCVAMT;
  final dynamic iCLVL;
  final dynamic iCTMAST;
  final dynamic iCWLOC;
  final dynamic iCWLOC1;

  SalesVcDtlModel({
    this.sRNO,
    this.tRNO,
    this.fKMAST,
    this.iTEM_NAME,
    this.fKUOM,
    this.fAC,
    this.fKWLOC,
    this.fKTOWLOC,
    this.rEFQTY,
    this.rCVQTY,
    this.qTY,
    this.rEJQTY,
    this.uQTY,
    this.rATE,
    this.aVGRT,
    this.tXABAMT,
    this.sTPER,
    this.sTAMT,
    this.fEDPER,
    this.fEDAMT,
    this.sEDPER,
    this.sEDAMT,
    this.gRAMT,
    this.dPER,
    this.dAMT,
    this.nETAMT,
    this.rMKS,
    this.rSRNO,
    this.cOST,
    this.rTRNO,
    this.pERCOM,
    this.cOMAMT,
    this.cOSRATE,
    this.cOMRATE,
    this.rOLL,
    this.rSIZ,
    this.lQTY,
    this.lRATE,
    this.pRQTY,
    this.pST,
    this.fKEMP,
    this.fKAGENT,
    this.bEHV,
    this.iNUSID,
    this.iNDT,
    this.uPUSID,
    this.uPDT,
    this.gLOSS,
    this.tOQTY,
    this.tOVALUE,
    this.tAXES,
    this.fKISR,
    this.fKGPO,
    this.fKGPR,
    this.fKFSCD,
    this.fCRATE,
    this.eXCRATE,
    this.fCGRAMT,
    this.sNAME,
    this.tORS,
    this.oCOST,
    this.oCHRGS,
    this.rRATE,
    this.rGRAMT,
    this.rCVAMT,
    this.iCLVL,
    this.iCTMAST,
    this.iCWLOC,
    this.iCWLOC1,
  });

  SalesVcDtlModel.fromJson(Map<String, dynamic> json)
      : sRNO = json['SRNO'] as String?,
        tRNO = json['TRNO'] as int?,
        fKMAST = json['FKMAST'] as String?,
        iTEM_NAME = json['ITEM_NAME'] as String?,
        fKUOM = json['FKUOM'] as String?,
        fAC = json['FAC'] as int?,
        fKWLOC = json['FKWLOC'] as String?,
        fKTOWLOC = json['FKTOWLOC'],
        rEFQTY = json['REFQTY'],
        rCVQTY = json['RCVQTY'],
        qTY = json['QTY'] as double?,
        rEJQTY = json['REJQTY'],
        uQTY = json['UQTY'] as double?,
        rATE = json['RATE'] as double?,
        aVGRT = json['AVGRT'],
        tXABAMT = json['TXABAMT'],
        sTPER = json['STPER'],
        sTAMT = json['STAMT'],
        fEDPER = json['FEDPER'],
        fEDAMT = json['FEDAMT'],
        sEDPER = json['SEDPER'],
        sEDAMT = json['SEDAMT'],
        gRAMT = json['GRAMT'] as double?,
        dPER = json['DPER'] as double?,
        dAMT = json['DAMT'] as double?,
        nETAMT = json['NETAMT'] as double?,
        rMKS = json['RMKS'],
        rSRNO = json['RSRNO'],
        cOST = json['COST'],
        rTRNO = json['RTRNO'],
        pERCOM = json['PERCOM'],
        cOMAMT = json['COMAMT'],
        cOSRATE = json['COSRATE'],
        cOMRATE = json['COMRATE'],
        rOLL = json['ROLL'],
        rSIZ = json['RSIZ'],
        lQTY = json['LQTY'],
        lRATE = json['LRATE'],
        pRQTY = json['PRQTY'],
        pST = json['PST'] as String?,
        fKEMP = json['FKEMP'],
        fKAGENT = json['FKAGENT'],
        bEHV = json['BEHV'],
        iNUSID = json['INUSID'],
        iNDT = json['INDT'],
        uPUSID = json['UPUSID'],
        uPDT = json['UPDT'],
        gLOSS = json['GLOSS'],
        tOQTY = json['TOQTY'],
        tOVALUE = json['TOVALUE'],
        tAXES = json['TAXES'],
        fKISR = json['FKISR'],
        fKGPO = json['FKGPO'],
        fKGPR = json['FKGPR'],
        fKFSCD = json['FKFSCD'],
        fCRATE = json['FCRATE'],
        eXCRATE = json['EXCRATE'],
        fCGRAMT = json['FCGRAMT'],
        sNAME = json['SNAME'],
        tORS = json['TORS'],
        oCOST = json['OCOST'],
        oCHRGS = json['OCHRGS'],
        rRATE = json['RRATE'],
        rGRAMT = json['RGRAMT'],
        rCVAMT = json['RCVAMT'],
        iCLVL = json['ICLVL'],
        iCTMAST = json['ICTMAST'],
        iCWLOC = json['ICWLOC'],
        iCWLOC1 = json['ICWLOC1'];

  Map<String, dynamic> toJson() => {
    'SRNO' : sRNO,
    'TRNO' : tRNO,
    'FKMAST' : fKMAST,
    'ITEM_NAME' : iTEM_NAME,
    'FKUOM' : fKUOM,
    'FAC' : fAC,
    'FKWLOC' : fKWLOC,
    'FKTOWLOC' : fKTOWLOC,
    'REFQTY' : rEFQTY,
    'RCVQTY' : rCVQTY,
    'QTY' : qTY,
    'REJQTY' : rEJQTY,
    'UQTY' : uQTY,
    'RATE' : rATE,
    'AVGRT' : aVGRT,
    'TXABAMT' : tXABAMT,
    'STPER' : sTPER,
    'STAMT' : sTAMT,
    'FEDPER' : fEDPER,
    'FEDAMT' : fEDAMT,
    'SEDPER' : sEDPER,
    'SEDAMT' : sEDAMT,
    'GRAMT' : gRAMT,
    'DPER' : dPER,
    'DAMT' : dAMT,
    'NETAMT' : nETAMT,
    'RMKS' : rMKS,
    'RSRNO' : rSRNO,
    'COST' : cOST,
    'RTRNO' : rTRNO,
    'PERCOM' : pERCOM,
    'COMAMT' : cOMAMT,
    'COSRATE' : cOSRATE,
    'COMRATE' : cOMRATE,
    'ROLL' : rOLL,
    'RSIZ' : rSIZ,
    'LQTY' : lQTY,
    'LRATE' : lRATE,
    'PRQTY' : pRQTY,
    'PST' : pST,
    'FKEMP' : fKEMP,
    'FKAGENT' : fKAGENT,
    'BEHV' : bEHV,
    'INUSID' : iNUSID,
    'INDT' : iNDT,
    'UPUSID' : uPUSID,
    'UPDT' : uPDT,
    'GLOSS' : gLOSS,
    'TOQTY' : tOQTY,
    'TOVALUE' : tOVALUE,
    'TAXES' : tAXES,
    'FKISR' : fKISR,
    'FKGPO' : fKGPO,
    'FKGPR' : fKGPR,
    'FKFSCD' : fKFSCD,
    'FCRATE' : fCRATE,
    'EXCRATE' : eXCRATE,
    'FCGRAMT' : fCGRAMT,
    'SNAME' : sNAME,
    'TORS' : tORS,
    'OCOST' : oCOST,
    'OCHRGS' : oCHRGS,
    'RRATE' : rRATE,
    'RGRAMT' : rGRAMT,
    'RCVAMT' : rCVAMT,
    'ICLVL' : iCLVL,
    'ICTMAST' : iCTMAST,
    'ICWLOC' : iCWLOC,
    'ICWLOC1' : iCWLOC1
  };
}