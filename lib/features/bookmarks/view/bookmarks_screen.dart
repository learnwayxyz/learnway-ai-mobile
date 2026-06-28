import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/bookmarks/cubit/bookmark_cubit.dart';
import 'package:learnwayv2/features/bookmarks/cubit/bookmark_state.dart';
import 'package:learnwayv2/features/bookmarks/models/bookmark_model.dart';
import 'package:learnwayv2/features/bookmarks/view/widgets/bookmark_card.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bookmarks are already initialized in the cubit constructor
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                if (!state.hasBookmarks) {
                  return _buildEmptyState();
                }

                return _buildBookmarksList(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      // toolbarHeight: 99, // Exact Figma height
      title: Row(
        children: [
          // Back button - exact Figma positioning
          GestureDetector(
            onTap: () => context.router.maybePop(),
            child: Container(
              width: 39, // Exact Figma width
              height: 39, // Exact Figma height
              decoration: BoxDecoration(
                color: Colors.white, // Exact Figma background color
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFD8DADC)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black, // Exact Figma icon color
              ),
            ),
          ),
          const SizedBox(width: 20), // Exact Figma spacing
          // Title - exact Figma positioning and styling
          Expanded(
            child: Center(
              child: Text(
                'Bookmarks',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16, // Exact Figma font size
                  fontWeight: FontWeight.w600, // SemiBold
                  color: Color(0xFF181D27), // Exact Figma color
                  height: 1.125, // 18px / 16px
                  letterSpacing: 0.2, // Exact Figma letter spacing
                ),
              ),
            ),
          ),
          const SizedBox(width: 39), // Balance for centering
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE5E7EB), // Exact Figma border color
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: SizedBox(
        height: 55,
        child: TextFormField(
          controller: _searchController,
          onChanged: (query) {
            context.read<BookmarkCubit>().searchBookmarks(query);
          },
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF535861),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0.20,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: SvgPicture.asset(
                'assets/icons/search-icon.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF535861),
                  BlendMode.srcIn,
                ),
              ),
            ),
            fillColor: const Color(0xFFEAEBF5),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.icons.bookMarkIcon,
            width: 64,
            height: 64,
            color: AppColors.gray400,
          ),
          const VSpace(16),
          Text(
            AppLocalizations.of(context)!.noBookmarksYet,
            style: AppTextStyles.lgSemiBold(context),
          ),
          const VSpace(8),
          Text(
            'Bookmark lessons and questions to find them here later',
            style: AppTextStyles.smRegular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList(BookmarkState state) {
    final bookmarks =
        state.isSearching ? state.filteredBookmarks : state.bookmarks;

    if (bookmarks.isEmpty && state.isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.gray400),
            const VSpace(16),
            Text(
              AppLocalizations.of(context)!.noResultsFound,
              style: AppTextStyles.lgSemiBold(context),
            ),
            const VSpace(8),
            Text(
              'Try searching with different keywords',
              style: AppTextStyles.smRegular(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BookmarkCard(
            bookmark: bookmark,
            onTap: () {
              // Navigate to lesson or course
              _navigateToContent(bookmark);
            },
          ),
        );
      },
    );
  }

  void _navigateToContent(BookmarkModel bookmark) {
    // TODO: Implement navigation to lesson or course
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalizations.of(context)!.opening} ${bookmark.title}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
