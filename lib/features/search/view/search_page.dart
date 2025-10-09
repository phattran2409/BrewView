import 'dart:math';

import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/search/view/widgets/search_cafe_card.dart';
import 'package:briewview/features/search/view/widgets/search_filter_bottom_sheet.dart';
import 'package:briewview/features/search/view/widgets/search_header_widget.dart';
import 'package:briewview/features/search/view/widgets/search_body_widget.dart';
import 'package:briewview/features/search/viewmodel/search_bloc.dart';
import 'package:briewview/features/search/viewmodel/search_event.dart';
import 'package:briewview/features/search/viewmodel/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBloc _searchBloc;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  String? currentSortBy;
  String? currentSortDirection;
  double? currentMinPrice;
  double? currentMaxPrice;
  @override
  void initState() {
    super.initState();
    _searchBloc = getIt<SearchBloc>();
    _searchBloc.add(InitializeSearch());

    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _searchBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final currentState = _searchBloc.state;
      if (currentState is SearchLoaded &&
          currentState.hasNextPage &&
          _searchBloc.state is! SearchLoadingMore) {
        _searchBloc.add(
          LoadMoreSearchResults(
            query: currentState.query,
            pageNumber: currentState.currentPage + 1,
          ),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _searchBloc.add(SearchCafesEvent(query: query.trim()));
      } else {
        _searchBloc.add(ClearSearch());
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => SearchFilterBottomSheet(

            onApplyFilter: (sortBy, sortDirection, minPrice, maxPrice) {
              _searchBloc.add(
                FilterCafes(
                  sortBy: sortBy,
                  sortDirection: sortDirection,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                ),
              );

              print("Applying filters: $sortBy, $sortDirection, $minPrice, $maxPrice");
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColor.primaryGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SearchHeaderWidget(
                  title: 'Search Coffee Shops',
                  // resultCount: 0, // Placeholder, update as needed
                  onFilterPressed: _showFilterBottomSheet,
                  onSearchChanged: _onSearchChanged,
                ),
                SearchBodyWidget(
                  searchController: _searchController,
                  searchBloc: _searchBloc,
                  scrollController: _scrollController,
                ),
                CustomNavigationBar()
              ],
            ),
          ),
        ),
      ),
    );
  }

 
}
