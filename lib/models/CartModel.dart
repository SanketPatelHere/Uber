
class CartModel {
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

  final int productQuantity;
  final double productTotalPrice;

  

  CartModel({
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
    required this.productQuantity,
    required this.productTotalPrice,
  });

  // Serialize the CartModel instance to a JSON map
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
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  // Create a CartModel instance from a JSON map
  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
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
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
    );
  }
}