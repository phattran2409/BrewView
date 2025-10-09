import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoUploadWidget extends StatefulWidget {
  final Function(List<File>) onVideosChanged;
  final int maxVideos;
  final bool isPremium;
  final int maxVideoDurationSeconds; // Maximum video duration in seconds

  const VideoUploadWidget({
    super.key,
    required this.onVideosChanged,
    this.maxVideos = 1,
    this.maxVideoDurationSeconds = 60, // Default 60 seconds
    this.isPremium = false,
  });

  @override
  State<VideoUploadWidget> createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends State<VideoUploadWidget> {
  final List<File> _selectedVideos = [];
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _previewController;
  int _previewIndex = -1;

  int get maxVideos {
    return widget.isPremium ? 2 : 1; // Premium: 2 videos, Regular: 1 video
  }

  int get maxDurationSeconds {
    return widget.isPremium
        ? widget.maxVideoDurationSeconds * 2
        : widget.maxVideoDurationSeconds;
  }

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

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
        border: null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.videocam, color: Colors.purple[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Thêm video',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${_selectedVideos.length}/${maxVideos}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Video sẽ giúp hiển thị không gian cafe một cách sinh động hơn',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tối đa ${maxDurationSeconds}s mỗi video',
            style: TextStyle(
              fontSize: 11,
              color: Colors.orange[600],
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Video preview section
          if (_selectedVideos.isNotEmpty) ...[
            _buildVideoPreview(),
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

  // ✅ Video preview section
  Widget _buildVideoPreview() {
    return Container(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedVideos.length,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                // Video preview
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildVideoThumbnail(index),
                  ),
                ),

                // Play/Pause button overlay
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _toggleVideoPreview(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _previewIndex == index &&
                                  _previewController?.value.isPlaying == true
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                // Delete button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeVideo(index),
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

                // Video index and duration
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
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

  // ✅ Build video thumbnail or preview
  Widget _buildVideoThumbnail(int index) {
    if (_previewIndex == index && _previewController != null) {
      return AspectRatio(
        aspectRatio: _previewController!.value.aspectRatio,
        child: VideoPlayer(_previewController!),
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.videocam, color: Colors.grey, size: 40),
      );
    }
  }

  // ✅ Camera button
  Widget _buildCameraButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.purple[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _pickVideo(ImageSource.camera),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam, color: Colors.white, size: 18),
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
        border: Border.all(color: Colors.purple[600]!, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _pickVideo(ImageSource.gallery),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, color: Colors.purple[600], size: 18),
              const SizedBox(width: 6),
              Text(
                'Thư viện',
                style: TextStyle(
                  color: Colors.purple[600],
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

  // ✅ Pick video function
  Future<void> _pickVideo(ImageSource source) async {
    if (_selectedVideos.length >= maxVideos) {
      _showMaxVideosDialog();
      return;
    }

    // Check permissions
    bool hasPermission = await _checkPermissions(source);
    if (!hasPermission) return;

    try {
      final XFile? video = await _picker.pickVideo(
        source: source,
        maxDuration: Duration(seconds: maxDurationSeconds),
      );

      if (video != null) {
        // Check video duration
        final file = File(video.path);
        final duration = await _getVideoDuration(file);

        if (duration.inSeconds > maxDurationSeconds) {
          _showVideoTooLongDialog();
          return;
        }

        _addVideo(file);
      }
    } catch (e) {
      _showErrorDialog('Lỗi khi chọn video: $e');
    }
  }

  // ✅ Add video to list
  void _addVideo(File video) {
    setState(() {
      _selectedVideos.add(video);
    });
    widget.onVideosChanged(_selectedVideos);
  }

  // ✅ Remove video
  void _removeVideo(int index) {
    setState(() {
      if (_previewIndex == index) {
        _previewController?.dispose();
        _previewController = null;
        _previewIndex = -1;
      }
      _selectedVideos.removeAt(index);
    });
    widget.onVideosChanged(_selectedVideos);
  }

  // ✅ Toggle video preview
  void _toggleVideoPreview(int index) async {
    if (_previewIndex == index && _previewController != null) {
      // Pause current video
      if (_previewController!.value.isPlaying) {
        _previewController!.pause();
      } else {
        _previewController!.play();
      }
      setState(() {});
    } else {
      // Load new video
      _previewController?.dispose();
      _previewController = VideoPlayerController.file(_selectedVideos[index]);

      try {
        await _previewController!.initialize();
        _previewIndex = index;
        _previewController!.play();
        setState(() {});

        // Auto pause after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (_previewController != null &&
              _previewController!.value.isPlaying) {
            _previewController!.pause();
            setState(() {});
          }
        });
      } catch (e) {
        _showErrorDialog('Không thể phát video: $e');
        _previewController?.dispose();
        _previewController = null;
        _previewIndex = -1;
      }
    }
  }

  // ✅ Get video duration
  Future<Duration> _getVideoDuration(File videoFile) async {
    try {
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();
      final duration = controller.value.duration;
      controller.dispose();
      return duration;
    } catch (e) {
      return const Duration(seconds: 0);
    }
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
  void _showMaxVideosDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Giới hạn video'),
            content: Text('Bạn chỉ có thể chọn tối đa ${maxVideos} video.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showVideoTooLongDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Video quá dài'),
            content: Text(
              'Video không được vượt quá ${maxDurationSeconds} giây.',
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
