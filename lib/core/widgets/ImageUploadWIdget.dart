import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(List<File>) onImagesChanged;
  final int maxImages;
  // final String contentButton;
  const ImageUploadWidget({
    super.key,
    required this.onImagesChanged,
    this.maxImages = 5,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Thêm hình ảnh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${_selectedImages.length}/${widget.maxImages}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Hình ảnh sẽ giúp đánh giá của bạn hữu ích hơn',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Image preview grid
          if (_selectedImages.isNotEmpty) ...[
            _buildImagePreview(),
            const SizedBox(height: 16),
          ],

          // ✅ Upload options
          Row(
            children: [
              Expanded(child: _buildCameraButton()),
              const SizedBox(width: 12),
              Expanded(child: _buildGalleryButton()),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Image preview grid
  Widget _buildImagePreview() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                // Image preview
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(_selectedImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Delete button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                
                // Image index
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ Camera button
  Widget _buildCameraButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.orange[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _pickImage(ImageSource.camera),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'Camera',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Gallery button
  Widget _buildGalleryButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[600]!, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _pickImage(ImageSource.gallery),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_library, color: Colors.orange[600], size: 18),
              const SizedBox(width: 6),
              Text(
                'Thư viện',
                style: TextStyle(
                  color: Colors.orange[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Pick image function
  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= widget.maxImages) {
      _showMaxImagesDialog();
      return;
    }

    // Check permissions
    bool hasPermission = await _checkPermissions(source);
    if (!hasPermission) return;

    try {
      if (source == ImageSource.gallery) {
        // Multiple selection for gallery
        final List<XFile> images = await _picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        
        if (images.isNotEmpty) {
          _addImages(images);
        }
      } else {
        // Single selection for camera
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        
        if (image != null) {
          _addImages([image]);
        }
      }
    } catch (e) {
      _showErrorDialog('Lỗi khi chọn ảnh: $e');
    }
  }

  // ✅ Add images to list
  void _addImages(List<XFile> images) {
    setState(() {
      for (final image in images) {
        if (_selectedImages.length < widget.maxImages) {
          _selectedImages.add(File(image.path));
        }
      }
    });
    widget.onImagesChanged(_selectedImages);
  }

  // ✅ Remove image
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged(_selectedImages);
  }

  // ✅ Check permissions
  Future<bool> _checkPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.request();
      return cameraStatus.isGranted;
    } else {
      final photosStatus = await Permission.photos.request();
      return photosStatus.isGranted;
    }
  }

  // ✅ Show dialogs
  void _showMaxImagesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giới hạn ảnh'),
        content: Text('Bạn chỉ có thể chọn tối đa ${widget.maxImages} ảnh.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}