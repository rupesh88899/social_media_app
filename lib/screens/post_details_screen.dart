import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app_data.dart';
import 'package:social_media/models/comment_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/screens/user_profile_screen.dart';

class PostDetailsScreen extends StatelessWidget {
  final int postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final PostModel? post =
        AppData().posts.firstWhereOrNull((p) => p.id == postId);
    final List<CommentModel> comments =
        AppData().comments.where((c) => c.postId == postId).toList();

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Post Details")),
        body: const Center(
          child: Text("Post not found."),
        ),
      );
    }

    final UserModel? author =
        AppData().users.firstWhereOrNull((u) => u.id == post.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                post.body,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (author != null) {
                    Get.to(() => UserProfileScreen(userId: author.id));
                  } else {
                    Get.snackbar("Error", "Author information not found.");
                  }
                },
                icon: const Icon(Icons.person),
                label: const Text("View Author Profile"),
              ),
              const SizedBox(height: 30),
              const Text(
                "Comments",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ...comments.map((comment) => Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        comment.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.email,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            comment.body,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
