import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_assistant_app/NotificationService.dart';
import 'package:personal_assistant_app/assets%20page/add_assets.dart';
import 'package:personal_assistant_app/assets%20page/asset.dart';
import 'package:personal_assistant_app/assets page/assets_details.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  // Initialize NotificationService
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initialize(); // Initialize notifications
  }

  Future<bool> _isAssetDuplicate(String title, String description) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Assets')
          .where('title', isEqualTo: title)
          .where('description', isEqualTo: description)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking duplicate Asset: $e')),
      );
      return false;
    }
  }

  void _toggleAssetCompletion(String assetId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Assets')
          .doc(assetId)
          .update({'isCompleted': !currentStatus});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling Asset completion: $e')),
      );
    }
  }

  void _deleteAsset(String assetId, String? assetDate) async {
    try {
      if (assetDate != null) {
        DateTime parsedDate =
            DateTime.parse(assetDate); // Convert String to DateTime
        int notificationId = parsedDate.hashCode; // Generate notification ID
        await notificationService
            .cancelNotification(notificationId); // Cancel notification
      }

      // Now delete the asset from Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Assets')
          .doc(assetId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Asset: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Assets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Assets')
            .orderBy('date', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching Assets'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Assets available.'));
          }

          final assets = snapshot.data!.docs
              .map((doc) => Asset.fromFirestore(doc))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      asset.title,
                      style: TextStyle(
                        decoration: asset.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            asset.isCompleted
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () => _toggleAssetCompletion(
                              asset.id, asset.isCompleted),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteAsset(asset.id, asset.date),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetDetailsPage(asset: asset),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAssetPage(
                onAssetAdded: (title, description, date) async {},
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
