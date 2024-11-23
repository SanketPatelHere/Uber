
class OrderModel {
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

  final bool status;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;


  

  OrderModel({
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

    required this.status,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerDeviceToken,

  });

  // Serialize the OrderModel instance to a JSON map
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

      'status': status,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
    };
  }

  // Create a OrderModel instance from a JSON map
  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
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

      status: json['status'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerDeviceToken: json['customerDeviceToken'],
    );
  }
}