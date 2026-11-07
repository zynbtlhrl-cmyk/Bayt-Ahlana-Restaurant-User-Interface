import 'package:bayt_ahlana_estaurant/Screen/Home/Widget.dart';
import 'package:bayt_ahlana_estaurant/Services/auth_service.dart';
import 'package:bayt_ahlana_estaurant/screens/Login.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignupPage();
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    String? error;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      error = 'يرجى ملء جميع الحقول';
    } else if (!email.contains('@') || !email.contains('.')) {
      error = 'يرجى إدخال بريد إلكتروني صحيح';
    } else if (password.length < 6) {
      error = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;
      if (result['success'] == true) {
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'فشل إنشاء الحساب')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر الاتصال بالخادم')));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4E8DA),
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: SignupBackgroundPainter()),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 24, 25, 26),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFCF8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.13),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SignupLogo(),

                          const SizedBox(height: 8),

                          const Text(
                            'بيت أهلنا',
                            style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5E402B),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'للمطاعم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFC7965C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFD7B88F),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  Icons.person_add_alt_1,
                                  color: Color(0xFFD7A665),
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFD7B88F),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5E402B),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'أنشئ حسابك واستمتع بأطيب الأكلات',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF77706A),
                            ),
                          ),

                          const SizedBox(height: 23),

                          SignupTextField(
                            controller: nameController,
                            hintText: 'الاسم الكامل',
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 13),

                          SignupTextField(
                            controller: emailController,
                            hintText: 'البريد الإلكتروني',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 13),

                          SignupTextField(
                            controller: passwordController,
                            hintText: 'كلمة المرور',
                            icon: Icons.lock_outline,
                            obscureText: obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },

                              icon: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF8C857F),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF765237),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor: const Color(0x55765237),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'إنشاء حساب',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'عندك حساب بالفعل؟',
                                style: TextStyle(
                                  color: Color(0xFF77706A),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    color: Color(0xFF765237),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
}

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 15, color: Color(0xFF4D4037)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFAAA29B), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF5F5A56)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFFFEFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDCD4CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF765237), width: 1.5),
        ),
      ),
    );
  }
}

class SignupLogo extends StatelessWidget {
  const SignupLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFF765237),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.restaurant, color: Color(0xFFD7A665), size: 43),
    );
  }
}

class SignupBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final brownPaint = Paint()..color = const Color(0xFF765237);

    final darkPaint = Paint()..color = const Color(0xFF4E3828);

    final goldPaint = Paint()
      ..color = const Color(0xFFD1A56E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final topPath = Path()
      ..moveTo(size.width * 0.48, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.30)
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.22,
        size.width * 0.60,
        size.height * 0.18,
        size.width * 0.48,
        0,
      )
      ..close();

    canvas.drawPath(topPath, brownPaint);

    final bottomPath = Path()
      ..moveTo(0, size.height * 0.84)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.91,
        size.width * 0.17,
        size.height * 0.98,
        size.width * 0.37,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(bottomPath, darkPaint);

    for (int i = 0; i < 5; i++) {
      final path = Path()
        ..moveTo(size.width * 0.35, size.height * (0.89 + i * 0.015))
        ..cubicTo(
          size.width * 0.58,
          size.height * (0.82 + i * 0.015),
          size.width * 0.75,
          size.height * (0.98 + i * 0.012),
          size.width * 1.05,
          size.height * (0.83 + i * 0.015),
        );

      canvas.drawPath(path, goldPaint);
    }

    final dotPaint = Paint()..color = const Color(0xFFD8B991);

    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(12 + col * 18, size.height * 0.48 + row * 18),
          2.5,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
