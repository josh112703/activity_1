import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appbar.dart';
import 'navbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Stream to fetch forecasts from Firestore
  Stream<QuerySnapshot> _fetchForecasts() {
    return FirebaseFirestore.instance
        .collection('forecast')
        .orderBy('date', descending: true) // Fetch in descending order
        .snapshots();
  }

  // Format timestamp into a readable format
  String _formatDate(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Weather History',
        titleStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchForecasts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching weather history.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final forecasts = snapshot.data?.docs ?? [];

          if (forecasts.isEmpty) {
            return const Center(child: Text('No weather history available.'));
          }

          return ListView.builder(
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              final date = _formatDate(forecast['date'] as Timestamp);
              final weather = forecast['weather'] ?? 'No data';
              final notes = forecast['notes'] ?? 'No notes';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text('Weather: $weather',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text('Date: $date\nNotes: $notes'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
