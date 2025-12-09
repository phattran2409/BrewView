import 'dart:io';

import 'package:briewview/core/widgets/ImageUploadWIdget.dart';
import 'package:briewview/features/cafe/viewmodel/review_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/review_event.dart';
import 'package:briewview/features/cafe/viewmodel/review_state.dart';
import 'package:briewview/features/cafe/view/widgets/review_app_bar_widget.dart';
import 'package:briewview/features/cafe/view/widgets/review_list_widget.dart';
import 'package:briewview/features/cafe/view/widgets/write_review_widgets.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/app/di/locator.dart';

class ReviewListPage extends StatefulWidget {
  final String cafeId;
  const ReviewListPage({super.key, required this.cafeId});

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  final _bloc = getIt<ReviewBloc>();
  final _controller = ScrollController();
  bool _isLoadingMore = false;
  // List<Review> _reviews = [];
  @override
  void initState() {
    super.initState();
    _bloc.add(LoadReviews(cafeId: widget.cafeId, page: 1));
    _controller.addListener(() {
      final state = _bloc.state;
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          state is ReviewLoaded &&
          state.hasNextPage &&
          !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        _bloc.add(
          LoadMoreReviews(cafeId: widget.cafeId, page: state.currentPage + 1),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToWriteReview() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WriteReviewPage(cafeId: widget.cafeId)),
    );
    _bloc.add(RefreshReviews(cafeId: widget.cafeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              ReviewAppBarWidget(
                onBack: () => Navigator.of(context).pop(),
                onWriteReview: () => _navigateToWriteReview(),
              ),

              // Reviews Content
              Expanded(
                child: BlocBuilder<ReviewBloc, ReviewState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    // Reset loading more state when not loading more
                    if (state is! ReviewLoadMore && _isLoadingMore) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _isLoadingMore = false;
                        });
                      });
                    }
                    if (state is ReviewLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (state is ReviewError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (state is ReviewLoaded || state is ReviewLoadMore) {
                      final reviews =
                          state is ReviewLoaded
                              ? state.reviews
                              : (state as ReviewLoadMore).reviews;
                      final hasNextPage =
                          state is ReviewLoaded
                              ? state.hasNextPage
                              : (state as ReviewLoadMore).hasNextPage;
                      final isLoadingMore = state is ReviewLoadMore;

                      return ReviewListWidget(
                        reviews: reviews,
                        hasNextPage: hasNextPage,
                        isLoadingMore: isLoadingMore,
                        scrollController: _controller,
                        onRefresh:
                            () => _bloc.add(
                              RefreshReviews(cafeId: widget.cafeId),
                            ),
                        onWriteReview: () => _navigateToWriteReview(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingWriteReviewButton(
        onPressed: () => _navigateToWriteReview(),
      ),
    );
  }
}

class WriteReviewPage extends StatefulWidget {
  final String cafeId;
  const WriteReviewPage({super.key, required this.cafeId});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final _bloc = getIt<ReviewBloc>();
  int _rating = 5;
  final _textCtrl = TextEditingController();
  List<File> _selectImages = [];
  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              const WriteReviewAppBarWidget(),

              // Review Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Section Header
                        const ReviewSectionHeaderWidget(),

                        const SizedBox(height: 20),

                        // Star Rating Widget
                        StarRatingWidget(
                          initialRating: _rating,
                          onRatingChanged: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Rating Label and Emoji
                        RatingFeedbackWidget(rating: _rating),

                        const SizedBox(height: 32),

                        // Review Text Section
                        ReviewTextSectionWidget(controller: _textCtrl),

                        const SizedBox(height: 24),

                      
                        ImageUploadWidget(
                          maxImages: 3,
                          onImagesChanged: (images) {
                            _selectImages = images;
                          },
                          
                        ),

                        const SizedBox(height: 32),

                        // Submit Button
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocConsumer<ReviewBloc, ReviewState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is ReviewSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đánh giá đã được gửi thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
        if (state is ReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final loading = state is ReviewSubmitting;
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  loading
                      ? [Colors.grey[400]!, Colors.grey[500]!]
                      : [Colors.orange[400]!, Colors.orange[600]!],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap:
                  loading
                      ? null
                      : _handleSubmit,  
              child: Center(
                child:
                    loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Gửi đánh giá',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  void _handleSubmit() {
    final content  = _textCtrl.text.trim(); 
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung đánh giá'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    _bloc.add(
      SubmitReview(
        cafeId: widget.cafeId,
        rating: _rating,
        content: content,
        medias: _selectImages,
      ),
    );  
  }
}
