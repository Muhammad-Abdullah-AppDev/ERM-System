class ResponseDataModel {
  final String? serialno;
  final String? status;

  ResponseDataModel({
    required this.serialno,
    required this.status,

  });

  factory ResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ResponseDataModel(
      serialno: json['SRNO'] as String,
      status: json['PST'] as String,
    );
  }
}
