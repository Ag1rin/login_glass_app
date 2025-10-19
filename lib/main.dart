import 'dart:math'; // For sin, cos, and pi
import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Optional for modern font

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey, // Black & white theme
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const GlassLoginScreen(),
    );
  }
}

class GlassLoginScreen extends StatefulWidget {
  const GlassLoginScreen({super.key});

  @override
  State<GlassLoginScreen> createState() => _GlassLoginScreenState();
}

class _GlassLoginScreenState extends State<GlassLoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  double _animationSpeed = 1.0; // Toggle speed on tap
  late AnimationController _controller;
  late AnimationController _particlesController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  List<FloatingParticle> particles = []; // Simple floating particles as widgets
  Offset? _lastTapPosition; // Track tap position for repulsion effect
  Size? _lastScreenSize; // Track last screen size to rescale only when changed

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    ); // 60 seconds for longer loop
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
    _particlesController.repeat(); // Infinite loop every 60 seconds

    // Initialize particles with approximate size
    final random = Random();
    particles.clear();
    for (int i = 0; i < 8; i++) {
      particles.add(
        FloatingParticle(
          id: i,
          baseX: random.nextDouble() * 800, // Approximate screen width
          baseY: random.nextDouble() * 600, // Approximate screen height
          size: random.nextDouble() * 25 + 15,
          speed: 0.5, // Balanced speed: visible movement without being too slow
          phase: random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _particlesController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _lastTapPosition =
          details.localPosition; // Get tap position for repulsion
      _animationSpeed = _animationSpeed == 1.0
          ? 3.0
          : 1.0; // Toggle speed without any reset
    });
    // No animation reset - continues seamlessly
    // Reset repulsion after delay for fleeing effect
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _lastTapPosition = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Rescale particle positions only if screen size changed (e.g., mobile/desktop switch)
    if (_lastScreenSize != null &&
        (_lastScreenSize!.width != size.width ||
            _lastScreenSize!.height != size.height)) {
      for (var particle in particles) {
        particle.baseX =
            (particle.baseX / 800) * size.width; // Normalize to new width
        particle.baseY =
            (particle.baseY / 600) * size.height; // Normalize to new height
      }
    }
    _lastScreenSize = size; // Update last size

    return Scaffold(
      body: GestureDetector(
        // Tap to toggle speed and repulsion
        onTapDown: _handleTapDown,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Black & white gradient background
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Colors.grey],
                ),
              ),
            ),
            // Floating particles with smooth loop using AnimatedBuilder and Positioned
            if (particles.isNotEmpty)
              AnimatedBuilder(
                animation: _particlesController,
                builder: (context, child) {
                  return Stack(
                    children: particles.map((particle) {
                      final pos = _calculateParticlePosition(
                        particle,
                        _particlesController.value * _animationSpeed,
                        size,
                        _lastTapPosition,
                      );
                      return Positioned(
                        key: ValueKey(particle.id),
                        left: pos.dx,
                        top: pos.dy,
                        child: Container(
                          width: particle.size,
                          height: particle.size,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            // Main content with animations
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to continue',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Improved login card for beauty
                            _buildLoginCard(
                              child: Column(
                                children: [
                                  _buildGlassTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildGlassTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    icon: Icons.lock_outline,
                                    obscureText: _isObscure,
                                    onToggleObscure: () => setState(
                                      () => _isObscure = !_isObscure,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Login button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.15),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: Text(
                                        'Sign In',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Forgot password link
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to calculate position with repulsion from tap
  Offset _calculateParticlePosition(
    FloatingParticle particle,
    double animValue,
    Size screenSize,
    Offset? tapPos,
  ) {
    double swayX =
        sin(animValue * 2 * pi * particle.speed + particle.phase) *
        100; // Increased amplitude for more visible movement
    double swayY =
        cos(animValue * 2 * pi * particle.speed + particle.phase) *
        120; // Increased amplitude for more visible movement

    double posX = particle.baseX + swayX;
    double posY = particle.baseY + swayY;

    // Repulsion effect: if tap position exists, push particles away from it
    if (tapPos != null) {
      final dx = posX - tapPos.dx; // Use current posX for repulsion
      final dy = posY - tapPos.dy;
      final distance = sqrt(dx * dx + dy * dy);
      if (distance < 250 && distance > 0) {
        // Larger radius 250px for more spread
        final repulsionForce = 150 / distance; // Stronger force
        posX += (dx / distance) * repulsionForce;
        posY += (dy / distance) * repulsionForce;
      }
    }

    // Clamp to screen bounds
    posX = posX.clamp(0.0, screenSize.width - particle.size);
    posY = posY.clamp(0.0, screenSize.height - particle.size);

    return Offset(posX, posY);
  }

  // Improved method: Beautiful login card with gradient border, softer shadows, and elegance
  Widget _buildLoginCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged in successfully!')));
    }
  }
}

// Simple class for floating particle data
class FloatingParticle {
  final int id;
  double baseX, baseY; // Non-final to allow rescaling
  final double size, speed, phase;

  FloatingParticle({
    required this.id,
    required this.baseX,
    required this.baseY,
    required this.size,
    required this.speed,
    required this.phase,
  });

  double calculateX(double animValue, double screenWidth) {
    final swayX =
        sin(animValue * 2 * pi * speed + phase) *
        100; // Increased amplitude for more visible movement
    return (baseX + swayX).clamp(0.0, screenWidth - size);
  }

  double calculateY(double animValue, double screenHeight) {
    final swayY =
        cos(animValue * 2 * pi * speed + phase) *
        120; // Increased amplitude for more visible movement
    return (baseY + swayY).clamp(0.0, screenHeight - size);
  }
}
