import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_assistant_app/appointments page/appointment.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // Format the date and time for due date
    String formattedDate = '';
    String formattedTime = '';
    if (appointment.date is Timestamp) {
      DateTime dueDate = (appointment.date as Timestamp)
          .toDate(); // Convert Timestamp to DateTime
      formattedDate = DateFormat.yMMMd().format(dueDate.toLocal());
      formattedTime = DateFormat.Hm()
          .format(dueDate.toLocal()); // Format time as hour:minute
    } else if (appointment.date is DateTime) {
      DateTime dueDate = appointment.date as DateTime; // Use DateTime directly
      formattedDate = DateFormat.yMMMd().format(dueDate.toLocal());
      formattedTime = DateFormat.Hm().format(dueDate.toLocal());
    }

    // Format the created date and time
    String formattedCreatedAtDate = '';
    String formattedCreatedAtTime = '';
    if (appointment.createdAt is Timestamp) {
      DateTime createdAtDate = (appointment.createdAt as Timestamp)
          .toDate(); // Convert Timestamp to DateTime
      formattedCreatedAtDate =
          DateFormat.yMMMd().format(createdAtDate.toLocal());
      formattedCreatedAtTime = DateFormat.Hm().format(createdAtDate.toLocal());
    } else if (appointment.createdAt is DateTime) {
      DateTime createdAtDate =
          appointment.createdAt as DateTime; // Use DateTime directly
      formattedCreatedAtDate =
          DateFormat.yMMMd().format(createdAtDate.toLocal());
      formattedCreatedAtTime = DateFormat.Hm().format(createdAtDate.toLocal());
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: const Text(
          'Appointment Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${appointment.title}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${appointment.description}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (appointment.date != null)
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
            if (appointment.createdAt != null)
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
              'Status: ${appointment.isCompleted ? 'Completed' : 'Pending'}',
              style: TextStyle(
                fontSize: 16,
                color: appointment.isCompleted ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
