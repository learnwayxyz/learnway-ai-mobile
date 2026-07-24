import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_project_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project_submission.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/container_extension.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/markdown_extension.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

enum SubmissionStatus { notSubmitted, submitted, review, completed }

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

class ProjectTab extends StatelessWidget {
  const ProjectTab({super.key, required this.project});

  final CourseProject project;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseProjectCubit, CourseProjectState>(
      listener: (context, state) {
        final message = switch (state) {
          CourseProjectDraftSaved() => 'Draft saved',
          CourseProjectSubmitted() => 'Project submitted',
          CourseProjectActionError(:final error) => error,
          _ => null,
        };
        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: switch (state) {
            CourseProjectSending(isDraft: false) => _EvaluatingView(
              project: project,
            ),
            CourseProjectSubmitted(:final result) => _EvaluatedView(
              project: project,
              result: result,
            ),
            _ => Builder(
              builder: (context) {
                // Prefill from the server-side draft when one exists; keying
                // by the draft id re-initializes the form once a draft is
                // restored from the backend after this widget first built.
                final serverDraft = context
                    .read<CourseProjectCubit>()
                    .serverDraftFor(project.courseId);
                return _NotSubmittedView(
                  key: ValueKey(
                    '${project.courseId}:${serverDraft?.id ?? 'local'}',
                  ),
                  project: project,
                  serverDraft: serverDraft,
                );
              },
            ),
          },
        );
      },
    );
  }
}

/// Shown on the Project tab while the course still has unfinished lessons.
/// Progress values come from the same CourseLesson payload that powers the
/// aiLessonCard header.
class ProjectNotAvailableCard extends StatelessWidget {
  const ProjectNotAvailableCard({
    super.key,
    required this.progressValue,
    required this.lessonsRemaining,
  });

  final double progressValue;
  final int lessonsRemaining;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const VSpace(24),
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary50,
            ),
            child: const Text('🔒', style: TextStyle(fontSize: 34)),
          ),
          const VSpace(20),
          Text(
            'Project not available yet',
            style: AppTextStyles.mdBold(
              context,
            ).copyWith(color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
          const VSpace(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Finish the remaining lessons to unlock the hands-on project.',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
          ),
          const VSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue.clamp(0, 1),
                minHeight: 6,
                color: AppColors.primary500,
                backgroundColor: AppColors.gray100,
              ),
            ),
          ),
          const VSpace(10),
          Text(
            '$lessonsRemaining '
            '${lessonsRemaining == 1 ? 'lesson' : 'lessons'} remaining',
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray700),
            textAlign: TextAlign.center,
          ),
          const VSpace(24),
        ],
      ).cardStyle(),
    );
  }
}

class _NotSubmittedView extends StatefulWidget {
  const _NotSubmittedView({super.key, required this.project, this.serverDraft});

  final CourseProject project;
  final ProjectSubmission? serverDraft;

  @override
  State<_NotSubmittedView> createState() => _NotSubmittedViewState();
}

class _NotSubmittedViewState extends State<_NotSubmittedView> {
  final _contentController = TextEditingController();
  late String _selectedType;
  File? _pickedFile;
  String? _draftFileUrl;

  @override
  void initState() {
    super.initState();
    final types = widget.project.submissionTypes;
    _selectedType = types.first;

    final localDraft = LocalStorageService.getProjectDraft(
      widget.project.courseId,
    );

    // The server-side draft (POST course/{id}/project/draft) is the source of
    // truth; the local Hive draft is a fallback both for saves that never
    // reached the backend and for a server row that echoes back empty content.
    final serverDraft = widget.serverDraft;
    if (serverDraft != null) {
      final draftType = serverDraft.submissionType.trim().toUpperCase();
      if (types.contains(draftType)) _selectedType = draftType;
      if (CourseProject.isFileContent(_selectedType)) {
        final url = serverDraft.fileUrl;
        _draftFileUrl = (url == null || url.isEmpty)
            ? (localDraft?.content.isEmpty ?? true ? null : localDraft!.content)
            : url;
      } else {
        final serverText =
            ((serverDraft.textContent?.isNotEmpty ?? false)
                ? serverDraft.textContent
                : serverDraft.linkUrl) ??
            '';
        _contentController.text = serverText.isNotEmpty
            ? serverText
            : (localDraft?.content ?? '');
      }
      return;
    }

    if (localDraft != null) {
      if (types.contains(localDraft.submissionType)) {
        _selectedType = localDraft.submissionType;
      }
      if (CourseProject.isFileContent(_selectedType)) {
        _draftFileUrl = localDraft.content.isEmpty ? null : localDraft.content;
      } else {
        _contentController.text = localDraft.content;
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProjectAssignmentCard(
          submissionStatus: SubmissionStatus.notSubmitted,
          assignmentTitle: widget.project.title,
          assignmentDescriptionText:
              'Passing score: '
              '${widget.project.passingScore}/${widget.project.maxScore}',
        ),
        const VSpace(16),
        _InstructionsCard(instructions: widget.project.instructions),
        const VSpace(16),
        _UploadWorkCard(
          project: widget.project,
          contentController: _contentController,
          selectedType: _selectedType,
          onTypeSelected: (type) => setState(() => _selectedType = type),
          pickedFile: _pickedFile,
          draftFileUrl: _draftFileUrl,
          onPickFile: _pickFile,
          onRemoveFile: () => setState(() {
            _pickedFile = null;
            _draftFileUrl = null;
          }),
        ),
        const VSpace(24),
        BlocBuilder<CourseProjectCubit, CourseProjectState>(
          builder: (context, state) {
            final sending = state is CourseProjectSending ? state : null;
            final isSending = sending != null;
            // A project that has already been passed cannot be resubmitted.
            final hasPassed = context
                .read<CourseProjectCubit>()
                .hasPassedProject(widget.project.courseId);
            return Column(
              children: [
                if (hasPassed) ...[
                  Text(
                    "You've already passed this project — resubmission is "
                    'disabled.',
                    style: AppTextStyles.smRegular(
                      context,
                    ).copyWith(color: AppColors.gray500),
                    textAlign: TextAlign.center,
                  ),
                  const VSpace(12),
                ],
                ButtonFactory.grayButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  text: 'Add to draft',
                  isLoading: sending?.isDraft ?? false,
                  onPressed: (isSending || hasPassed) ? () {} : _saveDraft,
                ),
                const VSpace(12),
                ButtonFactory.blackButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  text: 'Submit',
                  onPressed: (isSending || hasPassed) ? () {} : _submit,
                ),
              ],
            );
          },
        ),
        const VSpace(24),
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: _selectedType == 'IMAGE' ? FileType.image : FileType.custom,
      allowedExtensions: switch (_selectedType) {
        'PDF' => ['pdf'],
        'DOCUMENT' => ['pdf', 'doc', 'docx', 'txt'],
        _ => null,
      },
    );
    final path = result?.files.single.path;
    if (path == null) return;
    setState(() {
      _pickedFile = File(path);
      _draftFileUrl = null;
    });
  }

  bool _isFileType() => CourseProject.isFileContent(_selectedType);

  void _saveDraft() {
    context.read<CourseProjectCubit>().saveDraft(
      widget.project.courseId,
      submissionType: _selectedType,
      content: _isFileType()
          ? (_draftFileUrl ?? '')
          : _contentController.text.trim(),
      file: _isFileType() ? _pickedFile : null,
    );
  }

  void _submit() {
    final isFile = _isFileType();
    final content = isFile
        ? (_draftFileUrl ?? '')
        : _contentController.text.trim();
    if (content.isEmpty && (!isFile || _pickedFile == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add your work before submitting')),
      );
      return;
    }
    context.read<CourseProjectCubit>().submitProject(
      widget.project.courseId,
      submissionType: _selectedType,
      content: content,
      file: isFile ? _pickedFile : null,
    );
  }
}

class _EvaluatingView extends StatelessWidget {
  const _EvaluatingView({required this.project});

  final CourseProject project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubmissionSummaryCard(
          submissionStatus: SubmissionStatus.submitted,
          title: project.title,
          subtitle: project.instructions,
        ),
        const VSpace(16),
        const _EvaluationInProgressCard(),
        const VSpace(24),
      ],
    );
  }
}

class _EvaluatedView extends StatelessWidget {
  const _EvaluatedView({required this.project, required this.result});

  final CourseProject project;
  final CourseProjectSubmissionResult result;

  @override
  Widget build(BuildContext context) {
    final assessment = result.assessment;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubmissionSummaryCard(
          submissionStatus: assessment?.passed ?? false
              ? SubmissionStatus.completed
              : SubmissionStatus.review,
          title: project.title,
          subtitle: project.instructions,
        ),
        if (assessment != null) ...[
          const VSpace(16),
          _AiScoreCard(assessment: assessment),
          const VSpace(16),
          _FeedbackCard(assessment: assessment),
        ],
        const VSpace(24),
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubmissionStatusCapsule(status: submissionStatus),
          const VSpace(12),
          Text(
            assignmentTitle,
            style: AppTextStyles.smBold(
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
      ).cardStyle(),
    );
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
            'efficiency. This usually takes 2-3 minutes',
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
  const _AiScoreCard({required this.assessment});

  final ProjectAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final score = assessment.score ?? 0;
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
              '$score/',
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
        _ScoreProgressRow(label: 'Score', score: score),
      ],
    ).cardStyle();
  }
}

class _ScoreProgressRow extends StatelessWidget {
  const _ScoreProgressRow({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray700),
            ),
            Text(
              '$score',
              style: AppTextStyles.smMedium(
                context,
              ).copyWith(color: AppColors.gray700),
            ),
          ],
        ),
        const VSpace(6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (score.clamp(0, 100)) / 100,
            minHeight: 6,
            color: AppColors.primary500,
            backgroundColor: AppColors.gray100,
          ),
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.assessment});

  final ProjectAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final strength in assessment.strengths)
        (
          icon: Icons.check_circle,
          color: AppColors.success75,
          checkColor: _statusGreenText,
          text: strength,
        ),
      for (final weakness in assessment.weaknesses)
        (
          icon: Icons.error_outline,
          color: AppColors.warning700v2,
          checkColor: null,
          text: weakness,
        ),
      for (final recommendation in assessment.recommendations)
        (
          icon: Icons.lightbulb_outline,
          color: AppColors.primary500,
          checkColor: null,
          text: recommendation,
        ),
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(16),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Divider(height: 24, thickness: 1, color: AppColors.gray200v2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              items[i].checkColor != null
                  ? Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: items[i].color,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 11,
                        color: items[i].checkColor,
                      ),
                    )
                  : Icon(items[i].icon, size: 16, color: items[i].color),
              const HSpace(10),
              Expanded(
                child: Text(
                  items[i].text,
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

  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions',
          style: AppTextStyles.smBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(12),
        instructions.asMarkdown(
          context,
          baseStyle: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray700),
        ),
      ],
    ).cardStyle();
  }
}

class _UploadWorkCard extends StatelessWidget {
  const _UploadWorkCard({
    required this.project,
    required this.contentController,
    required this.selectedType,
    required this.onTypeSelected,
    this.pickedFile,
    this.draftFileUrl,
    required this.onPickFile,
    required this.onRemoveFile,
  });

  final CourseProject project;
  final TextEditingController contentController;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;
  final File? pickedFile;
  final String? draftFileUrl;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  @override
  Widget build(BuildContext context) {
    final types = project.submissionTypes;
    final isTyped = CourseProject.isTypedContent(selectedType);
    final isFile = CourseProject.isFileContent(selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload your work',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        if (types.length > 1) ...[
          const VSpace(16),
          Text(
            'Submit as',
            style: AppTextStyles.smMedium(
              context,
            ).copyWith(color: AppColors.gray700),
          ),
          const VSpace(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in types)
                ChoiceChip(
                  label: Text(CourseProject.submissionTypeLabel(type)),
                  selected: type == selectedType,
                  selectedColor: AppColors.primary100,
                  labelStyle: AppTextStyles.smMedium(context).copyWith(
                    color: type == selectedType
                        ? AppColors.primary700
                        : AppColors.gray700,
                  ),
                  onSelected: (_) => onTypeSelected(type),
                ),
            ],
          ),
        ],
        const VSpace(16),
        if (isFile) ...[
          if (pickedFile != null)
            _UploadedFileTile(
              file: ProjectFile(
                name: pickedFile!.path.split('/').last,
                size: _fileSizeLabel(pickedFile!),
              ),
              onRemove: onRemoveFile,
            )
          else if (draftFileUrl != null)
            _UploadedFileTile(
              file: ProjectFile(
                name:
                    Uri.tryParse(draftFileUrl!)?.pathSegments.lastOrNull ??
                    draftFileUrl!,
                size: 'Uploaded',
              ),
              onRemove: onRemoveFile,
            )
          else
            GestureDetector(
              onTap: onPickFile,
              child: _FileDropZone(
                hint: switch (selectedType) {
                  'PDF' => '.pdf — up to 25MB',
                  'IMAGE' => '.png · .jpg — up to 25MB',
                  _ => '.pdf · .doc · .docx · .txt — up to 25MB',
                },
              ),
            ),
        ] else ...[
          Text(
            isTyped
                ? 'Type your ${CourseProject.submissionTypeLabel(selectedType).toLowerCase()} here'
                : CourseProject.submissionTypeLabel(selectedType),
            style: AppTextStyles.smMedium(
              context,
            ).copyWith(color: AppColors.gray700),
          ),
          const VSpace(8),
          TextField(
            controller: contentController,
            maxLines: isTyped ? 6 : 1,
            keyboardType: isTyped ? TextInputType.multiline : TextInputType.url,
            decoration: _inputDecoration(
              context,
              hint: isTyped ? 'Type your work here' : 'Paste link here',
            ),
          ),
        ],
      ],
    ).cardStyle();
  }

  String _fileSizeLabel(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
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
  const _FileDropZone({
    this.hint = '.sol · .js · .pdf · .zip — up to 25MB each',
  });

  final String hint;

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
              hint,
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
  const _UploadedFileTile({required this.file, this.onRemove});

  final ProjectFile file;
  final VoidCallback? onRemove;

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
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.cancel_outlined,
              size: 20,
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: re-enable once file uploads report per-file failure state.
// class _UploadFailedBanner extends StatelessWidget {
//   const _UploadFailedBanner({required this.message});
//
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return DottedBorder(
//       options: RoundedRectDottedBorderOptions(
//         dashPattern: const [6, 6],
//         strokeWidth: 1.5,
//         radius: const Radius.circular(16),
//         color: AppColors.error300,
//       ),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         decoration: BoxDecoration(
//           color: AppColors.error50,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             // TODO: replace with the exact warning icon asset when available
//             Icon(
//               Icons.warning_amber_rounded,
//               color: AppColors.error500,
//               size: 28,
//             ),
//             const VSpace(12),
//             Text(
//               'Upload Failed',
//               style: AppTextStyles.smMedium(
//                 context,
//               ).copyWith(color: AppColors.gray900),
//             ),
//             const VSpace(4),
//             Text(
//               message,
//               style: AppTextStyles.xsRegular(
//                 context,
//               ).copyWith(color: AppColors.gray500),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
