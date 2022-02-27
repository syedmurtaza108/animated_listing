// Copyright 2022 Syed Murtaza. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animated_listing/animated_listing.dart';
import 'package:flutter/material.dart';

///The animated widget based on Flutter built-in [ListView]
class AnimatedListingWidget extends StatefulWidget {
  ///Creates an object of [AnimatedListingWidget].
  ///
  ///
  ///[itemsCount] and [itemBuilder] are only two required parameters.
  ///
  ///*  [itemsCount] is the total length of the items that are to be rendered
  ///by this widget.
  ///* [itemBuilder] is a callback which creates the actual item widget based
  ///on index.
  ///* [animatedListingType] is the animation type that this instance will use.
  ///By default its value is `AnimatedListingType.fadeTransition`.
  ///See more [AnimatedListingType]
  ///* [animationDuration] is the duration that this instance will use during
  ///animation. The lesser the duration the faster the animation. By default its
  ///value is `Duration(milliseconds: 2000)`
  ///* [animationCurve] is the curve type that this instance will use to animate
  ///items. By default its value is `Curves.fastOutSlowIn`. See more [Curves]
  ///* [animatedResizeOptions] are only used when [animatedListingType] is
  ///[AnimatedListingType.animatedSize]. In all other cases its ignored. See
  ///more [AnimatedResizeOptions]
  ///* [physicalModeOptions] are only used when [animatedListingType] is
  ///[AnimatedListingType]. In all other cases its ignored. See
  ///more [ElevationOptions]
  ///* [separatorBuilder] is a nullable callback that this instance will use to
  ///add a seperator between rendering items. Its default value is `null` which
  ///means that no separator will be added between items.
  const AnimatedListingWidget({
    required this.itemsCount,
    required this.itemBuilder,
    this.animatedListingType = AnimatedListingType.fadeTransition,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.animationCurve = Curves.fastOutSlowIn,
    this.physicalModeOptions = const ElevationOptions(),
    this.separatorBuilder,
    this.animatedResizeOptions,
    Key? key,
  })  : assert(
          animatedListingType != AnimatedListingType.animatedSize &&
              animatedResizeOptions != null,
          resizeOptionsNotInitialized,
        ),
        super(key: key);

  final int itemsCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final AnimatedListingType animatedListingType;
  final Duration animationDuration;
  final Curve animationCurve;
  final AnimatedResizeOptions? animatedResizeOptions;
  final ElevationOptions physicalModeOptions;
  final Widget Function(BuildContext, int)? separatorBuilder;

  @override
  State<AnimatedListingWidget> createState() => _AnimatedListingWidgetState();
}

class _AnimatedListingWidgetState extends State<AnimatedListingWidget>
    with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return widget.separatorBuilder == null
        ? ListView.builder(
            itemBuilder: (_, i) => _renderItemWidget(i),
            itemCount: widget.itemsCount,
          )
        : ListView.separated(
            itemBuilder: (_, i) => _renderItemWidget(i),
            separatorBuilder: (_, i) => _renderSeparatorWidget(i),
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
        final height = _createResizeAnimation(index);
        return AnimatedBuilder(
          animation: height,
          builder: (_, __) {
            return SizedBox(
              height: height.value,
              //It is used only to avoid `RenderFlex overflowed` error
              child: SingleChildScrollView(
                child: widget.itemBuilder(context, index),
              ),
            );
          },
        );
      case AnimatedListingType.backColor:
      case AnimatedListingType.shadowColor:
      case AnimatedListingType.elevation:
        final elevation = _createShadowAnimation(index);
        return AnimatedBuilder(
          animation: elevation,
          builder: (_, __) => AnimatedPhysicalModel(
            shape: widget.physicalModeOptions.shape,
            elevation: elevation.value,
            color: widget.physicalModeOptions.boxColor,
            shadowColor: widget.physicalModeOptions.shadowColor,
            duration: widget.physicalModeOptions.animationDuration,
            child: widget.itemBuilder(context, index),
          ),
        );
    }
  }

  Widget _renderSeparatorWidget(int index) {
    switch (widget.animatedListingType) {
      case AnimatedListingType.fadeTransition:
        return FadeTransition(
          opacity: _createFadeAnimation(index),
          child: widget.separatorBuilder!(context, index),
        );
      // ignore: no_default_cases
      default:
        return widget.separatorBuilder!(context, index);
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

  Animation<double> _createResizeAnimation(int index) {
    final animation = Tween<double>(
      begin: widget.animatedResizeOptions!.initialHeight,
      end: widget.animatedResizeOptions!.finalHeight,
    ).animate(
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

  Animation<double> _createShadowAnimation(int index) {
    final animation = Tween<double>(
      begin: widget.physicalModeOptions.initialElevation,
      end: widget.physicalModeOptions.finalElevation,
    ).animate(
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
