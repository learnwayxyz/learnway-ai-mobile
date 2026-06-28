import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButtonItem {
  const CustomButtonItem({
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
    this.textColor,
    this.backgroundColor,
    this.padding,
  });
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool enabled;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  ContextMenuButtonItem toContextMenuButtonItem() {
    return ContextMenuButtonItem(
      label: label,
      onPressed: enabled ? onPressed : null,
    );
  }

  Widget toWidget({
    VoidCallback? onTap,
    double? width,
    double? height,
    BuildContext? context,
  }) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: enabled ? (onTap ?? onPressed) : null,
        child: Container(
          width: width,
          height: height,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color:
                  enabled
                      ? (textColor ?? Colors.black)
                      : Colors.grey,
              fontSize: 12.0, // Smaller font
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _PositionedContextMenu extends StatelessWidget {
  const _PositionedContextMenu({required this.anchors, required this.child});
  final TextSelectionToolbarAnchors anchors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _ContextMenuLayoutDelegate(anchors),
      child: child,
    );
  }
}

class _ContextMenuLayoutDelegate extends SingleChildLayoutDelegate {
  _ContextMenuLayoutDelegate(this.anchors);
  final TextSelectionToolbarAnchors anchors;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final primaryAnchor = anchors.primaryAnchor;
    final secondaryAnchor = anchors.secondaryAnchor;

    // Start with the primary anchor position
    var x = primaryAnchor.dx - (childSize.width / 2);
    var y = primaryAnchor.dy - childSize.height - 8; // 8px above selection

    // Ensure the menu doesn't go off screen horizontally
    if (x < 8) {
      x = 8;
    } else if (x + childSize.width > size.width - 8) {
      x = size.width - childSize.width - 8;
    }

    // If menu would go above screen, place it below the selection
    if (y < 8) {
      y = (secondaryAnchor?.dy ?? primaryAnchor.dy) + 20;
    }

    // Ensure menu doesn't go below screen
    if (y + childSize.height > size.height - 8) {
      y = size.height - childSize.height - 8;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return oldDelegate is! _ContextMenuLayoutDelegate ||
        oldDelegate.anchors != anchors;
  }
}

class CustomButtonItems {
  static CustomButtonItem pasteUppercase(EditableTextState editableTextState) {
    return CustomButtonItem(
      label: 'Paste Uppercase',
      icon: Icons.content_paste,
      onPressed: () async {
        final data = await Clipboard.getData('text/plain');
        if (data != null) {
          final text = data.text!.toUpperCase();
          editableTextState.userUpdateTextEditingValue(
            editableTextState.textEditingValue.replaced(
              editableTextState.textEditingValue.selection,
              text,
            ),
            SelectionChangedCause.toolbar,
          );
        }
        ContextMenuController.removeAny();
      },
    );
  }

  /// Custom paste that converts text to lowercase
  static CustomButtonItem pasteLowercase(EditableTextState editableTextState) {
    return CustomButtonItem(
      label: 'Paste Lowercase',
      icon: Icons.content_paste,
      onPressed: () async {
        final data = await Clipboard.getData('text/plain');
        if (data != null) {
          final text = data.text!.toLowerCase();
          editableTextState.userUpdateTextEditingValue(
            editableTextState.textEditingValue.replaced(
              editableTextState.textEditingValue.selection,
              text,
            ),
            SelectionChangedCause.toolbar,
          );
        }
        ContextMenuController.removeAny();
      },
    );
  }
}

/// Helper class to build custom context menus
class CustomContextMenuBuilder {
  static Widget buildMenu({
    required BuildContext context,
    required EditableTextState editableTextState,
    required List<CustomButtonItem> customItems,
    bool includeDefaults = true,
    List<String> excludeDefaults = const [],
    bool useCustomWidgets = false, // New parameter for color support
  }) {
    // If using custom widgets (for color support)
    if (useCustomWidgets) {
      return _buildCustomWidgetMenu(
        context: context,
        editableTextState: editableTextState,
        customItems: customItems,
        includeDefaults: includeDefaults,
        excludeDefaults: excludeDefaults,
      );
    }

    // Standard ContextMenuButtonItem approach (no color support)
    final buttonItems = [
      ...customItems.map((item) => item.toContextMenuButtonItem()).toList(),
    ]
    // Add custom items
    ;

    // Add default items if requested
    if (includeDefaults) {
      final defaultItems =
          editableTextState.contextMenuButtonItems
              .where((item) => !excludeDefaults.contains(item.label))
              .toList();
      buttonItems.addAll(defaultItems);
    }

    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  }

  /// Build menu using custom widgets (supports colors and full styling)
  static Widget _buildCustomWidgetMenu({
    required BuildContext context,
    required EditableTextState editableTextState,
    required List<CustomButtonItem> customItems,
    bool includeDefaults = true,
    List<String> excludeDefaults = const [],
  }) {
    final menuItems = [
      ...customItems.map((item) => item.toWidget(context: context)).toList(),
    ]
    // Add custom items as widgets
    ;

    // Add default items if requested
    if (includeDefaults) {
      final defaultItems =
          editableTextState.contextMenuButtonItems
              .where((item) => !excludeDefaults.contains(item.label))
              .toList();

      menuItems.addAll(
        defaultItems.map((item) => _defaultItemToWidget(item, context)),
      );
    }

    return _PositionedContextMenu(
      anchors: editableTextState.contextMenuAnchors,
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(8.0),
        child: IntrinsicWidth(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 30, // Smaller minimum width
              maxWidth: 80, // Smaller maximum width
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems,
            ),
          ),
        ),
      ),
    );
  }

  /// Convert default ContextMenuButtonItem to custom widget
  static Widget _defaultItemToWidget(
    ContextMenuButtonItem item,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onPressed,
        child: Container(
          height: 5, // Match compact height
          width: double.infinity,
          // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  item.label ?? '',
                  style: TextStyle(
                    color:
                        item.onPressed != null
                            ? Colors.black
                            : Colors.grey,
                    fontSize: 12.0, // Smaller font to match
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
