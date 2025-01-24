import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:learning_getx/app/modules/dashboard/views/index_view.dart';
import 'package:learning_getx/app/modules/dashboard/views/your_event_view.dart';
import 'package:learning_getx/app/modules/dashboard/views/profile_view.dart';
import 'package:learning_getx/app/utils/api.dart'; // Import BaseUrl
import 'package:get_storage/get_storage.dart';
import 'package:learning_getx/app/data/event_response.dart';
import 'package:learning_getx/app/data/detail_event_response.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  final _getConnect = GetConnect();
  final token = GetStorage().read('token');

  // Tambahkan deklarasi controller untuk input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  var yourEvents = <Events>[].obs;

  Future<DetailEventResponse> getDetailEvent({required int id}) async {
    final response = await _getConnect.get(
      '${BaseUrl.detailEvents}/$id',
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return DetailEventResponse.fromJson(response.body);
  }

  Future<EventResponse> getEvent() async {
    final response = await _getConnect.get(
      BaseUrl.events,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return EventResponse.fromJson(response.body);
  }

  Future<void> getYourEvent() async {
    final response = await _getConnect.get(
      BaseUrl.yourEvent,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    final eventResponse = EventResponse.fromJson(response.body);
    yourEvents.value = eventResponse.events ?? [];
  }

  void addEvent() async {
    final response = await _getConnect.post(
      BaseUrl.events,
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'event_date': eventDateController.text,
        'location': locationController.text,
      },
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        'Success',
        'Event Added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();
      update();
      getEvent();
      getYourEvent();
      Get.close(1);
    } else {
      Get.snackbar(
        'Failed',
        'Event Failed to Add',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

void editEvent({required int id}) async {
  final response = await _getConnect.post(
    '${BaseUrl.events}/$id', // URL endpoint
    {
      'name': nameController.text,
      'description': descriptionController.text,
      'event_date': eventDateController.text,
      'location': locationController.text,
      '_method': 'PUT', // Overriding ke metode PUT
    },
    headers: {'Authorization': "Bearer $token"},
    contentType: "application/json",
  );

  if (response.statusCode == 200) {
    // Notifikasi sukses
    Get.snackbar(
      'Success',
      'Event Updated',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Clear form dan update UI
    nameController.clear();
    descriptionController.clear();
    eventDateController.clear();
    locationController.clear();
    update();
    getEvent();
    getYourEvent();
    Get.close(1); // Menutup halaman edit
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    Get.snackbar(
      'Failed',
      'Event Failed to Update: ${response.body['message'] ?? 'Unknown Error'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  // Fungsi buat hapus event, tinggal kasih ID-nya
void deleteEvent({required int id}) async {
  // Kirim request POST ke server, tapi sebenarnya buat DELETE
  final response = await _getConnect.post(
    '${BaseUrl.deleteEvents}$id', // URL endpoint ditambah ID event
    {
      '_method': 'delete', // Hack biar request diubah jadi DELETE
    },
    headers: {'Authorization': "Bearer $token"}, // Header autentikasi (token user)
    contentType: "application/json", // Data dikirim dalam format JSON
  );

  // Cek respons server, kalau sukses ya good vibes
  if (response.statusCode == 200) {
    // Notifikasi sukses hapus event
    Get.snackbar(
      'Success', // Judul snack bar
      'Event Deleted', // Pesan sukses
      snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
      backgroundColor: Colors.green, // Latar hijau biar lega
      colorText: Colors.white, // Teks putih biar baca enak
    );

    // Update UI dan reload data event biar up-to-date
    update(); // Kasih tahu UI kalau ada yang berubah
    getEvent(); // Refresh semua event
    getYourEvent(); // Refresh event user
  } else {
    // Kalau gagal, ya udah kasih tau user aja
    Get.snackbar(
      'Failed', // Judul snack bar
      'Event Failed to Delete', // Pesan error
      snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
      backgroundColor: Colors.red, // Latar merah biar tegas
      colorText: Colors.white, // Teks putih biar tetap baca jelas
    );
  }
}
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    YourEventView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    getEvent();
    getYourEvent();
    super.onInit();
  }

  @override
  void onClose() {
    // Jangan lupa dispose controller untuk menghindari kebocoran memori
    nameController.dispose();
    descriptionController.dispose();
    eventDateController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
