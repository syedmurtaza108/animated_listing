// Copyright 2022 Syed Murtaza. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animated_listing/src/animated_listing_types.dart';
import 'package:flutter/material.dart';

///The animated widget based on Flutter built-in [ListView]. [itemsCount] is 
///the total length of the items that are to be rendered by this widget.
class AnimatedListingWidget extends StatefulWidget {
  const AnimatedListingWidget({
    required this.itemsCount,
    required this.itemBuilder,
    this.animatedListingType = AnimatedListingType.fadeTransition,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.animationCurve = Curves.fastOutSlowIn,
    this.separatorBuilder,
    Key? key,
  }) : super(key: key);

  final int itemsCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Duration animationDuration;
  final Curve animationCurve;
  final AnimatedListingType animatedListingType;

  @override
  State<AnimatedListingWidget> createState() => _AnimatedListingWidgetState();
}

class _AnimatedListingWidgetState extends State<AnimatedListingWidget>
    with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  double? _height = 0;

  @override
  Widget build(BuildContext context) {
    return widget.separatorBuilder == null
        ? ListView.builder(
            itemBuilder: (_, i) => _renderItemWidget(i),
            itemCount: widget.itemsCount,
          )
        : ListView.separated(
            itemBuilder: (_, i) => _renderItemWidget(i),
            separatorBuilder: widget.separatorBuilder!,
            itemCount: widget.itemsCount,
          );
  }

  Widget _renderItemWidget(int index) {
    switch (widget.animatedListingType) {
      case AnimatedListingType.fadeTransition:
        return FadeTransition(
          opacity: _createFadeAnimation(index),
          child: widget.itemBuilder(context, index),
        );
      case AnimatedListingType.animatedSize:
        Future<void>.delayed(
          const Duration(milliseconds: 100),
          () => setState(() => _height = null),
        );
        return AnimatedSize(
          duration: widget.animationDuration,
          child: SizedBox(
            height: _height,
            child: widget.itemBuilder(context, index),
          ),
        );
    }
  }

  Animation<double> _createFadeAnimation(int index) {
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          (1 / widget.itemsCount) * index,
          1,
          curve: widget.animationCurve,
        ),
      ),
    );
    animationController.forward();
    return animation;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
