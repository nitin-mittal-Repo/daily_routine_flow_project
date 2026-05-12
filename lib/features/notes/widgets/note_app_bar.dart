// lib/features/notepad/presentation/widgets/note_app_bar.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';

class NoteAppBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  const NoteAppBar({super.key, required this.onSearchChanged});

  @override
  State<NoteAppBar> createState() => _NoteAppBarState();
}

class _NoteAppBarState extends State<NoteAppBar> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: _isSearching ? _buildSearchBar() : _buildNormalBar(),
    );
  }

  Widget _buildNormalBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
          ),
        ),

        // Title
        ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(
                colors: [AppColors.primaryMagenta, AppColors.primaryPurple],
              ).createShader(bounds),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📝', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text(
                'Quick Notes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),

        // Search button
        GestureDetector(
          onTap: () => setState(() => _isSearching = true),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                  },
                  child: Icon(Icons.close_rounded,
                      color: Colors.white.withOpacity(0.5)),
                )
                    : null,
              ),
              onChanged: widget.onSearchChanged,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() => _isSearching = false);
            _searchController.clear();
            widget.onSearchChanged('');
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryMagenta.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.close_rounded,
                color: AppColors.primaryMagenta.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }
}