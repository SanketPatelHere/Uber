
class ReviewModel {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerDeviceToken;
  final String feedback;
  final String rating;
  final String createdAt;

  ReviewModel({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerDeviceToken,
    required this.feedback,
    required this.rating,
    required this.createdAt,
  });

  // Serialize the ReviewModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerDeviceToken': customerDeviceToken,
      'feedback': feedback,
      'rating': rating,
      'createdAt': createdAt,

    };
  }

  /*
  factory =
  a creational design pattern that allows developers to create objects in a superclass
  while still allowing subclasses to decide which object to instantiate Factory constructors

  A special type of constructor that can return an instance of a class in different ways,
  such as an existing instance, a different class, or a subtype
   */
  // Create a ReviewModel instance from a JSON map
  factory ReviewModel.fromMap(Map<String, dynamic> json) {
    return ReviewModel(
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerDeviceToken: json['customerDeviceToken'],
      feedback: json['feedback'],
      rating: json['rating'],
      createdAt: json['createdAt'],
    );
  }
}