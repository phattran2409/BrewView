import 'package:flutter/material.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/view/post_create_form.dart';

class PostEditForm extends StatelessWidget {
  final PostModel post;

  const PostEditForm({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return PostCreateForm(
      existingPost: post,
      isEditMode: true,
      cafeId: post.cafe?.cafeId,
    );
  }
}

