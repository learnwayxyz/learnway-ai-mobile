import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/bookmarks/models/bookmark_model.dart';

class BookmarkCard extends StatelessWidget {
  final BookmarkModel bookmark;
  final VoidCallback onTap;

  const BookmarkCard({super.key, required this.bookmark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF57C43), // Orange gradient start
                Color(0xFFFF5722), // Orange gradient end
              ],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              // Background decorative circles
              _buildBackgroundCircles(),

              // Content
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title and Author with Arrow Button
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookmark.title,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFDFDFD),
                                  height: 1.33, // 24/18
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bookmark.author,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFE9EAEB),
                                  height: 1.0, // 12/12
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow button positioned correctly
                        Container(
                          width: 41,
                          height: 39,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/carbon_arrow-right.svg',
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Question and Description section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Question',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFDFDFD),
                            height: 1.125, // 18/16
                          ),
                        ),
                        const SizedBox(height: 11),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFDFDFD),
                              height: 1.0, // 14/14
                              letterSpacing: 0.2,
                            ),
                            children: [
                              const TextSpan(
                                text: '1. ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: bookmark.description),
                            ],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        // Small circles (50px) - positioned as per Figma
        Positioned(
          left: 32, // 8px from left edge + 25px padding = 33px, using 32px
          top: 21,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 299, // Right side circle
          top: 21,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 204, // Bottom right circle
          top: 113,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 0, // Bottom left circle
          top: 145,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Medium circles (80px) - positioned as per Figma
        Positioned(
          left: 174, // Center circle
          top: 58,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 32, // Top left circle
          top: -22,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
