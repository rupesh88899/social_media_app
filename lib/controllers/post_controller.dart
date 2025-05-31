import 'package:get/get.dart';
import 'package:social_media/api/api_service.dart';
import 'package:social_media/app_data.dart';
import 'package:social_media/exceptions/app_exceptions.dart';
import 'package:social_media/models/comment_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_model.dart';

class PostController extends GetxController {
  final ApiService _apiService = ApiService();

  //loading error srates
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  //fetch all(user,post, comment)
  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetching user data
      final usersResponse = await _apiService.getRequest('/users');
      // Fetching posts
      final postsResponse = await _apiService.getRequest('/posts');
      // Fetching comments
      final commentsResponse = await _apiService.getRequest('/comments');

      AppData().users = (usersResponse.data as List)
          .map((e) => UserModel.fromMap(e))
          .toList();

      AppData().posts = (postsResponse.data as List)
          .map((e) => PostModel.fromMap(e))
          .toList();

      AppData().comments = (commentsResponse.data as List)
          .map((e) => CommentModel.fromMap(e))
          .toList();
    } catch (e) {
      if (e is AppException) {
        errorMessage.value = e.toString();
      } else {
        errorMessage.value = 'Unexpected error occurred';
      }
    } finally {
      isLoading.value = false;
    }
  }

///////////////// CREATE NEW POST /////////////////
  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.postRequest('/posts', {
        'title': title,
        'body': body,
        'userId': userId,
      });

      final newPost = PostModel.fromMap(response.data);
      AppData()
          .posts
          .insert(0, newPost); // Add new post to the beginning of the list
    } catch (e) {
      if (e is AppException) {
        errorMessage.value = e.toString();
      } else {
        errorMessage.value = 'Unexpected error occurred';
      }
    } finally {
      isLoading.value = false;
    }
  }
}
