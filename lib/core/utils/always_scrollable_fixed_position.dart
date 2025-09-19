import 'package:flutter/material.dart';

class AllwaysScrollableFixedPositionScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const AllwaysScrollableFixedPositionScrollPhysics({super.parent});

  @override
  AllwaysScrollableFixedPositionScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AllwaysScrollableFixedPositionScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (isScrolling || newPosition.extentBefore == 0) {
      return super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity,
      );
    }
    return newPosition.maxScrollExtent - oldPosition.extentAfter;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}
