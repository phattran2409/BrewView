import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/core/widgets/ImageUploadWIdget.dart';
import 'package:briewview/core/widgets/VideoUploadWidget.dart';
import 'package:briewview/features/post/model/post_mutation.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/viewmodel/post_bloc.dart';
import 'package:briewview/features/post/viewmodel/post_event.dart';
import 'package:briewview/features/post/viewmodel/post_state.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/app/di/locator.dart';

class PostCreateForm extends StatefulWidget {
  final String? cafeId;
  final PostModel? existingPost; // For editing existing post
  final bool isEditMode;

  const PostCreateForm({
    super.key,
    this.cafeId,
    this.existingPost,
    this.isEditMode = false,
  });

  @override
  State<PostCreateForm> createState() => _PostCreateFormState();
}

class _PostCreateFormState extends State<PostCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _cafeController = TextEditingController();

  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  bool _isPremium =
      false; // This should be determined by user subscription status

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.existingPost != null) {
      _titleController.text = widget.existingPost!.title ?? '';
      _contentController.text = widget.existingPost!.content;
      if (widget.existingPost!.cafe != null) {
        _cafeController.text = widget.existingPost!.cafe!.name;
      }
    }
    if (widget.cafeId != null) {
      // If cafeId is provided, you might want to fetch cafe name
      _cafeController.text = 'Selected Cafe'; // Replace with actual cafe name
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _cafeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A2D09),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.isEditMode ? 'Chỉnh sửa bài viết' : 'Tạo bài viết mới',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: const Text(
              'Đăng',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreateSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bài viết đã được tạo thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Trả về true để báo thành công
          } else if (state is PostUpdateSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bài viết đã được cập nhật thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Trả về true để báo thành công
          } else if (state is PostCreateErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PostUpdateErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                _buildTitleField(),
                const SizedBox(height: 16),

                // Content field
                _buildContentField(),
                const SizedBox(height: 16),

                // Cafe field (if not provided)
                if (widget.cafeId == null) ...[
                  _buildCafeField(),
                  const SizedBox(height: 16),
                ],

                // Image upload
                ImageUploadWidget(
                  onImagesChanged: (images) {
                    setState(() {
                      _selectedImages = images;
                    });
                  },
                  maxImages: _isPremium ? 10 : 3,
                  isPremium: _isPremium,
                ),
                const SizedBox(height: 16),

                // Video upload
                VideoUploadWidget(
                  onVideosChanged: (videos) {
                    setState(() {
                      _selectedVideos = videos;
                    });
                  },
                  maxVideos: _isPremium ? 2 : 1,
                  maxVideoDurationSeconds: 60,
                  isPremium: _isPremium,
                ),
                const SizedBox(height: 24),

                // Submit button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Tiêu đề (tùy chọn)',
          hintText: 'Nhập tiêu đề cho bài viết của bạn...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 2,
        validator: (value) {
          if (value != null && value.length > 100) {
            return 'Tiêu đề không được vượt quá 100 ký tự';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildContentField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _contentController,
        decoration: const InputDecoration(
          labelText: 'Nội dung bài viết *',
          hintText: 'Chia sẻ trải nghiệm của bạn về quán cafe này...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 6,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Vui lòng nhập nội dung bài viết';
          }
          if (value.length > 1000) {
            return 'Nội dung không được vượt quá 1000 ký tự';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCafeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _cafeController,
        decoration: const InputDecoration(
          labelText: 'Quán cafe (tùy chọn)',
          hintText: 'Chọn quán cafe liên quan...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
          suffixIcon: Icon(Icons.search),
        ),
        readOnly: true,
        onTap: () {
          // Navigate to cafe selection screen
          _showCafeSelectionDialog();
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        final isLoading =
            state is PostCreateLoadingState || state is PostUpdateLoadingState;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      widget.isEditMode ? 'Cập nhật bài viết' : 'Đăng bài viết',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        );
      },
    );
  }

  void _showCafeSelectionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chọn quán cafe'),
            content: const Text('Tính năng chọn quán cafe sẽ được thêm sau.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final userStorageServices = getIt<UserStorageServices>();
      final currentUser = await userStorageServices.getCurrentUser();

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng đăng nhập để tạo bài viết'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (widget.isEditMode && widget.existingPost != null) {
        // Update existing post
        final updateRequest = PostUpdate(
          postId: widget.existingPost!.postId,
          title:
              _titleController.text.trim().isEmpty
                  ? null
                  : _titleController.text.trim(),
          content: _contentController.text.trim(),
          cafeId: widget.cafeId,
        );

        context.read<PostBloc>().add(UpdatePostEvent(updateRequest));
      } else {
        // Create new post
        final createRequest = PostCreate(
          userId: currentUser.id,
          cafeId: widget.cafeId,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );

        // Combine images and videos for media files
        final mediaFiles = <File>[];
        mediaFiles.addAll(_selectedImages);
        mediaFiles.addAll(_selectedVideos);

        context.read<PostBloc>().add(
          CreatePostEvent(
            request: createRequest,
            mediaFiles: mediaFiles.isNotEmpty ? mediaFiles : null,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
