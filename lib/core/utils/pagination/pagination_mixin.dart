import 'package:flutter/material.dart';

mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  final scrollPaginationController = ScrollController();
  static const _offsetVisibleThreshold = 40;

  void onReachedLast();

  void initiatePagination() {
    scrollPaginationController.addListener(_paginationReachedEnd);
  }

  void disposePagination() {
    scrollPaginationController
      ..removeListener(_paginationReachedEnd)
      ..dispose();
  }

  void _paginationReachedEnd() {
    if (_isBottom) onReachedLast();
  }

  bool get _isBottom {
    if (!scrollPaginationController.hasClients) return false;
    final maxScroll = scrollPaginationController.position.maxScrollExtent;
    final currentScroll = scrollPaginationController.offset + _offsetVisibleThreshold;
    return currentScroll >= maxScroll;
  }
}
