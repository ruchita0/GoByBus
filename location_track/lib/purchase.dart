import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_track/purchase_status.dart';

class Purchase {
  final String id;
  final String userId;
  final String name;
  final int price;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String orderId;
  final String? paymentId;
  final String? refundedId;
  final PaymentStatus paymentStatus;

  Purchase({
    required this.id,
    required this.userId,
    required this.name,
    required this.price,
    required this.createdAt,
    this.updatedAt,
    required this.orderId,
    this.paymentId,
    this.refundedId,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'orderId': orderId,
      'paymentId': paymentId,
      'refundedId': refundedId,
      'paymentStatus': paymentStatus.name,
    };
  }

  factory Purchase.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Purchase(
      id: doc.id,
      userId: map['userId'] as String,
      name: map['name'] as String,
      price: map['price'] as int,
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      orderId: map['orderId'] as String,
      paymentId: map['paymentId'] as String?,
      refundedId: map['refundedId'] as String?,
      paymentStatus: PaymentStatus.values.firstWhere(
        (element) => element.name == map['paymentStatus'] as String,
        orElse: () => PaymentStatus.unknown,
      ),
    );
  }
}
