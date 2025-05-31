import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app_data.dart';
import 'package:social_media/models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final UserModel? user =
        AppData().users.firstWhereOrNull((u) => u.id == userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(
              child: Text("User not found"),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    // Profile Icon
                    CircleAvatar(
                      radius: 50, // Adjust size as needed
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User Details Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:
                              MainAxisSize.min, // Adjust height to fit content
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Username: ${user.username}"),
                            const SizedBox(height: 8),
                            Text("Email: ${user.email}"),
                            const SizedBox(height: 8),
                            Text("Phone: ${user.phone}"),
                            const SizedBox(height: 8),
                            Text("Website: ${user.website}"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
