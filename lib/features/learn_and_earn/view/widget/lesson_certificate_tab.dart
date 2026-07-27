import 'package:gal/gal.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/certificate_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_project_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/certificate_claim.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/container_extension.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/locked_overlay.dart';
import 'package:learnwayv2/features/quiz/services/lesson_share_service.dart';
import 'package:learnwayv2/services/revenue_cat_service.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class CertificateTab extends StatelessWidget {
  const CertificateTab({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CertificateCubit, CertificateState>(
      listener: (context, state) {
        if (state is CertificateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: RevenueCatService.instance.premiumStatusNotifier,
        builder: (context, isPremium, _) {
          final hasPremium =
              isPremium || RevenueCatService.instance.isPremiumUser;
          return BlocBuilder<CourseProjectCubit, CourseProjectState>(
            builder: (context, projectState) {
              // The certificate is earned by passing the course project:
              // the backend's assessment verdict is the source of truth.
              final passedProject =
                  projectState is CourseProjectSubmitted &&
                  (projectState.result.assessment?.passed ?? false);

              if (!hasPremium || !passedProject) {
                return _LockedCertificateView(showSubscribeCta: !hasPremium);
              }

              return BlocBuilder<CertificateCubit, CertificateState>(
                builder: (context, state) {
                  if (state is CertificateInitial ||
                      state is CertificateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: switch (state) {
                      CertificateClaimed(:final certificate) => _ClaimedView(
                        certificate: certificate,
                      ),
                      _ => _UnclaimedView(
                        courseId: courseId,
                        isClaiming: state is CertificateClaiming,
                      ),
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Locked state for the whole certificate tab: free users get a subscribe
/// CTA; premium users whose latest project assessment isn't `passed` are
/// told to finish it first.
class _LockedCertificateView extends StatelessWidget {
  const _LockedCertificateView({required this.showSubscribeCta});

  final bool showSubscribeCta;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _CertificateCard(
            isLocked: true,
            overlay: LockedOverlay(
              title: 'Certificate Locked',
              subtitle: showSubscribeCta
                  ? 'Subscribe to premium to get certificate'
                  : 'Pass the course project to unlock your certificate',
              action: showSubscribeCta
                  ? ButtonFactory.gradientButton(
                      text: 'Subscribe to get certificate',
                      onPressed: () =>
                          context.router.push(const PayWallRoute()),
                    )
                  : null,
            ),
          ),
          const VSpace(24),
        ],
      ),
    );
  }
}

class _UnclaimedView extends StatelessWidget {
  const _UnclaimedView({required this.courseId, required this.isClaiming});

  final String courseId;
  final bool isClaiming;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CertificateCard(isLocked: true),
        const VSpace(24),
        ButtonFactory.blackButton(
          mainAxisAlignment: MainAxisAlignment.center,
          text: 'Claim Certificate',
          isLoading: isClaiming,
          onPressed: isClaiming
              ? () {}
              : () => _showClaimSheet(context, courseId),
        ),
        const VSpace(24),
      ],
    );
  }

  void _showClaimSheet(BuildContext context, String courseId) {
    final cubit = context.read<CertificateCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: cubit,
        child: _ClaimCertificateSheet(courseId: courseId),
      ),
    );
  }
}

class _ClaimCertificateSheet extends StatefulWidget {
  const _ClaimCertificateSheet({required this.courseId});

  final String courseId;

  @override
  State<_ClaimCertificateSheet> createState() => _ClaimCertificateSheetState();
}

class _ClaimCertificateSheetState extends State<_ClaimCertificateSheet> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submit() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty) {
      setState(() => _errorText = 'Enter your first and last name');
      return;
    }
    final name = '$firstName $lastName';
    context.read<CertificateCubit>().claimCertificate(widget.courseId, name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Claim your certificate',
              style: AppTextStyles.lgBold(context),
            ),
            const VSpace(8),
            Text(
              "Enter the name you'd like printed on your certificate.",
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
            ),
            const VSpace(16),
            TextField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'First name',
                errorText: _errorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary500),
                ),
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
            const VSpace(12),
            TextField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Last name',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary500),
                ),
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
            const VSpace(20),
            ButtonFactory.blackButton(
              mainAxisAlignment: MainAxisAlignment.center,
              text: 'Submit',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClaimedView extends StatefulWidget {
  const _ClaimedView({required this.certificate});

  final CertificateClaim certificate;

  @override
  State<_ClaimedView> createState() => _ClaimedViewState();
}

class _ClaimedViewState extends State<_ClaimedView> {
  final _certificateKey = GlobalKey();
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _certificateKey,
          child: _CertificateCard(
            isLocked: false,
            imageUrl: widget.certificate.imageUri,
          ),
        ),
        const VSpace(12),
        Text(
          '${widget.certificate.courseTitle} · ${widget.certificate.studentName}',
          style: AppTextStyles.smMedium(
            context,
          ).copyWith(color: AppColors.gray600),
          textAlign: TextAlign.center,
        ),
        const VSpace(24),
        Row(
          children: [
            Expanded(
              child: ButtonFactory.gradientButton(
                text: 'Download',
                isLoading: _isSaving,
                onPressed: _isSaving ? null : _download,
              ),
            ),
            const HSpace(16),
            Expanded(
              child: ButtonFactory.blackButton(
                text: 'Share',
                mainAxisAlignment: MainAxisAlignment.center,
                isLoading: _isSharing,
                onPressed: _isSharing ? () {} : _share,
              ),
            ),
          ],
        ),
        const VSpace(24),
      ],
    );
  }

  Future<void> _download() async {
    setState(() => _isSaving = true);
    try {
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Photo library access is needed to save the certificate',
                ),
              ),
            );
          }
          return;
        }
      }

      // The certificate is an SVG (imageUri); rasterize the already-rendered
      // widget instead of re-decoding/parsing the SVG ourselves.
      final bytes = await LessonShareService.captureWidgetAsImage(
        repaintBoundaryKey: _certificateKey,
      );
      if (bytes == null) throw Exception('Failed to render certificate');

      await Gal.putImageBytes(
        bytes,
        name: 'certificate_${widget.certificate.certificateNumber}',
        album: 'LearnWay',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certificate saved to your photos')),
        );
      }
    } on GalException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save certificate: ${e.type.message}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save certificate: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _share() async {
    setState(() => _isSharing = true);
    try {
      await LessonShareService.shareWidget(
        repaintBoundaryKey: _certificateKey,
        text:
            'I just earned my ${widget.certificate.courseTitle} '
            'certificate on LearnWay!',
        subject: 'My LearnWay certificate',
        context: context,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share certificate: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.isLocked, this.imageUrl, this.overlay});

  final bool isLocked;
  final String? imageUrl;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final Widget image;
    if (url != null && url.isNotEmpty) {
      image = url.toLowerCase().endsWith('.svg')
          ? SvgPicture.network(url, width: double.infinity, fit: BoxFit.contain)
          : Image.network(url, width: double.infinity, fit: BoxFit.contain);
    } else {
      image = Image.asset(
        Assets.images.learnwayCert.path,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    }
    // SvgPicture (unlike Image) needs a bounded height to lay out — the
    // surrounding Column doesn't constrain one, so derive it from width.
    final certificate = AspectRatio(aspectRatio: 4 / 3, child: image);

    if (!isLocked) {
      return certificate.cardStyle();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.2, child: certificate),
        overlay ??
            const LockedOverlay(
              title: 'Certificate Locked',
              subtitle: 'Claim your certificate to unlock it',
            ),
      ],
    ).cardStyle();
  }
}
