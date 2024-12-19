import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_assistant_app/assets%20page/asset.dart';

class AssetDetailsPage extends StatelessWidget {
  final Asset asset;

  const AssetDetailsPage({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    // Format the date and time for due date
    String formattedDate = '';
    String formattedTime = '';
    if (asset.date is Timestamp) {
      DateTime dueDate =
          (asset.date as Timestamp).toDate(); // Convert Timestamp to DateTime
      formattedDate = DateFormat.yMMMd().format(dueDate.toLocal());
      formattedTime = DateFormat.Hm()
          .format(dueDate.toLocal()); // Format time as hour:minute
    } else if (asset.date is DateTime) {
      DateTime dueDate = asset.date as DateTime; // Use DateTime directly
      formattedDate = DateFormat.yMMMd().format(dueDate.toLocal());
      formattedTime = DateFormat.Hm().format(dueDate.toLocal());
    }

    // Format the created date and time
    String formattedCreatedAtDate = '';
    String formattedCreatedAtTime = '';
    if (asset.createdAt is Timestamp) {
      DateTime createdAtDate = (asset.createdAt as Timestamp)
          .toDate(); // Convert Timestamp to DateTime
      formattedCreatedAtDate =
          DateFormat.yMMMd().format(createdAtDate.toLocal());
      formattedCreatedAtTime = DateFormat.Hm().format(createdAtDate.toLocal());
    } else if (asset.createdAt is DateTime) {
      DateTime createdAtDate =
          asset.createdAt as DateTime; // Use DateTime directly
      formattedCreatedAtDate =
          DateFormat.yMMMd().format(createdAtDate.toLocal());
      formattedCreatedAtTime = DateFormat.Hm().format(createdAtDate.toLocal());
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: const Text(
          'Asset Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${asset.title}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${asset.description}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (asset.date != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due date: $formattedDate',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Due time: $formattedTime', // Display the time
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            if (asset.createdAt != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created at: $formattedCreatedAtDate',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created time: $formattedCreatedAtTime',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              'Status: ${asset.isCompleted ? 'Completed' : 'Pending'}',
              style: TextStyle(
                fontSize: 16,
                color: asset.isCompleted ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
