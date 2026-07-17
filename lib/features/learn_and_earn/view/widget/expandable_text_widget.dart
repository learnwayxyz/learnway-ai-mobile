import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../shared/utilities/standard_spacer.dart';

class ExpandableDescription extends StatefulWidget {
  const ExpandableDescription({super.key, required this.text});
  final String text;

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _expanded = false;
  bool? _isOverflowing;

  static const int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.smRegular(
      context,
    ).copyWith(color: AppColors.gray600);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: style);
        final painter = TextPainter(
          text: span,
          maxLines: _maxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        _isOverflowing = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _expanded ? null : _maxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (_isOverflowing == true) ...[
              const VSpace(8),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Show less' : 'Show more...',
                  style: AppTextStyles.smMedium(
                    context,
                  ).copyWith(color: AppColors.primary25),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
