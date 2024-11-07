class CustomerLegderModel {
  final double? id;
  final String? pfkMast;
  final String? name;
  final double? opBal;
  final String? dfkMast;
  final String? vdt;
  final String? vtyp;
  final String? rmks;
  final String? chqNo;
  final String? srNo;
  final String? fkMast;
  final double? debit;
  final double? credit;
  final double? balDiff;
  final double? dpfkMast;
  final String? brand;
  final double? qty;
  final double? rate;
  final double? fair;
  final double? unfair;

  CustomerLegderModel(
      {this.id,
      this.pfkMast,
      this.name,
      this.opBal,
      this.dfkMast,
      this.vdt,
      this.vtyp,
      this.rmks,
      this.chqNo,
      this.srNo,
      this.fkMast,
      this.debit,
      this.credit,
      this.balDiff,
      this.dpfkMast,
      this.brand,
      this.qty,
      this.rate,
      this.fair,
      this.unfair});

  factory CustomerLegderModel.fromJson(Map<String, dynamic> json) {
    return CustomerLegderModel(
      id: json['ID'],
      pfkMast: json['PFKMAST'],
      name: json['NAME'],
      opBal: json['OPBAL'],
      dfkMast: json['DFKMAST'],
      vdt: json['VDT'],
      vtyp: json['VTYP'],
      rmks: json['RMKS'],
      chqNo: json['CHQNO'],
      srNo: json['SRNO'],
      fkMast: json['FKMAST'],
      debit: json['DEBIT'],
      credit: json['CREDIT'],
      balDiff: json['BALDIFF'],
      dpfkMast: json['DPFKMAST'],
      brand: json['BRAND'],
      qty: json['QTY'],
      rate: json['RATE'],
      fair: json['FARE'],
      unfair: json['UNFARE'],
    );
  }
}
