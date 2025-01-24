import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_getx/app/data/event_response.dart';

class EventDetailView extends StatelessWidget {
  final Events? event = Get.arguments; // Menerima argumen

  EventDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Jika argumen tidak ada, tampilkan error
    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Event Detail'),
        ),
        body: const Center(
          child: Text('Event data is not available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event?.name ?? 'Event Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/id/${event?.id}/700/300',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('Image not found')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event?.name ?? 'No Title',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              event?.description ?? 'No Description',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Text(event?.location ?? 'No Location',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(height: 32),
          ],
        ),
      ),
    );
  }
}
