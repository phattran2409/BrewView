import 'package:briewview/features/survey/model/feature_tag_model.dart';
import 'package:flutter/material.dart';

class FeatureTagSelector extends StatelessWidget {
  final List<FeatureTagModel> featureTags;
  final List<int> selectedTagIds;
  final Function(List<int>) onSelectionChanged;
  final String? title;
  final int? maxSelection;

  const FeatureTagSelector({
    super.key,
    required this.featureTags,
    required this.selectedTagIds,
    required this.onSelectionChanged,
    this.title,
    this.maxSelection,
  });

@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (if provided)
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Feature tags chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: featureTags.map((tag) {
            final isSelected = selectedTagIds.contains(tag.tagId);
            return _buildFeatureChip(tag, isSelected);
          }).toList(),
        ),
        
        // Selection info
        if (maxSelection != null && selectedTagIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Đã chọn: ${selectedTagIds.length}${maxSelection != null ? '/$maxSelection' : ''} tính năng',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildFeatureChip(FeatureTagModel tag, bool isSelected) {
    final canSelect = maxSelection == null || 
                     selectedTagIds.length < maxSelection! || 
                     isSelected;

    return FilterChip(
      label: Text(
        tag.name,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF8B4513),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: canSelect ? (selected) => _toggleSelection(tag.tagId, selected) : null,
      selectedColor: const Color(0xFF8B4513),
      backgroundColor: const Color(0xFFF5F1EB),
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? const Color(0xFF8B4513) : Colors.grey.shade300,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  void _toggleSelection(int tagId, bool selected) {
    final newSelection = List<int>.from(selectedTagIds);
    
    if (selected) {
      // Check max selection limit
      if (maxSelection != null && newSelection.length >= maxSelection!) {
        return; // Don't add if limit reached
      }
      newSelection.add(tagId);
    } else {
      newSelection.remove(tagId);
    }

    onSelectionChanged(newSelection);
  }
}