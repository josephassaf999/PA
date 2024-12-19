import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_assistant_app/NotificationService.dart';
import 'package:personal_assistant_app/appointments%20page/add_appt.dart';
import 'package:personal_assistant_app/appointments%20page/appointment.dart';
import 'package:personal_assistant_app/appointments%20page/appt_details.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  // Initialize NotificationService
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initialize(); // Initialize notifications
  }

  // Method to toggle Appointment completion in Firestore
  void _toggleAppointmentCompletion(
      String appointmentId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Appointments')
          .doc(appointmentId)
          .update({
        'isCompleted': !currentStatus,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling appointment completion: $e')),
      );
    }
  }

  // Method to delete Appointment from Firestore
  void _deleteAppointment(String taskId, String? taskDate) async {
    try {
      if (taskDate != null) {
        // Convert task.date to DateTime if it's a valid string
        DateTime parsedDate = DateTime.parse(taskDate);
        int notificationId = parsedDate
            .hashCode; // Use the DateTime to generate the notification ID
        await notificationService.cancelNotification(notificationId);
      }

      // Now delete the task from Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Appointments')
          .doc(taskId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Appointments')
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching appointments'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments available'));
          }

          // Convert documents into Appointment objects
          final appointments = snapshot.data!.docs
              .map((doc) => Appointment.fromFirestore(doc))
              .toList();

          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        appointment.title,
                        style: TextStyle(
                          decoration: appointment.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              appointment.isCompleted
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                            onPressed: () => _toggleAppointmentCompletion(
                                appointment.id, appointment.isCompleted),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteAppointment(
                                appointment.id, appointment.date),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to AppointmentDetailPage when the appointment is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetailPage(
                              appointment:
                                  appointment, // Pass the appointment to the detail page
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAppointmentPage(
                onAppointmentAdded: (title, description, date) async {},
                userId: userId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
