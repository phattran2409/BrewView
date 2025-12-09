import 'package:briewview/features/search/view/widgets/search_cafe_card.dart';
import 'package:briewview/features/search/viewmodel/search_bloc.dart';
import 'package:briewview/features/search/viewmodel/search_event.dart';
import 'package:briewview/features/search/viewmodel/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBodyWidget extends StatefulWidget {
  final TextEditingController? searchController;
  final SearchBloc searchBloc;
  final ScrollController scrollController;
  const SearchBodyWidget({
    Key? key,
    this.searchController,
    required this.searchBloc,
    required this.scrollController,
  }) : super(key: key);

  @override
  _SearchBodyWidgetState createState() => _SearchBodyWidgetState();
}

class _SearchBodyWidgetState extends State<SearchBodyWidget> {
  late ScrollController _scrollController;
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = widget.searchBloc;
    _scrollController = widget.scrollController;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state is SearchInitial) {
      return _buildInitialState();
    } else if (state is SearchLoading) {
      return _buildLoadingState();
    } else if (state is SearchLoaded) {
      return _buildLoadedState(state);
    } else if (state is SearchLoadingMore) {
      return _buildLoadingMoreState(state);
    } else if (state is SearchEmpty) {
      return _buildEmptyState(state);
    } else if (state is SearchError) {
      return _buildErrorState(state);
    }
    return const SizedBox.shrink();
  }

  Widget _buildInitialState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.white.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            'Khám phá những quán cà phê tuyệt vời',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Tìm kiếm theo tên, địa điểm hoặc từ khóa để tìm trải nghiệm cà phê hoàn hảo của bạn',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Popular search suggestions
          _buildPopularSearches(),
        ],
      ),
    );
  }

  Widget _buildPopularSearches() {
    final suggestions = [
      'Cà phê rooftop',
      'Quận 1',
      'WiFi free',
      'View đẹp',
      'Chill',
      'Làm việc',
    ];

    return Column(
      children: [
        Text(
          'Tìm kiếm phổ biến',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              suggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () {
                    widget.searchController?.text = suggestion;
                    _searchBloc.add(SearchCafesEvent(query: suggestion));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Đang tìm kiếm quán cà phê...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(SearchLoaded state) {
    return Column(
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tìm thấy ${state.totalCount} kết quả',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (state.isFiltered)
                GestureDetector(
                  onTap: () {
                    _searchBloc.add(SearchCafesEvent(query: state.query));
                  },
                  child: Text(
                    'Xóa bộ lọc',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final cafe = state.results[index];
              return SearchCafeCard(
                cafe: cafe,
                onFavoriteToggle: () {
                  _searchBloc.add(ToggleFavorite(cafe.cafeId ?? ''));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingMoreState(SearchLoadingMore state) {
    return Column(
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '${state.currentResults.length} kết quả',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                state.currentResults.length + 1, // +1 for loading indicator
            itemBuilder: (context, index) {
              if (index == state.currentResults.length) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }

              final cafe = state.currentResults[index];
              return SearchCafeCard(
                cafe: cafe,
                onFavoriteToggle: () {
                  _searchBloc.add(ToggleFavorite(cafe.cafeId ?? ''));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(SearchEmpty state) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'Không tìm thấy kết quả',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Chúng tôi không thể tìm thấy quán cà phê nào phù hợp với "${state.query}"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.searchController?.clear();
              _searchBloc.add(ClearSearch());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Thử từ khóa khác'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(SearchError state) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchBloc.add(InitializeSearch());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
