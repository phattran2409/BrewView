import 'package:briewview/features/wishlist/model/wishlist_model.dart';

abstract class WishlistRepository {
  Future<WishlistResponse> getWishlist();
  Future<WishlistResponse> addToWishlist(String cafeId);
  // Future<WishlistResponse> removeFromWishlist(String cafeId);
}
