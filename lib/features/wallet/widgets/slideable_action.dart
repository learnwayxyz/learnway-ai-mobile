import 'dart:async';
import 'dart:developer';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/kyc_service/verification_manager.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class SlideableActionCards extends StatefulWidget {
  const SlideableActionCards({super.key, this.onLoadingStateChanged});

  final ValueChanged<bool>? onLoadingStateChanged;

  @override
  State<SlideableActionCards> createState() => _SlideableActionCardsState();
}

class _SlideableActionCardsState extends State<SlideableActionCards>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  late final Map<String, dynamic> _cards;
  final Set<String> _dismissedCards = {};

  void _notifyLoadingState(bool isLoading) {
    widget.onLoadingStateChanged?.call(isLoading);
  }

  Future<void> _handleKycButtonPress() async {
    if (!mounted) return;

    final kycCubit = context.read<KycCubit>();
    if (kycCubit.isClosed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please refresh the page'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final sessionData = await kycCubit.createVerificationSession();

    if (sessionData != null) {
      if (!mounted) return;
      final result = await context.router.push<bool>(
        // Capture the result
        VerificationRoute(
          sessionUrl: sessionData['url'],
          sessionId: sessionData['session_id'],
          onComplete: (sessionId, params) async {
            if (mounted &&
                !context.read<KycCubit>().isClosed &&
                params != null) {
              await context.read<KycCubit>().handleKycCompletion(
                sessionId,
                params,
              );
            }
          },
          onError: (error) {
            debugPrint('KYC error: $error');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Verification error: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      );

    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cards = {
      'title': 'Set up your KYC',
      'description': 'Complete your kyc to remove all restrictions.',
      'buttonText': 'Start KYC',
      'gradient': AppColors.blueGradient,
      'image': Assets.images.kycIllPng.path,
      'imageHeight': 75.0,
      'imageWidth': 75.0,
      'imageRight': -5.0,
      'imageBottom': -12.0,
      'onPressed': _handleKycButtonPress,
      'id': 'kyc',
    };
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });

    locator.get<VerificationManager>().initDeepLinks(
      onDeepLinkReceived: _handleDeepLink,
    );
  }

  void _handleDeepLink(Uri uri) {
    log(' Deep link received: $uri');

    final sessionId =
        uri.queryParameters['session_id'] ??
        uri.queryParameters['verificationSessionId'];

    final status = uri.queryParameters['status'];

    if (sessionId != null && mounted) {
      if (status == 'success' || status == 'completed') {
        log('KYC completion detected via deep link');
        final kycCubit = context.read<KycCubit>();
        if (!kycCubit.isClosed) {
          kycCubit.handleKycCompletion(sessionId, uri.queryParameters);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification received! Syncing...'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        log(' KYC deep link status: $status');
      }
    }
  }

  void _dismissCard(String cardId) {
    setState(() {
      _dismissedCards.add(cardId);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycCubit, KycState>(
      listener: (context, state) {
        // if (state) {
        //   _notifyLoadingState(true);
        // } else {
        //   _notifyLoadingState(false);
        // }
      },
      builder: (context, kycState) {
        if (kycState.isVerified) {
          return const SizedBox.shrink();
        }

        if (_dismissedCards.contains(_cards['id'])) {
          return const SizedBox.shrink();
        }

        log('Showing KYC card - status: ${kycState.verificationStatus}');
        return _buildCard(_cards, kycState);
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> cardData, KycState kycState) {
    final isKycCard = cardData['id'] == 'kyc';
    final isLoading = isKycCard && kycState.isCreatingSession;

    String title = cardData['title'];
    String description = cardData['description'];
    String buttonText = cardData['buttonText'];
    bool showButton = true;

    bool isButtonDisabled = false;

    if (isKycCard) {
      if (kycState.isInReview) {
        title = 'KYC In Review';
        description =
            'Your verification is being processed. This usually takes a few minutes.';
        buttonText = 'Check Status';
        isButtonDisabled = true;
      } else if (kycState.isDeclined) {
        title = 'KYC Verification Failed';
        description = 'Your verification was declined. Please try again.';
        buttonText = 'Retry KYC';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 10.0),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 25, 14.3, 20),
            decoration: BoxDecoration(
              gradient: cardData['gradient'],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.mdBold(
                          context,
                        ).copyWith(color: Colors.white, fontFamily: 'Poppins'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _dismissCard(cardData['id']),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(
                            image: AssetImage(
                              Assets.images.cancelButtonIcon.path,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const VSpace(12),
                Text(
                  description,
                  softWrap: true,
                  maxLines: 2,
                  style: AppTextStyles.xsRegular(context).copyWith(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
                const VSpace(16),
                if (isLoading)
                  const SizedBox(
                    height: 40,
                    width: 100,
                    child: Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                else if (showButton)
                  SizedBox(
                    width: 150,
                    child: ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      backgroundColor: isButtonDisabled
                          ? AppColors.gray300
                          : Colors.white,
                      isFullWidth: false,
                      text: buttonText,
                      textStyle: AppTextStyles.smSemiBold(context).copyWith(
                        color: isButtonDisabled
                            ? AppColors.gray500
                            : AppColors.blueGray900,
                        fontFamily: 'Poppins',
                      ),
                      onPressed: isButtonDisabled
                          ? () {}
                          : cardData['onPressed'],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            right: cardData['imageRight'],
            bottom: cardData['imageBottom'],
            child: cardData['imageHeight'] != null
                ? SizedBox(
                    height: cardData['imageHeight'],
                    width: cardData['imageWidth'],
                    child: ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: Image(image: AssetImage(cardData['image'])),
                    ),
                  )
                : Image(image: AssetImage(cardData['image'])),
          ),
        ],
      ),
    );
  }
}
