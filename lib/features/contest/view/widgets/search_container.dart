import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/contest/search_bloc/search_bloc.dart';
import 'package:learnwayv2/features/onboarding/onboarding.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class SearchWidget<T> extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.hintText,
    required this.searchFunction,
    required this.itemBuilder,
    this.emptyStateBuilder,
    this.errorBuilder,
    this.loadingWidget,
    this.padding,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.minQueryLength = 1,
    this.prefixIconPath,
    this.backgroundColor,
    this.textColor,
    this.hintColor,
    this.borderRadius,
    this.elevation,
    this.showClearButton = true,
    this.onClear,
    this.suffixIcon,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
  });

  final String hintText;
  final Future<List<T>> Function(String query) searchFunction;
  final Widget Function(T item) itemBuilder;
  final Widget Function()? emptyStateBuilder;
  final Widget Function(String error)? errorBuilder;
  final Widget? loadingWidget;
  final EdgeInsets? padding;
  final Duration debounceDuration;
  final int minQueryLength;
  final String? prefixIconPath;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintColor;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool showClearButton;
  final VoidCallback? onClear;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final FocusNode? focusNode;
  @override
  State<SearchWidget<T>> createState() => _SearchWidgetState<T>();
}

class _SearchWidgetState<T> extends State<SearchWidget<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late SearchBloc<T> _searchBloc;
  Timer? _debounceTimer;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _searchBloc = SearchBloc<T>(searchFunction: widget.searchFunction);

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _searchBloc.close();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text.trim();

    setState(() {
      _showClearButton = query.isNotEmpty;
    });

    _debounceTimer?.cancel();

    if (query.isEmpty) {
      _searchBloc.add(const SearchCleared());
      return;
    }

    if (query.length < widget.minQueryLength) {
      return;
    }

    _debounceTimer = Timer(widget.debounceDuration, () {
      _searchBloc.add(SearchQueryChanged(query));
    });
  }

  void _clearSearch() {
    _controller.clear();
    _focusNode.unfocus();
    _searchBloc.add(const SearchCleared());
    widget.onClear?.call();
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.white,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(60),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction ?? TextInputAction.search,
        style: AppTextStyles.base(
          context,
        ).copyWith(color: widget.textColor ?? Colors.black87),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.base(
            context,
          ).copyWith(color: widget.hintColor ?? AppColors.gray600),
          prefixIcon: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SvgPicture.asset(Assets.icons.searchIcon),
            ),
          ),
          suffixIcon:
              _showClearButton && widget.showClearButton
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                    onPressed: _clearSearch,
                    splashRadius: 20,
                  )
                  : widget.suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _searchBloc.add(SearchQueryChanged(value.trim()));
          }
        },
      ),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<SearchBloc<T>, SearchState<T>>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is SearchInitial<T>) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        if (state is SearchLoading<T>) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  widget.loadingWidget ??
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state is SearchError<T>) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  widget.errorBuilder?.call(state.message) ??
                  _buildDefaultErrorWidget(state.message),
            ),
          );
        }

        if (state is SearchEmpty<T>) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  widget.emptyStateBuilder?.call() ??
                  _buildDefaultEmptyWidget(state.query),
            ),
          );
        }

        if (state is SearchSuccess<T>) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return widget.itemBuilder(state.results[index]);
            }, childCount: state.results.length),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildDefaultErrorWidget(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
        const SizedBox(height: 16),
        Text(
          'Search Error',
          style: AppTextStyles.md(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: Colors.red[800]),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDefaultEmptyWidget(String query) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
        const VSpace(16),
        Text('No results found', style: AppTextStyles.base(context)),
        const VSpace(8),
        Text(
          'Try searching with different keywords',
          style: AppTextStyles.base(context).copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearchField()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildResults(),
        ],
      ),
    );
  }
}
