// Copyright 2022 Syed Murtaza. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

///These options are used to modify `AnimatedListingType.animatedSize` animation
class AnimatedResizeOptions {
  ///These options are used to modify `AnimatedListingType.animatedSize`
  ///animation.
  ///
  ///[finalHeight] is required
  ///
  ///* [initialHeight] is the height of the item widget when it is added in the
  ///list view
  ///* [duration] is the gap between [initialHeight] and the [finalHeight] of
  ///the item widget. Its default value is `Duration(milliseconds: 50)`
  const AnimatedResizeOptions({
    this.initialHeight = 0,
    required this.finalHeight,
    this.duration = const Duration(milliseconds: 50),
  });

  final double initialHeight;
  final double finalHeight;
  final Duration duration;
}

///These options are used to modify `AnimatedListingType.physicalMode` animation
class ElevationOptions {
  ///These options are used to modify `AnimatedListingType.physicalMode`
  ///animation.
  ///
  ///No parameter is required
  ///
  ///* [initialElevation] is the elevation of the item widget when it is added
  ///in the list view. Its default value is `5`
  ///* [finalElevation] is the elevation of the item widget after the completion
  ///of [duration]. Its default value is `10`
  ///* [duration] is the gap between [initialElevation] and the actual height of
  ///the item widget. Its default value is `Duration(milliseconds: 300)`
  const ElevationOptions({
    this.initialElevation = 0,
    this.finalElevation = 10,
    this.duration = const Duration(milliseconds: 300),
    this.shape = BoxShape.rectangle,
    this.boxColor = Colors.white,
    this.shadowColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final double initialElevation;
  final double finalElevation;
  final Duration duration;
  final BoxShape shape;
  final Color boxColor;
  final Color shadowColor;
  final Duration animationDuration;
}
