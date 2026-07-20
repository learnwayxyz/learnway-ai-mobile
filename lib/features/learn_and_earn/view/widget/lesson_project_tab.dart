import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_project_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/container_extension.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
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
    required this.project,
    this.phase = ProjectPhase.notSubmitted,
    this.uploadedFiles = const [],
    this.uploadError,
  });

  final CourseProject project;
  final ProjectPhase phase;
  final List<ProjectFile> uploadedFiles;
  final String? uploadError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseProjectCubit, CourseProjectState>(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: switch (phase) {
          ProjectPhase.notSubmitted => _NotSubmittedView(
            project: project,
            uploadedFiles: uploadedFiles,
            uploadError: uploadError,
          ),
          ProjectPhase.evaluating => const _EvaluatingView(),
          ProjectPhase.evaluated => const _EvaluatedView(),
        },
      ),
    );
  }
}

class _NotSubmittedView extends StatefulWidget {
  const _NotSubmittedView({
    required this.project,
    required this.uploadedFiles,
    this.uploadError,
  });

  final CourseProject project;
  final List<ProjectFile> uploadedFiles;
  final String? uploadError;

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

    final draft = LocalStorageService.getProjectDraft(widget.project.courseId);
    if (draft != null) {
      if (types.contains(draft.submissionType)) {
        _selectedType = draft.submissionType;
      }
      if (CourseProject.isFileContent(_selectedType)) {
        _draftFileUrl = draft.content.isEmpty ? null : draft.content;
      } else {
        _contentController.text = draft.content;
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
          uploadedFiles: widget.uploadedFiles,
          uploadError: widget.uploadError,
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
            return Column(
              children: [
                ButtonFactory.grayButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  text: 'Add to draft',
                  isLoading: sending?.isDraft ?? false,
                  onPressed: isSending ? () {} : _saveDraft,
                ),
                const VSpace(12),
                ButtonFactory.blackButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  text: sending != null && !sending.isDraft
                      ? 'Submitting...'
                      : 'Submit',
                  onPressed: isSending ? () {} : _submit,
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
  const _EvaluatingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
    return SizedBox(
      width: double.infinity,
      child: Column(
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

  final String instructions;

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
        Text(
          instructions,
          style: AppTextStyles.smRegular(
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
    required this.uploadedFiles,
    this.uploadError,
    required this.contentController,
    required this.selectedType,
    required this.onTypeSelected,
    this.pickedFile,
    this.draftFileUrl,
    required this.onPickFile,
    required this.onRemoveFile,
  });

  final CourseProject project;
  final List<ProjectFile> uploadedFiles;
  final String? uploadError;
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
                name: Uri.tryParse(draftFileUrl!)?.pathSegments.lastOrNull ??
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
