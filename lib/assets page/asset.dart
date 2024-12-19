import 'package:cloud_firestore/cloud_firestore.dart';

class Asset {
  String id;
  String title;
  String description;
  String? date; // Assuming it's stored as a String
  bool isCompleted;
  Timestamp? createdAt;

  Asset(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.isCompleted,
      required this.createdAt});

  factory Asset.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Asset(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? null, // Keep as String if it's stored as a String
      isCompleted: data['isCompleted'] ?? false, createdAt: null,
    );
  }
}
