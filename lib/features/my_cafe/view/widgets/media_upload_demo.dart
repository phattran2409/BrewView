import 'dart:io';
import 'package:flutter/material.dart';
import 'package:briewview/core/widgets/ImageUploadWIdget.dart';
import 'package:briewview/core/widgets/VideoUploadWidget.dart';

/// Demo widget showing how to use ImageUploadWidget and VideoUploadWidget
/// This can be used as a reference for implementing media upload in other forms
class MediaUploadDemo extends StatefulWidget {
  const MediaUploadDemo({super.key});

  @override
  State<MediaUploadDemo> createState() => _MediaUploadDemoState();
}

class _MediaUploadDemoState extends State<MediaUploadDemo> {
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  bool _isPremium = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tải lên Media Demo'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium toggle
            Card(
              child: SwitchListTile(
                title: const Text('Chế độ Premium'),
                subtitle: Text(_isPremium ? 'Tính năng Premium đã được kích hoạt' : 'Chỉ có tính năng cơ bản'),
                value: _isPremium,
                onChanged: (value) {
                  setState(() {
                    _isPremium = value;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Image Upload Widget
            ImageUploadWidget(
              onImagesChanged: (images) {
                setState(() {
                  _selectedImages = images;
                });
              },
              maxImages: _isPremium ? 10 : 3,
              isPremium: _isPremium,
            ),
            
            const SizedBox(height: 20),
            
            // Video Upload Widget
            VideoUploadWidget(
              onVideosChanged: (videos) {
                setState(() {
                  _selectedVideos = videos;
                });
              },
              maxVideos: _isPremium ? 2 : 1,
              maxVideoDurationSeconds: _isPremium ? 120 : 60,
              isPremium: _isPremium,
            ),
            
            const SizedBox(height: 30),
            
            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tóm tắt Tải lên',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Hình ảnh: ${_selectedImages.length} tệp'),
                    Text('Video: ${_selectedVideos.length} tệp'),
                    const SizedBox(height: 12),
                    Text(
                      'Tổng số tệp Media: ${_selectedImages.length + _selectedVideos.length}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Submit Button (Demo)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedImages.isEmpty && _selectedVideos.isEmpty
                    ? null
                    : _submitMedia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Gửi Media (Demo)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitMedia() {
    final allMediaFiles = [..._selectedImages, ..._selectedVideos];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Media Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hình ảnh: ${_selectedImages.length}'),
            Text('Video: ${_selectedVideos.length}'),
            Text('Tổng: ${allMediaFiles.length} tệp'),
            const SizedBox(height: 8),
            const Text('This is just a demo. In real implementation, these files would be uploaded to your server.'),
          ],
        ),
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
