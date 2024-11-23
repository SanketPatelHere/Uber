
class ProductModel {
  final String categoryId;
  final String categoryName;
  final String createdAt;
  final String updatedAt;
  
  final String deliveryTime;
  final String productId;
  final String productName;
  final String productDescription;
  final String fullPrice;
  final String salePrice;
  final bool isSale;
  final List productImage;
  

  ProductModel({
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,

    required this.deliveryTime,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.fullPrice,
    required this.salePrice,
    required this.isSale,
    required this.productImage,
  });

  // Serialize the ProductModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,

      'deliveryTime': deliveryTime,
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'fullPrice': fullPrice,
      'salePrice': salePrice,
      'isSale': isSale,
      'productImage': productImage,
    };
  }

  // Create a ProductModel instance from a JSON map
  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

      deliveryTime: json['deliveryTime'],
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      fullPrice: json['fullPrice'],
      salePrice: json['salePrice'],
      isSale: json['isSale'],
      productImage: json['productImage'],
    );
  }
}