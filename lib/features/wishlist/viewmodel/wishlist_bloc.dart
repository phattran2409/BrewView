import 'package:briewview/features/wishlist/repository/wishlist_repository.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_event.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistBloc(this.wishlistRepository) : super(const WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    // on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<RefreshWishlist>(_onRefreshWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(const WishlistLoading());
    try {
      final response = await wishlistRepository.getWishlist();
      if (response.isSuccess && response.data != null) {
        emit(WishlistLoaded(response.data!));
      } else {
        emit(const WishlistError('Failed to load wishlist'));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final response = await wishlistRepository.addToWishlist(event.cafeId);
      if (response.isSuccess) {
        emit(const WishlistOperationSuccess('Added to wishlist successfully'));
        // Reload wishlist to get updated data
        add(const LoadWishlist());
      } else {
        emit(const WishlistError('Failed to add to wishlist'));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  // Future<void> _onRemoveFromWishlist(
  // //   RemoveFromWishlist event,
  // //   Emitter<WishlistState> emit,
  // // ) async {
  // //   try {
  // //     final response = await wishlistRepository.removeFromWishlist(event.cafeId);
  // //     if (response.isSuccess) {
  // //       emit(const WishlistOperationSuccess('Removed from wishlist successfully'));
  // //       // Reload wishlist to get updated data
  // //       add(const LoadWishlist());
  // //     } else {
  // //       emit(const WishlistError('Failed to remove from wishlist'));
  // //     }
  // //   } catch (e) {
  // //     emit(WishlistError(e.toString()));
  // //   }
  // }

  Future<void> _onRefreshWishlist(
    RefreshWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    add(const LoadWishlist());
  }
}
