import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app_data.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/screens/post_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostController postController = Get.find<PostController>();

  @override
  void initState() {
    super.initState();
    postController.fetchAllData(); // Fetch data on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              postController.fetchAllData(); // Reload data
            },
          ),
        ],
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (postController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              postController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        final List<PostModel> posts = AppData().posts;

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.inbox, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No posts available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      post.title[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Get.to(() => PostDetailsScreen(postId: post.id));
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreatePostDialog(),
          );
        },
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
//////////////////////// CreatePostDialog Widget
class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final PostController postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Post'),
      content: SizedBox(
        width: double.maxFinite,
        height: 250,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _userIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'User ID'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter User ID' : null,
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                  maxLines: 3,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter body' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(() {
          return ElevatedButton(
            onPressed: postController.isLoading.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      final userId =
                          int.tryParse(_userIdController.text.trim());
                      if (userId == null) {
                        Get.snackbar("Error", "Invalid User ID");
                        return;
                      }

                      await postController.createPost(
                        userId: userId,
                        title: _titleController.text.trim(),
                        body: _bodyController.text.trim(),
                      );

                      if (postController.errorMessage.isEmpty) {
                        Get.back();
                        Get.snackbar("Success", "Post created!");
                      } else {
                        Get.snackbar(
                            "Error", postController.errorMessage.value);
                      }
                    }
                  },
            child: Text(postController.isLoading.value ? 'Posting...' : 'Save'),
          );
        }),
      ],
    );
  }
}
