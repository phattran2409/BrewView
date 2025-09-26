
import 'package:briewview/features/cafe/model/cafeMode.dart';

class CafeMedias {
  final String? mediaId;
  final String? url;
  final String? caption;

  const CafeMedias({
    this.mediaId,
    this.url,
    this.caption,
  });

  factory CafeMedias.fromJson(Map<String, dynamic> json) {
    return CafeMedias(
      mediaId: json['mediaId'] as String?,
      url: json['url'] as String?,
      caption: json['caption'] as String?,        
    );  
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'url': url,
      'caption': caption,
    };
  }

  @override
  List<Object?> get props => [mediaId, url, caption];
}