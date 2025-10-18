import 'package:briewview/features/wishlist/model/wishlist_model.dart';
import 'package:briewview/features/wishlist/repository/wishlist_repository.dart';
import 'package:briewview/features/wishlist/services/wishlist_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistService wishlistService;

  WishlistRepositoryImpl(this.wishlistService);

  @override
  Future<WishlistResponse> getWishlist() async {
    try {
      return await wishlistService.getWishlist();
    } catch (e) {
      throw Exception('Failed to get wishlist: $e');
    }
  }

  @override
  Future<WishlistResponse> addToWishlist(String cafeId) async {
    try {
      return await wishlistService.addToWishlist(cafeId);
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  // @override
  // Future<WishlistResponse> removeFromWishlist(String cafeId) async {
  //   try {
  //     return await wishlistService.removeFromWishlist(cafeId);
  //   } catch (e) {
  //     throw Exception('Failed to remove from wishlist: $e');
  //   }
  // }
}
