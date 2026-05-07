import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import 'dart:math' as math;

/// 3-page onboarding with custom illustrations, smooth transitions & premium feel
class OnboardingPage extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingPage({super.key, required this.onFinished});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _bgController;
  late final AnimationController _contentController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    widget.onFinished();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    // Onboarding data
    final pages = [
      _OnboardingData(
        icon: Icons.shopping_bag_rounded,
        accentColor: const Color(0xFF5C6BC0),
        gradientColors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
        title: l?.onboardingTitle1 ?? 'Discover Premium Products',
        subtitle: l?.onboardingSubtitle1 ??
            'Browse thousands of curated products from trusted sellers, handpicked just for you.',
        decoration: _buildShoppingDecoration,
      ),
      _OnboardingData(
        icon: Icons.local_shipping_rounded,
        accentColor: const Color(0xFF26A69A),
        gradientColors: [const Color(0xFF1A2E1A), const Color(0xFF132E20)],
        title: l?.onboardingTitle2 ?? 'Lightning-Fast Delivery',
        subtitle: l?.onboardingSubtitle2 ??
            'Track your orders in real-time. From doorstep to doorbell, we\'ve got you covered.',
        decoration: _buildDeliveryDecoration,
      ),
      _OnboardingData(
        icon: Icons.verified_rounded,
        accentColor: const Color(0xFFC5B9A8),
        gradientColors: [const Color(0xFF2E2519), const Color(0xFF1A1610)],
        title: l?.onboardingTitle3 ?? 'Secure & Trusted',
        subtitle: l?.onboardingSubtitle3 ??
            'Safe payments, verified sellers, and hassle-free returns. Shopping with confidence.',
        decoration: _buildSecurityDecoration,
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // ─── Page View ───
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
                _contentController.reset();
                _contentController.forward();
              },
              itemBuilder: (context, index) {
                final data = pages[index];
                return _buildPage(data, size);
              },
            ),

            // ─── Top Skip Button ───
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 20,
              child: AnimatedOpacity(
                opacity: _currentPage < 2 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: _completeOnboarding,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: Text(
                      l?.skip ?? 'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Bottom Controls ───
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    32, 32, 32, MediaQuery.of(context).padding.bottom + 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? pages[_currentPage].accentColor
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pages[_currentPage].accentColor,
                          foregroundColor: _currentPage == 2
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _currentPage < 2
                                ? (l?.next ?? 'Next')
                                : (l?.getStarted ?? 'Get Started'),
                            key: ValueKey(_currentPage),
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data, Size size) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (_, __) {
        final progress = CurvedAnimation(
          parent: _contentController,
          curve: Curves.easeOutCubic,
        ).value;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: data.gradientColors,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // ─── Illustration Area ───
                  Expanded(
                    flex: 5,
                    child: Opacity(
                      opacity: progress,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - progress)),
                        child: Center(
                          child: data.decoration(data.accentColor, size),
                        ),
                      ),
                    ),
                  ),

                  // ─── Text Content ───
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Opacity(
                          opacity: progress,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - progress)),
                            child: Text(
                              data.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Opacity(
                          opacity: progress,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - progress)),
                            child: Text(
                              data.subtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.6),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Space for bottom controls
                  const SizedBox(height: 130),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Custom Illustrations ───

  Widget _buildShoppingDecoration(Color accent, Size size) {
    return SizedBox(
      width: size.width * 0.75,
      height: size.width * 0.75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Transform.rotate(
              angle: _bgController.value * 2 * math.pi * 0.1,
              child: Container(
                width: size.width * 0.65,
                height: size.width * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // Inner ring
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Transform.rotate(
              angle: -_bgController.value * 2 * math.pi * 0.15,
              child: Container(
                width: size.width * 0.45,
                height: size.width * 0.45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // Floating mini icons
          ..._buildOrbitingIcons(accent, size.width * 0.3, [
            Icons.checkroom,
            Icons.watch,
            Icons.headphones,
            Icons.diamond_outlined,
          ]),
          // Center icon
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Icon(Icons.shopping_bag_rounded,
                size: 50, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDecoration(Color accent, Size size) {
    return SizedBox(
      width: size.width * 0.75,
      height: size.width * 0.75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dotted path
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => CustomPaint(
              size: Size(size.width * 0.6, size.width * 0.6),
              painter: _DottedPathPainter(
                progress: _bgController.value,
                color: accent,
              ),
            ),
          ),
          // Floating location pins
          ..._buildOrbitingIcons(accent, size.width * 0.28, [
            Icons.location_on,
            Icons.home_rounded,
            Icons.store_rounded,
            Icons.pin_drop_rounded,
          ]),
          // Center icon
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.4),
                  blurRadius: 40,
                ),
              ],
            ),
            child: const Icon(Icons.local_shipping_rounded,
                size: 50, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityDecoration(Color accent, Size size) {
    return SizedBox(
      width: size.width * 0.75,
      height: size.width * 0.75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hexagon mesh background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Transform.rotate(
              angle: _bgController.value * 2 * math.pi * 0.05,
              child: CustomPaint(
                size: Size(size.width * 0.65, size.width * 0.65),
                painter: _HexagonPainter(
                  color: accent.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
          // Shield elements
          ..._buildOrbitingIcons(accent, size.width * 0.28, [
            Icons.lock_outline,
            Icons.verified_user_outlined,
            Icons.payment_outlined,
            Icons.thumb_up_outlined,
          ]),
          // Center icon
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.4),
                  blurRadius: 40,
                ),
              ],
            ),
            child: const Icon(Icons.verified_rounded,
                size: 50, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrbitingIcons(
      Color accent, double radius, List<IconData> icons) {
    return List.generate(icons.length, (i) {
      return AnimatedBuilder(
        animation: _bgController,
        builder: (_, __) {
          final baseAngle = (2 * math.pi / icons.length) * i;
          final angle =
              baseAngle + _bgController.value * 2 * math.pi * 0.2;
          final x = math.cos(angle) * radius;
          final y = math.sin(angle) * radius;
          final bobOffset = math.sin(_bgController.value * 2 * math.pi + i) * 5;

          return Transform.translate(
            offset: Offset(x, y + bobOffset),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accent.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icons[i],
                  size: 22, color: accent.withValues(alpha: 0.8)),
            ),
          );
        },
      );
    });
  }
}

// ─── Data Model ───
class _OnboardingData {
  final IconData icon;
  final Color accentColor;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final Widget Function(Color accent, Size size) decoration;

  _OnboardingData({
    required this.icon,
    required this.accentColor,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.decoration,
  });
}

// ─── Custom Painters ───

class _DottedPathPainter extends CustomPainter {
  final double progress;
  final Color color;

  _DottedPathPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    // Draw dashed circle
    const dashCount = 40;
    for (var i = 0; i < dashCount; i++) {
      final startAngle =
          (2 * math.pi / dashCount) * i + progress * 2 * math.pi;
      final sweepAngle = (2 * math.pi / dashCount) * 0.5;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }

    // Inner dashed circle
    paint.color = color.withValues(alpha: 0.1);
    final innerRadius = size.width * 0.3;
    for (var i = 0; i < dashCount; i++) {
      final startAngle =
          (2 * math.pi / dashCount) * i - progress * 2 * math.pi * 0.5;
      final sweepAngle = (2 * math.pi / dashCount) * 0.3;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DottedPathPainter old) =>
      old.progress != progress;
}

class _HexagonPainter extends CustomPainter {
  final Color color;

  _HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric hexagons
    for (var r = 1; r <= 3; r++) {
      final radius = size.width * 0.15 * r;
      final path = Path();
      for (var i = 0; i < 6; i++) {
        final angle = (math.pi / 3) * i - math.pi / 6;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter old) => false;
}
