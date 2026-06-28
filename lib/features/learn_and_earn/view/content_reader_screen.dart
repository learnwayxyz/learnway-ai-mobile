import 'dart:convert';
import 'dart:developer';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_slide.dart';
import 'package:learnwayv2/services/analytics/analytics_service.dart';
import 'package:learnwayv2/services/analytics/timetracking_service.dart';
import 'package:learnwayv2/shared/utilities/banner_ad_manager.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/content_progress_tracker.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/features/learn_and_earn/view/widget/ai_tutor_bottom_sheet.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

@RoutePage()
class ContentReaderScreen extends StatefulWidget {
  const ContentReaderScreen({
    super.key,
    required this.id,
    required this.title,
    required this.slidesResponse,
    required this.lessonImage,
  });
  final String id;
  final String title;
  final String lessonImage;
  final LessonSlidesResponse slidesResponse;
  @override
  State<ContentReaderScreen> createState() => _ContentReaderScreenState();
}

class _ContentReaderScreenState extends State<ContentReaderScreen>
    with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentPageIndex = 0;
  late List<SlideContent> sortedContentPages;

  final TimeTrackingService _timeTracker = TimeTrackingService();
  static const _adKey = 'contentReaderScreen';
  void _onAdReady() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    sortedContentPages = List.from(widget.slidesResponse.data.content)
      ..sort((a, b) => a.order.compareTo(b.order))
      ..removeWhere((slide) => slide.content.trim().isEmpty);

    WidgetsBinding.instance.addObserver(this);
    _timeTracker.startLesson(widget.id);
    if (sortedContentPages.isNotEmpty) {
      _timeTracker.startSlideShow(sortedContentPages[0].id);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timeTracker.endSlideShow(sortedContentPages[_currentPageIndex].id);
    } else if (state == AppLifecycleState.resumed) {
      _timeTracker.startSlideShow(sortedContentPages[_currentPageIndex].id);
    }
  }

  void _onPageChanged(int index) {
    _timeTracker.endSlideShow(sortedContentPages[_currentPageIndex].id);
    _timeTracker.startSlideShow(sortedContentPages[index].id);

    setState(() {
      _currentPageIndex = index;
    });
  }

  Future<void> _finishLesson() async {
    _timeTracker.endSlideShow(sortedContentPages[_currentPageIndex].id);

    final totalTime = _timeTracker.totalLessonTime();
    final slideTimes = _timeTracker.getAllSlideTimes();
    log('Lesson ${widget.id} completed in ${totalTime.inSeconds} seconds');
    for (var entry in slideTimes.entries) {
      await locator<AnalyticsService>().logEvent(
        'slide_viewed',
        parameters: {
          'lesson_id': widget.id,
          'slide_id': entry.key,
          'time_spent_seconds': entry.value.inSeconds,
        },
      );
    }
    await locator<AnalyticsService>().logLessonCompleted(
      widget.id,
      totalTime.inSeconds,
    );

    if (mounted) {
      context.router.push(QuizLoaderRoute(title: widget.title, id: widget.id));
    }
  }

  void fetchSlides() {
    context.read<LearnAndEarnBloc>().add(FetchLessonSlides(id: widget.id));
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (sortedContentPages.isNotEmpty &&
        _currentPageIndex < sortedContentPages.length) {
      _timeTracker.endSlideShow(sortedContentPages[_currentPageIndex].id);
    }

    _pageController.dispose();
    BannerAdManager.instance.addListener(_adKey, _onAdReady);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          _timeTracker.endSlideShow(sortedContentPages[_currentPageIndex].id);

          final totalTime = _timeTracker.totalLessonTime();
          final slideTimes = _timeTracker.getAllSlideTimes();

          await locator<AnalyticsService>().logEvent(
            'lesson_exited',
            parameters: {
              'lesson_id': widget.id,
              'time_spent_seconds': totalTime.inSeconds,
              'slides_viewed': _currentPageIndex + 1,
              'total_slides': sortedContentPages.length,
              'slide_times_json': jsonEncode(
                slideTimes.map((k, v) => MapEntry(k, v.inSeconds)),
              ),
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          barHeight: 0,
          title: widget.title,
          onBackPressed: () {
            context.router.popUntil(
              (route) => route.settings.name == LessonRoute.name,
            );
          },
        ),
        body: Column(
          children: [
            if (sortedContentPages.length > 1) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: ContentProgressTracker(
                  totalItems: sortedContentPages.length,
                  currentItem: _currentPageIndex,
                  onItemTap: _goToPage,
                ),
              ),
            ],
            Container(
              height: FigmaConverter.height(context, 187),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildMediaWidget(),
              ),
            ),
            VSpace(5),
            const BannerAdSlot(slotKey: _adKey),
            VSpace(15),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildTextContent(),
              ),
            ),
            const VSpace(20),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBackButton(),
                    _buildAskAiButton(),
                    _buildNextButton(),
                  ],
                ),
              ),
            ),
            const VSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    final isEnabled = _currentPageIndex > 0;

    return ButtonFactory.blackButton(
      padding: EdgeInsets.fromLTRB(16, 16, 25, 16),
      trailingIcon: Icon(
        Icons.arrow_back_sharp,
        size: 24,
        color: _getButtonIconColor(isEnabled),
      ),
      onPressed: isEnabled
          ? () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          : () {},
      text: AppLocalizations.of(context)!.back,
      textStyle: AppTextStyles.baseBold(
        context,
        color: _getButtonTextColor(isEnabled),
      ),
      backgroundColor: _getButtonBackgroundColor(isEnabled, false),
    );
  }

  Widget _buildAskAiButton() {
    return ButtonFactory.blackButton(
      text: 'Ask',
      isFullWidth: false,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      mainAxisAlignment: MainAxisAlignment.center,
      trailingIcon: SvgPicture.asset(
        Assets.icons.askAiIcon2,
        width: 30,
        height: 30,
      ),
      backgroundColor: AppColors.primary25.withValues(alpha: 0.2),
      textStyle: AppTextStyles.baseBold(context, color: AppColors.primary25),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => BlocProvider.value(
            value: context.read<LearnAndEarnBloc>(),
            child: AiTutorBottomSheet(lessonId: widget.id),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentPageIndex == sortedContentPages.length - 1;

    return ButtonFactory.blackButton(
      padding: EdgeInsets.fromLTRB(25, 16, 16, 16),
      leadingIcon: Icon(
        Icons.arrow_forward_sharp,
        size: 24,
        color: isLastPage ? Colors.white : (Colors.white),
      ),
      onPressed: !isLastPage
          ? () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          : () {
              _finishLesson();
            },
      text: isLastPage
          ? AppLocalizations.of(context)!.startQuiz
          : AppLocalizations.of(context)!.next,
      textStyle: AppTextStyles.baseBold(
        context,
        color: isLastPage ? Colors.white : (Colors.white),
      ),
      backgroundColor: isLastPage
          ? AppColors.successColor
          : (AppColors.gray900),
    );
  }

  Color _getButtonBackgroundColor(bool isEnabled, bool isLastPage) {
    if (isLastPage) return AppColors.successColor;

    if (!isEnabled) {
      return AppColors.gray400;
    }

    return AppColors.gray900;
  }

  Color _getButtonTextColor(bool isEnabled) {
    if (!isEnabled) {
      return AppColors.white;
    }

    return Colors.white;
  }

  Color _getButtonIconColor(bool isEnabled) {
    if (!isEnabled) {
      return AppColors.white;
    }

    return Colors.white;
  }

  Widget _buildMediaWidget() {
    if (sortedContentPages.isEmpty) {
      return _buildDefaultImage();
    }

    if (widget.lessonImage.isNotEmpty) {
      return Image.network(
        widget.lessonImage,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 182,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppColors.gray900,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.loadingImage,
                  style: AppTextStyles.base(context, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultImage();
        },
      );
    } else {
      return _buildDefaultImage();
    }
  }

  Widget _buildDefaultImage() {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 48, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.contentImage,
            style: AppTextStyles.base(context, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    if (sortedContentPages.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noContentAvailable,
          style: AppTextStyles.base(
            context,
            color: Colors.white,
          ).copyWith(fontFamily: 'Inter'),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: sortedContentPages.length,
            itemBuilder: (context, index) {
              return _SlideContentPage(slide: sortedContentPages[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _SlideContentPage extends StatefulWidget {
  const _SlideContentPage({required this.slide});
  final SlideContent slide;

  @override
  State<_SlideContentPage> createState() => _SlideContentPageState();
}

class _SlideContentPageState extends State<_SlideContentPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfAtBottom());
  }

  void _onScroll() => _checkIfAtBottom();

  void _checkIfAtBottom() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final atBottom =
        maxScroll <= 0 || _scrollController.offset >= maxScroll - 1;
    if (atBottom != _isAtBottom) setState(() => _isAtBottom = atBottom);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.slide.content,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
                if (widget.slide.note != null &&
                    widget.slide.note!.isNotEmpty) ...[
                  const VSpace(16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.slide.note!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!_isAtBottom)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
