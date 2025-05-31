import 'package:social_media/models/comment_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_model.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  List<PostModel> posts = [];
  List<CommentModel> comments = [];
  List<UserModel> users = [];

  void clearData() {
    posts.clear();
    comments.clear();
    users.clear();
  }
}
