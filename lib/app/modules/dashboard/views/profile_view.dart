import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_connect.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  final _getConnect = GetConnect(); // GetConnect instance for API requests
  final token = GetStorage().read('token'); // Get the token from storage

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final response = await _getConnect.get(
      'https://praujikom.smkassalaambandung.sch.id/api/profile',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  void logout() {
    GetStorage().remove('token'); // Hapus token dari storage
    Get.offAllNamed('/login'); // Arahkan ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data available'));
          }

          final userProfile = snapshot.data!;
          final userName = userProfile['name'] ?? 'Guest';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/default_avatar.png'), // Replace with a default avatar
                ),
                const SizedBox(height: 16),
                Text(
                  'Hello, $userName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to your profile. Here is your information:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: Text(userProfile['email'] ?? 'No email provided'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: Text(userProfile['phone'] ?? 'No phone number provided'),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.orange),
                  title: Text(userProfile['address'] ?? 'No address provided'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logout,
        backgroundColor: Colors.red, // Warna tombol logout
        child: const Icon(Icons.logout),
      ),
    );
  }
}
