import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {
  const LoadWishlist();
}

class AddToWishlist extends WishlistEvent {
  final String cafeId;

  const AddToWishlist(this.cafeId);

  @override
  List<Object?> get props => [cafeId];
}

class RemoveFromWishlist extends WishlistEvent {
  final String cafeId;

  const RemoveFromWishlist(this.cafeId);

  @override
  List<Object?> get props => [cafeId];
}

class RefreshWishlist extends WishlistEvent {
  const RefreshWishlist();
}
