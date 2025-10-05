import 'package:flutter/material.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final String? currentSortBy;
  final String? currentSortDirection;
  final double? currentMinPrice;
  final double? currentMaxPrice;
  final Function(String?, String?, double?, double?) onApplyFilter;
  const SearchFilterBottomSheet({
    super.key,
    this.currentSortBy,
    this.currentSortDirection,
    this.currentMinPrice,
    this.currentMaxPrice,
    required this.onApplyFilter,
  });

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  String? _selectedSortBy;
  String? _selectedSortDirection;
  RangeValues _priceRange = const RangeValues(0, 500000);

  final List<Map<String, String>> _sortOptions = [
    {'value': 'name', 'label': 'Name'},
    {'value': 'rating', 'label': 'Rating'},
    {'value': 'priceMin', 'label': 'Price'},
    {'value': 'createdAt', 'label': 'Newest'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.currentSortBy ?? 'name';
    _selectedSortDirection = widget.currentSortDirection ?? 'Ascending';
    _priceRange = RangeValues(
      widget.currentMinPrice ?? 0,
      widget.currentMaxPrice ?? 500000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter & Sort',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSortBy = 'name';
                      _selectedSortDirection = 'Ascending';
                      _priceRange = const RangeValues(0, 500000);
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Color(0xFFD4A574), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sort by section
                const Text(
                  'Sort by',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _sortOptions.map((option) {
                        final isSelected = _selectedSortBy == option['value'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSortBy = option['value'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF763C0C)
                                      : Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: const Color(0xFFD4A574),
                                      )
                                      : null,
                            ),
                            child: Text(
                              option['label']!,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[300],
                                fontSize: 14,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Sort direction
                const Text(
                  'Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSortDirection = 'Ascending';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                _selectedSortDirection == 'Ascending'
                                    ? const Color(0xFF763C0C)
                                    : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                            border:
                                _selectedSortDirection == 'Ascending'
                                    ? Border.all(color: const Color(0xFFD4A574))
                                    : null,
                          ),
                          child: Text(
                            'Ascending',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  _selectedSortDirection == 'Ascending'
                                      ? Colors.white
                                      : Colors.grey[300],
                              fontWeight:
                                  _selectedSortDirection == 'Ascending'
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSortDirection = 'Descending';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                _selectedSortDirection == 'Descending'
                                    ? const Color(0xFF763C0C)
                                    : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                            border:
                                _selectedSortDirection == 'Descending'
                                    ? Border.all(color: const Color(0xFFD4A574))
                                    : null,
                          ),
                          child: Text(
                            'Descending',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  _selectedSortDirection == 'Descending'
                                      ? Colors.white
                                      : Colors.grey[300],
                              fontWeight:
                                  _selectedSortDirection == 'Descending'
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Price range
                const Text(
                  'Price Range',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 500000,
                  divisions: 50,
                  activeColor: const Color(0xFF763C0C),
                  inactiveColor: Colors.grey[700],
                  labels: RangeLabels(
                    '${(_priceRange.start / 1000).round()}k',
                    '${(_priceRange.end / 1000).round()}k',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_priceRange.start / 1000).round()}k VND',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      '${(_priceRange.end / 1000).round()}k VND',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilter(
                        _selectedSortBy,
                        _selectedSortDirection,
                        _priceRange.start,
                        _priceRange.end,
                      );
                      // Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF763C0C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
