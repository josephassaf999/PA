import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_assistant_app/assets%20page/asset.dart';

class AssetDetailsPage extends StatelessWidget {
  final Asset asset;

  const AssetDetailsPage({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
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
                    'Due date: ${_formatDate(asset.date)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Due time: ${_formatTime(asset.date)}',
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
                    'Created at: ${_formatDate(asset.createdAt)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created time: ${_formatTime(asset.createdAt)}',
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

  // Helper method to format the date
  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat.yMMMd().format((date as Timestamp).toDate());
    } else if (date is DateTime) {
      return DateFormat.yMMMd().format(date);
    } else if (date is String) {
      try {
        DateTime parsedDate =
            DateTime.parse(date); // Parsing the string to DateTime
        return DateFormat.yMMMd().format(parsedDate);
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'No date available';
    }
  }

  // Helper method to format the time
  String _formatTime(dynamic date) {
    if (date is Timestamp) {
      return DateFormat.Hm().format((date as Timestamp).toDate());
    } else if (date is DateTime) {
      return DateFormat.Hm().format(date);
    } else if (date is String) {
      try {
        DateTime parsedDate =
            DateTime.parse(date); // Parsing the string to DateTime
        return DateFormat.Hm().format(parsedDate);
      } catch (e) {
        return 'Invalid time format';
      }
    } else {
      return 'No time available';
    }
  }
}
