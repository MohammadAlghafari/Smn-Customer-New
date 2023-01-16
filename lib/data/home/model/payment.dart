class Payment {
  String? id;
  String? status;
  String? method;
  String? methodAr;
  double? price;

  Payment(this.method, {this.id, this.status, this.price,this.methodAr});

  factory Payment.fromJSON(Map<String, dynamic> jsonMap) {
    return Payment(jsonMap['method'],
        id: jsonMap['id'].toString(),
        status: jsonMap['status'] ?? '',
        methodAr: jsonMap['method_ar'] ?? '',
        price: jsonMap['price'] != null
            ? double.parse(jsonMap['price'].toString())
            : 0.0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
      'method_ar': methodAr,
      'price': price,
    };
  }
}
