import 'package:dotted_border/dotted_border.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/container_extension.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

enum SubmissionStatus { notSubmitted, submitted, review, completed }

enum ProjectPhase { notSubmitted, evaluating, evaluated }

const Color _statusGrayText = Color(0xFF535862);
const Color _statusGreenBg = Color(0xFFECFDF3);
const Color _statusGreenText = Color(0xFF027A48);

class ProjectFile {
  const ProjectFile({required this.name, required this.size});

  final String name;
  final String size;

  String get extensionLabel =>
      name.contains('.') ? name.split('.').last.toUpperCase() : 'FILE';
}

class ScoreItem {
  const ScoreItem({required this.label, required this.score});

  final String label;
  final int score;
}

class ProjectTab extends StatelessWidget {
  const ProjectTab({
    super.key,
    this.phase = ProjectPhase.notSubmitted,
    this.uploadedFiles = const [],
    this.uploadError,
  });

  final ProjectPhase phase;
  final List<ProjectFile> uploadedFiles;
  final String? uploadError;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: switch (phase) {
        ProjectPhase.notSubmitted => _NotSubmittedView(
          uploadedFiles: uploadedFiles,
          uploadError: uploadError,
        ),
        ProjectPhase.evaluating => const _EvaluatingView(),
        ProjectPhase.evaluated => const _EvaluatedView(),
      },
    );
  }
}

class _NotSubmittedView extends StatelessWidget {
  const _NotSubmittedView({required this.uploadedFiles, this.uploadError});

  final List<ProjectFile> uploadedFiles;
  final String? uploadError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ProjectAssignmentCard(
          submissionStatus: SubmissionStatus.notSubmitted,
          assignmentTitle: 'Build a Token Swap Contract',
          assignmentDescriptionText:
              'Write and deploy a smart contract that lets two ERC-20 '
              'tokens be exchanged at a fixed rate. Cover the happy path, '
              'one edge case, and one security guard of your choice',
        ),
        const VSpace(16),
        const _InstructionsCard(
          instructions: [
            'Set up your contract with two token addresses',
            'Implement the swap function with slippage checks',
            'Add a reentrancy guard',
            'Write at least 3 unit tests',
          ],
        ),
        const VSpace(16),
        _UploadWorkCard(uploadedFiles: uploadedFiles, uploadError: uploadError),
        const VSpace(24),
        ButtonFactory.blackButton(
          mainAxisAlignment: MainAxisAlignment.center,
          text: 'Submit',
          onPressed: () {},
        ),
        const VSpace(24),
      ],
    );
  }
}

class _EvaluatingView extends StatelessWidget {
  const _EvaluatingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SubmissionSummaryCard(
          submissionStatus: SubmissionStatus.submitted,
          title: 'Token Swap Contract',
          subtitle:
              'Submitted 14 minutes ago · TokenSwap.sol, tests-bundle.zip',
        ),
        VSpace(16),
        _EvaluationInProgressCard(),
        VSpace(24),
      ],
    );
  }
}

class _EvaluatedView extends StatelessWidget {
  const _EvaluatedView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SubmissionSummaryCard(
          submissionStatus: SubmissionStatus.review,
          title: 'Token Swap Contract',
          subtitle:
              'Submitted 14 minutes ago · TokenSwap.sol, tests-bundle.zip',
        ),
        VSpace(16),
        _AiScoreCard(
          totalScore: 87,
          items: [
            ScoreItem(label: 'Code  quality', score: 92),
            ScoreItem(label: 'Security', score: 78),
            ScoreItem(label: 'Gas efficiency', score: 85),
            ScoreItem(label: 'Documentation', score: 90),
          ],
        ),
        VSpace(16),
        _FeedbackCard(
          feedback: [
            'Swap logic and slippage checks are correct',
            'Test coverage is solid across the happy path',
            'Reentrancy guard is missing on the withdraw path',
          ],
        ),
        VSpace(24),
      ],
    );
  }
}

class _SubmissionStatusCapsule extends StatelessWidget {
  const _SubmissionStatusCapsule({required this.status});

  final SubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    final style = _getSubmissionStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: style.foreground,
            ),
          ),
          const HSpace(6),
          Text(
            style.label,
            style: AppTextStyles.smMedium(
              context,
            ).copyWith(color: style.foreground),
          ),
        ],
      ),
    );
  }
}

class _ProjectAssignmentCard extends StatelessWidget {
  const _ProjectAssignmentCard({
    required this.submissionStatus,
    required this.assignmentTitle,
    required this.assignmentDescriptionText,
  });

  final SubmissionStatus submissionStatus;
  final String assignmentTitle;
  final String assignmentDescriptionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubmissionStatusCapsule(status: submissionStatus),
        const VSpace(12),
        Text(
          assignmentTitle,
          style: AppTextStyles.lgBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(8),
        Text(
          assignmentDescriptionText,
          style: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray500),
        ),
      ],
    ).cardStyle();
  }
}

class _SubmissionSummaryCard extends StatelessWidget {
  const _SubmissionSummaryCard({
    required this.submissionStatus,
    required this.title,
    required this.subtitle,
  });

  final SubmissionStatus submissionStatus;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubmissionStatusCapsule(status: submissionStatus),
        const VSpace(12),
        Text(
          title,
          style: AppTextStyles.lgBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(8),
        Text(
          subtitle,
          style: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray500),
        ),
      ],
    ).cardStyle();
  }
}

class _EvaluationInProgressCard extends StatelessWidget {
  const _EvaluationInProgressCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VSpace(40),
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: AppColors.primary500,
            backgroundColor: AppColors.gray100,
          ),
        ),
        const VSpace(24),
        Text(
          'AI evaluation in progress',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "We're reviewing your code for correctness, security and gas "
            'efficiency. This usually takes 2–3 minutes',
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray500),
            textAlign: TextAlign.center,
          ),
        ),
        const VSpace(40),
      ],
    ).cardStyle();
  }
}

class _AiScoreCard extends StatelessWidget {
  const _AiScoreCard({required this.totalScore, required this.items});

  final int totalScore;
  final List<ScoreItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI score card',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$totalScore/',
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: _statusGreenText),
            ),
            Text(
              '100',
              style: AppTextStyles.mdBold(
                context,
              ).copyWith(color: _statusGreenText),
            ),
          ],
        ),
        const VSpace(16),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const VSpace(16),
          _ScoreRow(item: items[i]),
        ],
      ],
    ).cardStyle();
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.item});

  final ScoreItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.label,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray700),
            ),
            Text(
              '${item.score}',
              style: AppTextStyles.smMedium(
                context,
              ).copyWith(color: AppColors.gray900),
            ),
          ],
        ),
        const VSpace(6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 140,
            child: LinearProgressIndicator(
              value: item.score / 100,
              minHeight: 5,
              color: AppColors.primary500,
              backgroundColor: AppColors.gray100,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback});

  final List<String> feedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(12),
        for (var i = 0; i < feedback.length; i++) ...[
          if (i > 0)
            Divider(height: 24, thickness: 1, color: AppColors.gray100),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, size: 16, color: _statusGreenText),
              const HSpace(10),
              Expanded(
                child: Text(
                  feedback[i],
                  style: AppTextStyles.smRegular(
                    context,
                  ).copyWith(color: AppColors.gray700),
                ),
              ),
            ],
          ),
        ],
      ],
    ).cardStyle();
  }
}

class _InstructionsCard extends StatelessWidget {
  const _InstructionsCard({required this.instructions});

  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(12),
        for (var i = 0; i < instructions.length; i++) ...[
          if (i > 0)
            Divider(height: 24, thickness: 1, color: AppColors.gray100),
          _InstructionRow(index: i + 1, text: instructions[i]),
        ],
      ],
    ).cardStyle();
  }
}

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.success50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$index',
            style: AppTextStyles.xsMedium(
              context,
            ).copyWith(color: AppColors.success700),
          ),
        ),
        const HSpace(12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray700),
          ),
        ),
      ],
    );
  }
}

class _UploadWorkCard extends StatelessWidget {
  const _UploadWorkCard({required this.uploadedFiles, this.uploadError});

  final List<ProjectFile> uploadedFiles;
  final String? uploadError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload your work',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(16),
        const _FileDropZone(),
        if (uploadError != null) ...[
          const VSpace(12),
          _UploadFailedBanner(message: uploadError!),
        ],
        if (uploadedFiles.isNotEmpty) ...[
          const VSpace(12),
          for (var i = 0; i < uploadedFiles.length; i++) ...[
            if (i > 0) const VSpace(8),
            _UploadedFileTile(file: uploadedFiles[i]),
          ],
        ],
        const VSpace(20),
        Text(
          'Link to repository (optional)',
          style: AppTextStyles.smMedium(
            context,
          ).copyWith(color: AppColors.gray700),
        ),
        const VSpace(8),
        TextField(
          decoration: _inputDecoration(context, hint: 'Paste link here'),
        ),
        const VSpace(16),
        Text(
          'Type Assignment here  (optional)',
          style: AppTextStyles.smMedium(
            context,
          ).copyWith(color: AppColors.gray700),
        ),
        const VSpace(8),
        TextField(
          maxLines: 6,
          decoration: _inputDecoration(context, hint: 'Type Assignment here'),
        ),
      ],
    ).cardStyle();
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.smRegular(
        context,
      ).copyWith(color: AppColors.gray400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
    );
  }
}

class _FileDropZone extends StatelessWidget {
  const _FileDropZone();

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: const [6, 6],
        strokeWidth: 1.5,
        radius: const Radius.circular(16),
        color: AppColors.primary300,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary100,
              ),
              // TODO: replace with the exact upload icon asset when available
              child: Icon(
                Icons.file_upload_outlined,
                color: AppColors.primary500,
                size: 28,
              ),
            ),
            const VSpace(16),
            Text(
              'Drop files here or tap to browse',
              style: AppTextStyles.smMedium(
                context,
              ).copyWith(color: AppColors.gray900),
            ),
            const VSpace(4),
            Text(
              '.sol · .js · .pdf · .zip — up to 25MB each',
              style: AppTextStyles.xsRegular(
                context,
              ).copyWith(color: AppColors.gray500),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadedFileTile extends StatelessWidget {
  const _UploadedFileTile({required this.file});

  final ProjectFile file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary900,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              file.extensionLabel,
              style: AppTextStyles.xsMedium(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
          const HSpace(10),
          Expanded(
            child: Text(
              file.name,
              style: AppTextStyles.smMedium(
                context,
              ).copyWith(color: AppColors.gray900),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const HSpace(10),
          Text(
            file.size,
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: AppColors.gray500),
          ),
          const HSpace(10),
          Icon(Icons.cancel_outlined, size: 20, color: AppColors.gray700),
        ],
      ),
    );
  }
}

class _UploadFailedBanner extends StatelessWidget {
  const _UploadFailedBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: const [6, 6],
        strokeWidth: 1.5,
        radius: const Radius.circular(16),
        color: AppColors.error300,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.error50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // TODO: replace with the exact warning icon asset when available
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error500,
              size: 28,
            ),
            const VSpace(12),
            Text(
              'Upload Failed',
              style: AppTextStyles.smMedium(
                context,
              ).copyWith(color: AppColors.gray900),
            ),
            const VSpace(4),
            Text(
              message,
              style: AppTextStyles.xsRegular(
                context,
              ).copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

({Color background, Color foreground, String label}) _getSubmissionStyle(
  SubmissionStatus status,
) {
  return switch (status) {
    SubmissionStatus.notSubmitted => (
      background: AppColors.gray300,
      foreground: _statusGrayText,
      label: 'Not submitted',
    ),
    SubmissionStatus.submitted => (
      background: AppColors.warning100v2,
      foreground: AppColors.warning700v2,
      label: 'Submitted',
    ),
    SubmissionStatus.review => (
      background: _statusGreenBg,
      foreground: _statusGreenText,
      label: 'Review',
    ),
    SubmissionStatus.completed => (
      background: _statusGreenBg,
      foreground: _statusGreenText,
      label: 'Completed',
    ),
  };
}
