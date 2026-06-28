import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:core/core.dart';

class TabItem<T> {
  final T value;
  final String label;
  final Widget? icon;
  final Widget? trailingIcon;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const TabItem({
    required this.value,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.padding,
    this.textStyle,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });
}

typedef TabItemBuilder<T> = TabItem<T> Function(int index, T value);

class CustomTabs<T> extends StatelessWidget {
  const CustomTabs({
    this.tabs,
    this.tabValues,
    this.itemBuilder,
    this.itemCount,
    required this.selectedValue,
    required this.onTabSelected,
    this.scrollDirection = Axis.horizontal,
    this.padding = const EdgeInsets.all(10),
    this.spacing = 17.0,
    this.defaultSelectedColor = Colors.black,
    this.defaultUnselectedColor,
    this.defaultSelectedTextColor = Colors.white,
    this.defaultUnselectedTextColor,
    this.borderRadius = 60.0,
    this.showCheckmark = false,
    this.defaultPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 15,
    ),
    this.defaultTextStyle,
    this.enableLogging = false,
    this.physics,
    this.shrinkWrap = true,
    super.key,
  }) : assert(
         (tabs != null) ^ (tabValues != null && itemBuilder != null),
         'Either provide tabs list OR tabValues with itemBuilder, not both',
       );

  final List<TabItem<T>>? tabs;

  final List<T>? tabValues;
  final TabItemBuilder<T>? itemBuilder;
  final int? itemCount;

  final T selectedValue;
  final void Function(T value) onTabSelected;
  final Axis scrollDirection;
  final EdgeInsets padding;
  final double spacing;
  final Color defaultSelectedColor;
  final Color? defaultUnselectedColor;
  final Color defaultSelectedTextColor;
  final Color? defaultUnselectedTextColor;
  final double borderRadius;
  final bool showCheckmark;
  final EdgeInsets defaultPadding;
  final TextStyle? defaultTextStyle;
  final bool enableLogging;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  Color get _defaultUnselectedColor =>
      defaultUnselectedColor ?? AppColors.gray700;

  Color get _defaultUnselectedTextColor =>
      defaultUnselectedTextColor ?? AppColors.gray900;

  List<TabItem<T>> get _effectiveTabs {
    if (tabs != null) return tabs!;

    if (tabValues != null && itemBuilder != null) {
      return List.generate(
        itemCount ?? tabValues!.length,
        (index) => itemBuilder!(index, tabValues![index]),
      );
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (enableLogging) {
      log('selectedValue: $selectedValue');
      log('total tabs: ${_effectiveTabs.length}');
    }

    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      physics: physics,
      child: Container(
        padding: padding,
        child: Flex(
          direction: scrollDirection,
          mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
          children: _buildTabs(context),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    final widgets = <Widget>[];
    final effectiveTabs = _effectiveTabs;

    for (int i = 0; i < effectiveTabs.length; i++) {
      final tab = effectiveTabs[i];
      final isSelected = selectedValue == tab.value;

      widgets.add(_buildTab(context, tab, isSelected, i));
      if (i < effectiveTabs.length - 1) {
        widgets.add(_buildSpacing());
      }
    }

    return widgets;
  }

  Widget _buildSpacing() {
    return scrollDirection == Axis.horizontal
        ? SizedBox(width: spacing)
        : SizedBox(height: spacing);
  }

  Widget _buildTab(
    BuildContext context,
    TabItem<T> tab,
    bool isSelected,
    int index,
  ) {
    final selectedColor = tab.selectedColor ?? defaultSelectedColor;
    final unselectedColor = tab.unselectedColor ?? _defaultUnselectedColor;
    final selectedTextColor = tab.selectedTextColor ?? defaultSelectedTextColor;
    final unselectedTextColor =
        tab.unselectedTextColor ?? _defaultUnselectedTextColor;
    final padding = tab.padding ?? defaultPadding;

    return ChoiceChip(
      onSelected: (value) => onTabSelected(tab.value),
      showCheckmark: showCheckmark,
      padding: padding,
      side: BorderSide(color: Colors.transparent),
      labelStyle: tab.textStyle ?? defaultTextStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      label: _buildTabContent(
        context,
        tab,
        isSelected ? selectedTextColor : unselectedTextColor,
      ),
      selected: isSelected,
      selectedColor: selectedColor,
      color: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return selectedColor;
        }
        return unselectedColor;
      }),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    TabItem<T> tab,
    Color textColor,
  ) {
    final textWidget = Text(
      tab.label,
      style: (tab.textStyle ?? defaultTextStyle ?? const TextStyle()).copyWith(
        color: textColor,
      ),
    );
    if (tab.icon == null && tab.trailingIcon == null) {
      return Center(child: textWidget);
    }
    final children = <Widget>[];

    if (tab.icon != null) {
      children.add(tab.icon!);
      children.add(SizedBox(width: spacing / 2));
    }

    children.add(textWidget);

    if (tab.trailingIcon != null) {
      children.add(SizedBox(width: spacing / 2));
      children.add(tab.trailingIcon!);
    }

    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
