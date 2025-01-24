import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:learning_getx/app/modules/dashboard/views/event_detail_view.dart';
import 'package:learning_getx/app/data/event_response.dart'; // Import BaseUrl
import 'package:lottie/lottie.dart';
import 'package:learning_getx/app/modules/dashboard/controllers/dashboard_controller.dart';






class IndexView extends GetView {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller untuk Dashboard menggunakan GetX
    DashboardController controller = Get.put(DashboardController());

    // Membuat ScrollController untuk mengontrol scroll pada ListView
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        // Membuat AppBar dengan judul "Event List"
        title: const Text('Event List'),
        centerTitle: true, // Menjadikan judul di tengah AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberi padding di sekitar konten
        child: FutureBuilder<EventResponse>(
          // Mengambil data event melalui fungsi getEvent dari controller
          future: controller.getEvent(),
          builder: (context, snapshot) {
            // Jika data sedang dimuat, tampilkan animasi loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.network(
                  // Menggunakan animasi Lottie untuk tampilan loading
                  'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                  repeat: true, // Animasi akan berulang terus-menerus
                  width: MediaQuery.of(context).size.width / 1, // Menyesuaikan lebar animasi
                ),
              );
            }

            // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
            if (snapshot.data == null || snapshot.data!.events!.isEmpty) {
              return const Center(child: Text("Tidak ada data"));
            }

            // Tampilkan ListView berisi event
            return ListView.builder(
              itemCount: snapshot.data!.events!.length,
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // Ambil event berdasarkan index
                final event = snapshot.data!.events![index];

                return ZoomTapAnimation(
                  onTap: () {
                    // Navigasi ke EventDetailView, kirim data event melalui arguments
                    Get.to(() => EventDetailView(), arguments: event);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan gambar event
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
                      // Menampilkan judul event
                      Text(
                        event.name ?? 'No Title', // Ambil title dari event, atau tampilkan default jika null
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Menampilkan deskripsi event
                      Text(
                        event.description ?? 'No Description', // Ambil deskripsi atau tampilkan default
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.location ?? 'No Location', // Ambil lokasi event
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
