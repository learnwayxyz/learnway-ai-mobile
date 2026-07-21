import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:learnwayv2/app/app_barrel.dart';

/// Renders any string as markdown with the app-wide typography, so cards and
/// bubbles share one stylesheet instead of each defining their own.
extension MarkdownRendering on String {
  Widget asMarkdown(BuildContext context, {TextStyle? baseStyle}) {
    return MarkdownBody(
      data: this,
      shrinkWrap: true,
      styleSheet: appMarkdownStyleSheet(context, baseStyle: baseStyle),
    );
  }
}

MarkdownStyleSheet appMarkdownStyleSheet(
  BuildContext context, {
  TextStyle? baseStyle,
}) {
  final base =
      baseStyle ??
      AppTextStyles.smRegular(context).copyWith(color: AppColors.textPrimary);
  return MarkdownStyleSheet(
    p: base,
    strong: base.copyWith(fontWeight: FontWeight.w700),
    em: base.copyWith(fontStyle: FontStyle.italic),
    code: base.copyWith(
      fontFamily: 'monospace',
      backgroundColor: AppColors.gray200,
    ),
    h1: AppTextStyles.baseBold(context),
    h2: AppTextStyles.smBold(context),
    h3: AppTextStyles.smBold(context),
    listBullet: base,
    blockSpacing: 6,
    listIndent: 16,
  );
}
