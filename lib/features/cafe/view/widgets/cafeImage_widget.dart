import 'package:briewview/core/utils/ShowImage.dart';
import 'package:briewview/core/utils/videoController.dart';
import 'package:briewview/features/cafe/model/cafeMedia.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:flutter/material.dart';

class CafeImageWidget extends StatefulWidget {
  final CafeModel cafeData;

  const CafeImageWidget({Key? key, required this.cafeData}) : super(key: key);

  @override
  _CafeImageWidgetState createState() => _CafeImageWidgetState();
}

class _CafeImageWidgetState extends State<CafeImageWidget> {
  late final List<CafeMedias> cafeMedias;
  int _currentImageIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    cafeMedias = widget.cafeData.cafeMedias ?? [];
    _pageController = PageController(initialPage: 0); 
 
  }

  @override
  void dispose() {
    _pageController.dispose(); // ✅ Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cafeMedias.isEmpty) {
      return ShowImage.get(
        widget.cafeData.imageUrl ?? 'assets/images/coffe_shop_3.jpg',
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ PageView với controller
        PageView.builder(
          controller: _pageController,
          itemCount: cafeMedias.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final media = cafeMedias[index].url;
            print('Loading media: $media');
            return _buildImageItem(media);
          },
        ),

        // ✅ Gradient overlay - KHÔNG chặn gesture
        IgnorePointer( // ✅ Cho phép swipe qua gradient
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // ✅ Dots indicator
        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: IgnorePointer( // ✅ Không chặn swipe
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cafeMedias.length,
                (index) => AnimatedContainer( // ✅ Smooth animation
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: CircleAvatar(
                    radius: index == _currentImageIndex ? 5 : 4,
                    backgroundColor: index == _currentImageIndex
                        ? Colors.white
                        : Colors.white54,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ✅ Add image counter (optional)
        Positioned(
          bottom: 50,
          right: 185,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${cafeMedias.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleImageView(String? imageUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildImageItem(imageUrl),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.9),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(String? mediaUrl) {
    if (mediaUrl == null || mediaUrl.isEmpty) {
      return _buildPlaceholderImage();
    }
    
    final isVideo = mediaUrl.toLowerCase().contains('.mp4') ||
                    mediaUrl.toLowerCase().contains('.mov') ||
                    mediaUrl.toLowerCase().contains('video');

    if (isVideo) {
      return VideoController(videoUrl: mediaUrl);
    }

    return _buildNetworkImage(mediaUrl);
  }

  Widget _buildNetworkImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading image...',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('❌ Error loading image: $imageUrl, Error: $error');
        return _buildPlaceholderImage();
      },
    );
  }


  Widget _buildPlaceholderImage() {
  return Container(
    color: Colors.grey[800],
    child: const Icon(
      Icons.local_cafe,
      color: Colors.white,
      size: 100,
    ),
  );
}


}
