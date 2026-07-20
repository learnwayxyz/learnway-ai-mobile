import 'package:gal/gal.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/certificate_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/certificate_claim.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/container_extension.dart';
import 'package:learnwayv2/features/quiz/services/lesson_share_service.dart';
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
      child: BlocBuilder<CertificateCubit, CertificateState>(
        builder: (context, state) {
          if (state is CertificateInitial || state is CertificateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  final _nameController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Enter your full name');
      return;
    }
    context.read<CertificateCubit>().claimCertificate(widget.courseId, name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Text('Claim your certificate', style: AppTextStyles.lgBold(context)),
          const VSpace(8),
          Text(
            "Enter the full name you'd like printed on your certificate.",
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray500),
          ),
          const VSpace(16),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Full name',
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
          const VSpace(20),
          ButtonFactory.blackButton(
            mainAxisAlignment: MainAxisAlignment.center,
            text: 'Submit',
            onPressed: _submit,
          ),
        ],
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
              child: _GradientButton(
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

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  // LearnWay gradient: #215AEB (AppColors.primaryMain) → #133385 (no
  // AppColors match).
  static final Gradient _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryMain, const Color(0xFF133385)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      text,
                      style: AppTextStyles.buttonText(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.isLocked, this.imageUrl});

  final bool isLocked;
  final String? imageUrl;

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
        const _LockedOverlay(),
      ],
    ).cardStyle();
  }
}

class _LockedOverlay extends StatelessWidget {
  const _LockedOverlay();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gray900,
          ),
          // TODO: replace with the exact lock icon asset when available
          child: const Icon(Icons.lock_outline, color: Colors.white, size: 22),
        ),
        const VSpace(12),
        Text(
          'Certificate Locked',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Claim your certificate to unlock it',
            style: AppTextStyles.baseMedium(
              context,
            ).copyWith(color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
