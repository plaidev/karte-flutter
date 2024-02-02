import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:karte_visual_tracking/karte_visual_tracking.dart';

class VisualTrackingWidget extends SingleChildRenderObjectWidget {
  VisualTrackingWidget({Key? key, Widget? child})
      : super(key: key, child: RepaintBoundary(child: child));

  @override
  _RenderVisualTracking createRenderObject(BuildContext context) {
    return _RenderVisualTracking();
  }
}

class _RenderVisualTracking extends RenderConstrainedBox {
  _RenderVisualTracking()
      : super(additionalConstraints: const BoxConstraints.expand());

  @override
  bool hitTestSelf(Offset position) => true;

  BoxHitTestResult? _hitTestResult;
  OffsetPair? _initialPosition;
  int? _primaryPointer;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    _hitTestResult = result;
    return super.hitTest(result, position: position);
  }

  double _getGlobalDistance(PointerEvent event, OffsetPair initialPosition) {
    final Offset offset = event.position - initialPosition.global;
    return offset.distance;
  }

  @override
  Future<void> handleEvent(PointerEvent event, BoxHitTestEntry entry) async {
    if (event is PointerDownEvent) {
      _primaryPointer = event.pointer;
      _initialPosition =
          OffsetPair(local: event.localPosition, global: event.position);
    } else if (event is PointerSignalEvent) {
      _initialPosition = null;
      _primaryPointer = null;
    }

    if (event is! PointerUpEvent) {
      return;
    }

    final initialPosition = _initialPosition;
    final primaryPointer = _primaryPointer;
    _initialPosition = null;
    _primaryPointer = null;

    if (initialPosition == null) {
      return;
    }
    if (primaryPointer != event.pointer) {
      return;
    }
    if (_getGlobalDistance(event, initialPosition) > 18) {
      return;
    }

    final hitTestResult = _hitTestResult;
    if (hitTestResult == null) {
      return;
    }

    String actionId = "";
    RenderPointerListener? renderPointerListener;
    RenderRepaintBoundary? renderRepaintBoundary;
    bool foundRenderVisualTracking = false;
    bool foundRenderMouseRegion = false;

    final renderObjectList = hitTestResult.path
        .toList()
        .reversed
        .map((e) => e.target)
        .skipWhile((value) => value is! _RenderVisualTracking)
        .whereType<RenderObject>()
        .toList();

    for (final renderObject in renderObjectList) {
      if (!foundRenderVisualTracking &&
          renderObject is! _RenderVisualTracking) {
        continue;
      }
      foundRenderVisualTracking = true;

      actionId += "-" + renderObject.generateActioinId();

      if (renderRepaintBoundary == null) {
        if (renderObject is RenderRepaintBoundary) {
          renderRepaintBoundary = renderObject;
        }
        continue;
      }

      if (!foundRenderMouseRegion && renderObject is! RenderMouseRegion) {
        continue;
      }
      foundRenderMouseRegion = true;

      if (renderObject is! RenderPointerListener) {
        continue;
      }

      renderPointerListener = renderObject;
      break;
    }

    if (renderPointerListener == null || renderRepaintBoundary == null) {
      return;
    }

    VisualTracking.handle(
        action: "onTap",
        targetText: "",
        actionId: actionId,
        renderRepaintBoundary: renderRepaintBoundary,
        offset: renderPointerListener.localToGlobal(Offset.zero),
        size: renderPointerListener.size);
  }
}

extension _ActionIdGenerator on RenderObject {
  String generateActioinId() {
    final type = runtimeType.toString();

    final myParent = parent;
    if (myParent is! RenderObject) {
      return type;
    }

    bool found = false;
    int count = 0;
    myParent.visitChildren((child) {
      if (found || child == this) {
        found = true;
        return;
      }
      count += 1;
    });
    return "$type@$count";
  }
}

class KarteNavigatorObserver extends NavigatorObserver {
  Future<void> didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    final context = route.navigator?.context;

    if (route is! MaterialRouteTransitionMixin) {
      return;
    }
    await Future.delayed(route.transitionDuration);

    final screenName = route.settings.name;
    if (screenName == null) {
      return;
    }

    RenderRepaintBoundary? renderRepaintBoundary =
        context?.findAncestorRenderObjectOfType<RenderRepaintBoundary>();
    if (renderRepaintBoundary == null) {
      return;
    }

    VisualTracking.handle(
      action: "didPush",
      targetText: "",
      actionId: screenName,
      renderRepaintBoundary: renderRepaintBoundary,
    );
  }

  Future<void> didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    final context = previousRoute?.navigator?.context;

    if (previousRoute == null ||
        previousRoute is! MaterialRouteTransitionMixin) {
      return;
    }
    await Future.delayed(previousRoute.transitionDuration);

    final screenName = previousRoute.settings.name;
    if (screenName == null) {
      return;
    }

    RenderRepaintBoundary? renderRepaintBoundary =
        context?.findAncestorRenderObjectOfType<RenderRepaintBoundary>();

    VisualTracking.handle(
      action: "didPop",
      targetText: "",
      actionId: screenName,
      renderRepaintBoundary: renderRepaintBoundary,
    );
  }
}
