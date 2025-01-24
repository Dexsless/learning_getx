import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_getx/app/modules/dashboard/controllers/dashboard_controller.dart';

class EventDetailView extends StatelessWidget {
  const EventDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil controller untuk mengelola data detail event
    final DashboardController controller = Get.find();
    final int eventId = Get.arguments ?? 0; // Ambil ID event dari argumen

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getDetailEvent(id: eventId), // Panggil detail event dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Event not found'),
            );
          }

          final event = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar event
                Image.network(
                  'https://picsum.photos/id/${event.id}/700/300',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('Image not found'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Judul event
                Text(
                  event.name ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Deskripsi event
                Text(
                  event.description ?? 'No Description',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                // Lokasi event
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.location ?? 'No Location',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tanggal event
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.eventDate ?? 'No Date',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tombol kembali
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Kembali ke halaman sebelumnya
                    },
                    child: const Text('Back'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
