import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final bool mute;
  final bool showControls;
  final Widget? placeholder;
  final Color progressPlayedColor;
  final Color progressHandleColor;
  final Color progressBackgroundColor;
  final Color progressBufferedColor;
  final void Function(VideoPlayerController controller)? onInitialized;
  final void Function(Object error)? onError;

  const VideoController({
    Key? key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
    this.mute = false,
    this.showControls = true,
    this.placeholder,
    this.progressPlayedColor = Colors.amber,
    this.progressHandleColor = Colors.amberAccent,
    this.progressBackgroundColor = Colors.grey,
    this.progressBufferedColor = Colors.lightGreen,
    this.onInitialized,
    this.onError,
  }) : super(key: key);

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Object? _lastError;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant VideoController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeControllers();
      _init();
    }
  }

  Future<void> _init() async {
    if (!_isValidNetworkVideoUrl(widget.videoUrl)) {
      setState(() {
        _lastError = ArgumentError('Invalid video url: ${widget.videoUrl}');
      });
      widget.onError?.call(_lastError!);
      return;
    }

    final url = widget.videoUrl.trim();
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions:  VideoPlayerOptions(mixWithOthers: true),
    );

    _videoController = controller;
    try {
      await controller.initialize();
      await controller.setLooping(widget.looping);
      await controller.setVolume(widget.mute ? 0.0 : 1.0);

      final chewie = ChewieController(
        videoPlayerController: controller,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        allowFullScreen: true,
        allowMuting: true,
        showOptions: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: widget.progressPlayedColor,
          handleColor: widget.progressHandleColor,
          backgroundColor: widget.progressBackgroundColor,
          bufferedColor: widget.progressBufferedColor,
        ),
        placeholder: widget.placeholder ?? _defaultPlaceholder(),
        errorBuilder: (context, errorMessage) {
          return _errorView(errorMessage);
        },
      );

      _chewieController = chewie;
      if (mounted) setState(() {});
      widget.onInitialized?.call(controller);
    } catch (err) {
      // Known issue: Some Android devices can't decode certain AAC profiles (e.g. mp4a.40.29)
      // We surface the error and let caller decide (e.g. use another source/transcode).
      _lastError = err;
      if (mounted) setState(() {});
      widget.onError?.call(err);
      debugPrint('❌ Error initializing video controller for $url: $err');
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
  }

  bool _isValidNetworkVideoUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final lower = url.toLowerCase();
    return (uri.isScheme('http') || uri.isScheme('https')) &&
        (lower.endsWith('.mp4') ||
            lower.endsWith('.mov') ||
            lower.contains('video'));
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _errorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 60),
          const SizedBox(height: 10),
          const Text(
            'Video Error',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = _chewieController;
    final videoController = _videoController;

    if (_lastError != null) {
      final message =
          videoController?.value.errorDescription ?? _lastError.toString();
      return Container(color: Colors.black, child: _errorView(message));
    }

    if (chewieController == null ||
        videoController == null ||
        !videoController.value.isInitialized) {
      return _defaultPlaceholder();
    }

    final aspectRatio =
        videoController.value.aspectRatio == 0
            ? 16 / 9
            : videoController.value.aspectRatio;

    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Chewie(controller: chewieController),
        ),
      ),
    );
  }
}
