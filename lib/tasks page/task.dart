import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  String? date; // Assuming it's a String in Firestore
  bool isCompleted;
  String priority;
  Timestamp? createdAt; // Add a timestamp for creation date

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.isCompleted,
      required this.priority,
      required this.createdAt});

  // Adjust this method to handle date conversion
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'], // Keep it as a String if it's a string in Firestore
      isCompleted: data['isCompleted'] ?? false,
      priority: data['priority'] ?? 'Low', createdAt: null,
    );
  }
}
