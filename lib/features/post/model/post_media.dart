import 'package:briewview/features/post/model/post_model.dart';

class PostMedia {
  final String mediaId;
  final String mediaUrl;
  final String mediaType;
  final int order;

  PostMedia({
    required this.mediaId,
    required this.mediaUrl,
    required this.mediaType,
    required this.order,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(
      mediaId: json['mediaId']?.toString() ?? '',
      mediaUrl: json['mediaUrl']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'order': order,
    };
  }
}
