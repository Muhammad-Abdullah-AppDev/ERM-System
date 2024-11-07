class DialogAccountNumberDataModel {

  final String? accountpkcode;
  final String? accountname;

  DialogAccountNumberDataModel({
    required this.accountpkcode,
    required this.accountname,
  });

  factory DialogAccountNumberDataModel.fromJson(Map<String, dynamic> json) {
    return DialogAccountNumberDataModel(
      accountpkcode: json['PKCODE'] as String,
      accountname: json['NAME'] as String,

    );
  }

}