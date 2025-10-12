import 'package:flutter/material.dart';

class SearchHeaderWidget extends StatefulWidget {
  final String title;
  final VoidCallback onFilterPressed; 
  final Function(String) onSearchChanged; 
  final TextEditingController? searchController;
  final bool hasActiveFilters;

  const SearchHeaderWidget({
    Key? key,
    required this.title,
    required this.onFilterPressed,
    required this.onSearchChanged,  
    this.searchController,
    this.hasActiveFilters = false,
  }) : super(key: key);

  @override
  _SearchHeaderWidgetState createState() => _SearchHeaderWidgetState();
}

class _SearchHeaderWidgetState extends State<SearchHeaderWidget> {
   void _onSearchChanged(String query) {
      widget.onSearchChanged(query);
    } 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 10), 
        _buildSearchBar(),  
      ],
    );
  }
  
   Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Navigator.of(context).pop(),
          //   child: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.black.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: const Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.white,
          //       size: 20,
          //     ),
          //   ),
          // ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.title,  
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(Icons.search, color: Colors.white.withOpacity(0.8), size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: widget.searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm quán cà phê, địa điểm...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            IconButton(
              onPressed: widget.onFilterPressed,
              icon: Icon(
                Icons.tune,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

}
