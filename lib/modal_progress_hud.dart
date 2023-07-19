import 'package:flutter/material.dart';

/// {@template modal_progress_hud}
///
/// Wrap around any widget that makes an async call to show a modal progress
/// indicator while the async call is in progress.
///
/// The progress indicator can be turned on or off using [inAsyncCall]
///
/// The progress indicator defaults to a [CircularProgressIndicator] but can be
/// any kind of widget
///
/// The progress indicator can be positioned using [offset] otherwise it is
/// centered
///
/// The modal barrier can be dismissed using [dismissible]
///
/// The color of the modal barrier can be set using [color]
///
/// The opacity of the modal barrier can be set using [opacity]
///
/// HUD=Heads Up Display
///
/// {@endtemplate}
class ModalProgressHud extends StatelessWidget {
  /// {@macro modal_progress_hud}
  const ModalProgressHud({
    required this.inAsyncCall,
    required this.child,
    super.key,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
  });

  /// Represents if the widget is in async call.
  /// If `true` shows the ModalProgressHud, else show the [child]
  final bool inAsyncCall;

  /// The Opacity of [ModalBarrier] used to show progress.
  ///
  /// An opacity of 1.0 is fully opaque.
  /// An opacity of 0.0 is fully transparent (i.e., invisible).
  ///
  /// Defaults to 0.3
  final double opacity;

  /// The [Color] of the [ModalBarrier] used to show progress.
  /// Default to [Colors.grey]
  final Color color;

  /// The [Widget] to show while in async call to indicate progress.
  /// Defaults to [CircularProgressIndicator]
  final Widget progressIndicator;

  /// The progress indicator can be positioned using [offset] otherwise it is
  /// centered
  final Offset? offset;

  /// Indicates if the [ModalBarrier] can be dismissed. Default to `false`
  final bool dismissible;

  /// The [Widget] to be shown when not in async call and to be wrapped with
  /// [ModalBarrier] when in async call
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final layOutProgressIndicator = switch (offset) {
      null => Center(
          child: progressIndicator,
        ),
      Offset() => Positioned(
          left: offset?.dx,
          top: offset?.dy,
          child: progressIndicator,
        ),
    };

    return Stack(
      children: [
        child,
        if (inAsyncCall) ...[
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: dismissible, color: color),
          ),
          layOutProgressIndicator,
        ],
      ],
    );
  }
}
