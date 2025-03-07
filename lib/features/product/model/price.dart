class Price {
  final int id;
  final double netPrice;
  final String currency;
  final double vatRate;

  Price({
    required this.id,
    required this.netPrice,
    required this.currency,
    required this.vatRate,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'] ?? 0,
      netPrice: json['netPrice'].toDouble(),
      currency: json['currency'],
      vatRate: json['vatRate'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'netPrice': netPrice,
      'currency': currency,
      'vatRate': vatRate,
    };
  }
}
