import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';

class NavbarItem {
  const NavbarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class CommonNavbar extends StatefulWidget {
  const CommonNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor = AppColor.white,
    this.activeColor = AppColor.primary,
    this.inactiveColor = AppColor.textSecondary,
    this.bubbleSize = 52.0,
  }) : assert(items.length >= 3 && items.length <= 6,
            'CommonNavbar requires between 3 and 6 items');

  final List<NavbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final double bubbleSize;

  @override
  State<CommonNavbar> createState() => _CommonNavbarState();
}

class _CommonNavbarState extends State<CommonNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bubbleY;
  late Animation<double> _bubbleScale;

  int _previousIndex = 0;
  int _targetIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _targetIndex = widget.currentIndex;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _bubbleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: -1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _bubbleScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(CommonNavbar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _animateTo(widget.currentIndex);
    }
  }

  double _fractionFor(int index) {
    final count = widget.items.length;
    return (index + 0.5) / count;
  }

  void _animateTo(int index) {
    setState(() {
      _previousIndex = _targetIndex;
      _targetIndex = index;
    });

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleSize = widget.bubbleSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final fromX = _fractionFor(_previousIndex) * barWidth;
              final toX = _fractionFor(_targetIndex) * barWidth;

              // smooth horizontal slide using a curved lerp
              final slideT = CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ).value;

              final currentX = _controller.isAnimating
                  ? fromX + (toX - fromX) * slideT
                  : _fractionFor(widget.currentIndex) * barWidth;

              final bubbleLeft = currentX - bubbleSize / 2;

              // vertical offset: rises above bar then comes back
              final yOffset = _bubbleY.value * (bubbleSize * 0.55);

              return SizedBox(
                height: bubbleSize + 16,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── Navbar bar ──────────────────────────────────
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 64,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.07),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: List.generate(widget.items.length, (i) {
                            final isActive = i == widget.currentIndex;
                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => widget.onTap(i),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // placeholder space for bubble item
                                    if (isActive)
                                      SizedBox(height: bubbleSize * 0.4)
                                    else
                                      Icon(
                                        widget.items[i].icon,
                                        size: 22,
                                        color: widget.inactiveColor,
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.items[i].label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isActive
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isActive
                                            ? widget.activeColor
                                            : widget.inactiveColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    // ── Floating bubble ─────────────────────────────
                    Positioned(
                      left: bubbleLeft,
                      bottom: 64 - bubbleSize / 2 - yOffset,
                      child: Transform.scale(
                        scale: _bubbleScale.value,
                        child: Container(
                          width: bubbleSize,
                          height: bubbleSize,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.items[widget.currentIndex].icon,
                            size: 24,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
