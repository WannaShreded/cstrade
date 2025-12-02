import 'package:flutter/material.dart';

class FloatProgress extends StatefulWidget {
  /// Float value between 0.0 and 1.0
  final double value;
  final double height;
  final Duration animationDuration;

  const FloatProgress({
    super.key,
    required this.value,
    this.height = 12.0,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  State<FloatProgress> createState() => _FloatProgressState();
}

class _FloatProgressState extends State<FloatProgress>
    with SingleTickerProviderStateMixin {
  late double _displayValue;

  @override
  void initState() {
    super.initState();
    _displayValue = 0.0;
    // delay a frame and then animate to real value for entrance micro-animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _displayValue = widget.value.clamp(0.0, 1.0));
    });
  }

  @override
  void didUpdateWidget(covariant FloatProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _displayValue = widget.value.clamp(0.0, 1.0));
    }
  }

  Color _green() => const Color(0xFF48E06B);
  Color _yellow() => const Color(0xFFF3D84B);
  Color _orange() => const Color(0xFFF39B3B);
  Color _red() => const Color(0xFFFF4D4D);

  @override
  Widget build(BuildContext context) {
    final height = widget.height;
    final thumbSize = height * 2.0; // thumb larger than track

    return SizedBox(
      height: thumbSize + 28, // room for numeric label above
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // numeric label is rendered as part of the thumb (via Stack)
          SizedBox(
            height: thumbSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final clamped = _displayValue.clamp(0.0, 1.0);
                final left = (width - thumbSize) * clamped;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // track background with soft depth
                    Positioned.fill(
                      top: (thumbSize - height) / 2,
                      bottom: (thumbSize - height) / 2,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(height),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // gradient fill
                    Positioned(
                      left: 6,
                      right: 6,
                      top: (thumbSize - height) / 2,
                      bottom: (thumbSize - height) / 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(height),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_green(), _yellow(), _orange(), _red()],
                            ),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: clamped,
                            child: Container(),
                          ),
                        ),
                      ),
                    ),

                    // neon glow overlay (subtle)
                    Positioned(
                      left: 6,
                      right: 6,
                      top: (thumbSize - height) / 2,
                      bottom: (thumbSize - height) / 2,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.06),
                                blurRadius: 18,
                                spreadRadius: 0.2,
                              ),
                              BoxShadow(
                                color: Colors.red.withOpacity(0.03),
                                blurRadius: 10,
                                spreadRadius: 0.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // animated thumb and numeric label
                    AnimatedPositioned(
                      left: left + 6,
                      duration: widget.animationDuration,
                      curve: Curves.easeOut,
                      child: Column(
                        children: [
                          // numeric label above the thumb
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900.withOpacity(0.88),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.04),
                              ),
                            ),
                            child: Text(
                              _displayValue.toStringAsFixed(4),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // thumb
                          Container(
                            width: thumbSize,
                            height: thumbSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.06),
                                ],
                                radius: 0.6,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.12),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.06),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: thumbSize * 0.46,
                                height: thumbSize * 0.46,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.75),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.06),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
