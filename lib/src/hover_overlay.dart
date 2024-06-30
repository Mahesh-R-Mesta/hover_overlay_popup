part of '../hover_overlay_popup.dart';

enum TriggerMode { onTap, onHover, disable }

enum Direction { left, right, bottom, top }

class HoverOverlayPopup extends StatelessWidget {
  final Widget child;
  final Size windowSize;
  final TriggerMode triggerMode;
  final Direction direction;
  final Color? color;
  final Duration hoverDuration;
  final Widget Function(Function close) builder;
  const HoverOverlayPopup(
      {super.key,
      required this.child,
      required this.builder,
      required this.windowSize,
      this.direction = Direction.right,
      this.triggerMode = TriggerMode.onHover,
      this.hoverDuration = const Duration(milliseconds: 1500),
      this.color});

  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    bool isHovering = false;
    const double spikeDepth = 15;
    const double spikeWidth = 15;
    final layerLink = LayerLink();
    final overlay = Navigator.of(context).overlay;
    OverlayEntry? entry;
    Direction dir = direction;

    void close() {
      entry?.remove();
      isActive = false;
    }

    Offset getOffSet() {
      final RenderBox button = context.findRenderObject()! as RenderBox;
      Offset offset = Offset.zero;
      final global = button.localToGlobal(Offset.zero);
      if (global.dy - (spikeDepth + windowSize.height) <= 0 && dir == Direction.top) {
        dir = Direction.bottom;
      }
      if (dir == Direction.top) {
        offset = Offset(-((windowSize.width - button.size.width) / 2), -(spikeDepth + windowSize.height));
      } else if (dir == Direction.bottom) {
        offset = Offset(-((windowSize.width - button.size.width) / 2), button.size.height + spikeDepth);
      } else if (dir == Direction.right) {
        offset = Offset(button.size.width + spikeWidth, -(windowSize.height - button.size.height) / 2);
      } else if (dir == Direction.left) {
        offset = Offset(-(spikeWidth + windowSize.width), -(windowSize.height - button.size.height) / 2);
      }
      return offset;
    }

    void open() {
      try {
        entry = OverlayEntry(
            canSizeOverlay: true,
            builder: (ctx) => Positioned(
                width: windowSize.width,
                child: CompositedTransformFollower(
                    showWhenUnlinked: false,
                    offset: getOffSet(),
                    link: layerLink,
                    child: Material(
                        color: Colors.transparent,
                        child: CustomPaint(
                            painter: CustomOverLayPainter(spikeWidth, spikeDepth, color, dir: dir, radius: 5),
                            child: Builder(builder: (context) {
                              if (TriggerMode.onHover == triggerMode) {
                                return MouseRegion(
                                    onEnter: (_) => isHovering = true,
                                    onExit: (_) {
                                      isHovering = false;
                                      if (isActive) close();
                                    },
                                    child: CustomPaint(
                                        painter: CustomOverLayPainter(spikeWidth, spikeDepth, color, dir: dir, radius: 5),
                                        child: SizedBox.fromSize(size: windowSize, child: builder(close))));
                              } else if (TriggerMode.onTap == triggerMode) {
                                return CustomPaint(
                                    painter: CustomOverLayPainter(spikeWidth, spikeDepth, color, dir: dir, radius: 5),
                                    child: SizedBox.fromSize(size: windowSize, child: builder(close)));
                              } else {
                                return const SizedBox.shrink();
                              }
                            }))))));
        overlay?.insert(entry!);
        isActive = true;
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    if (TriggerMode.onHover == triggerMode) {
      return MouseRegion(
          onEnter: (_) {
            isHovering = true;
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (!isActive && isHovering) open();
            });
          },
          onExit: (_) {
            isHovering = false;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (isActive && !isHovering) close();
            });
          },
          child: CompositedTransformTarget(link: layerLink, child: child));
    } else if (TriggerMode.onTap == triggerMode) {
      return InkWell(
          onTap: () {
            if (!isActive) {
              open();
            } else {
              close();
            }
          },
          child: CompositedTransformTarget(link: layerLink, child: child));
    } else {
      return const SizedBox.shrink();
    }
  }
}
