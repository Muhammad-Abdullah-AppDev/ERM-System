class PartyBalanceModel {
  final String? pKCODE;
  final String? nAME;
  final double? dEBIT;
  final double? cREDIT;
  final double? bAL;

  PartyBalanceModel({
    this.pKCODE,
    this.nAME,
    this.dEBIT,
    this.cREDIT,
    this.bAL,
  });

  PartyBalanceModel.fromJson(Map<String, dynamic> json)
      : pKCODE = json['PKCODE'] as String?,
        nAME = json['NAME'] as String?,
        dEBIT = json['DEBIT'] as double?,
        cREDIT = json['CREDIT'] as double?,
        bAL = json['BAL'] as double?;

  Map<String, dynamic> toJson() => {
    'PKCODE' : pKCODE,
    'NAME' : nAME,
    'DEBIT' : dEBIT,
    'CREDIT' : cREDIT,
    'BAL' : bAL
  };
}