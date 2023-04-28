class ProductModel {
  final int code;
  final String name;
  final double retailPrice;
  final double tradePrice;
  final dynamic packing;

  ProductModel({
    required this.code,
    required this.name,
    required this.retailPrice,
    required this.tradePrice,
    required this.packing,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      code: json['code'],
      name: json['name'],
      retailPrice: json['mrp'].toDouble(),
      tradePrice: json['trp'].toDouble(),
      packing: json['packing'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['mrp'] = retailPrice;
    data['trp'] = tradePrice;
    data['packing'] = packing;
    return data;
  }
}
