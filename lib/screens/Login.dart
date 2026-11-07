import 'package:bayt_ahlana_estaurant/Screen/Home/Widget.dart' show HomeScreen;
import 'package:bayt_ahlana_estaurant/Services/auth_service.dart';
import 'package:bayt_ahlana_estaurant/screens/Singup.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بيت أهلنا',
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF765237)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال البريد وكلمة المرور')),
      );
      return;
    }

    try {
      final result = await AuthService.login(email: email, password: password);

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تسجيل الدخول بنجاح ')));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'البريد أو كلمة المرور غير صحيحة',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
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
            // الخلفية
            Positioned.fill(
              child: CustomPaint(painter: LoginBackgroundPainter()),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 25,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(28, 30, 28, 32),
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
                          // الشعار
                          const RestaurantLogo(),

                          const SizedBox(height: 12),

                          const Text(
                            'بيت أهلنا',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5E402B),
                              height: 1,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'للمطاعم',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC7965C),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // الخط الزخرفي
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFD7B88F),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD7B88F),
                                  shape: BoxShape.circle,
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

                          const SizedBox(height: 28),

                          const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5E402B),
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'مرحباً بك، يرجى تسجيل الدخول للمتابعة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF77706A),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // البريد الإلكتروني
                          LoginTextField(
                            controller: emailController,
                            hintText: 'البريد الإلكتروني',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 15),

                          // كلمة المرور
                          LoginTextField(
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
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF8C857F),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),

                          const SizedBox(height: 10),

                          // زر تسجيل الدخول
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF765237),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor: const Color(0x55765237),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // أو
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFE0D7CE),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'أو',
                                  style: TextStyle(
                                    color: Color(0xFF77706A),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFE0D7CE),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          // إنشاء حساب
                          SizedBox(
                            width: 240,
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.person_add_alt_1,
                                color: Color(0xFF765237),
                              ),
                              label: const Text(
                                'إنشاء حساب جديد',
                                style: TextStyle(
                                  color: Color(0xFF765237),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF765237),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
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

// ------------------------------------------------------------
// حقل تسجيل الدخول
// ------------------------------------------------------------

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const LoginTextField({
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
      style: const TextStyle(fontSize: 16, color: Color(0xFF4D4037)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFAAA29B), fontSize: 16),
        prefixIcon: Icon(icon, color: const Color(0xFF5F5A56)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFFFEFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDCD4CC), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF765237), width: 1.5),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// شعار المطعم
// ------------------------------------------------------------

class RestaurantLogo extends StatelessWidget {
  const RestaurantLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      height: 105,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // البخار
          Positioned(
            top: 0,
            child: Row(
              children: [
                Transform.rotate(
                  angle: -0.15,
                  child: Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF765237),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  width: 3,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF765237),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 7),
                Transform.rotate(
                  angle: 0.15,
                  child: Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF765237),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // الغطاء
          Positioned(
            bottom: 12,
            child: Container(
              width: 80,
              height: 62,
              decoration: const BoxDecoration(
                color: Color(0xFF765237),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(45),
                  bottom: Radius.circular(4),
                ),
              ),
            ),
          ),

          // الخط السفلي
          Positioned(
            bottom: 5,
            child: Container(
              width: 98,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFF765237),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // الشوكة والملعقة
          Positioned(
            bottom: 18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.restaurant,
                  color: Color(0xFFD7A665),
                  size: 37,
                ),
                const SizedBox(width: 2),
                Container(
                  width: 19,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7A665),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// خلفية الصفحة
// ------------------------------------------------------------

class LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final brownPaint = Paint()
      ..color = const Color(0xFF765237)
      ..style = PaintingStyle.fill;

    final darkBrownPaint = Paint()
      ..color = const Color(0xFF4E3828)
      ..style = PaintingStyle.fill;

    final goldPaint = Paint()
      ..color = const Color(0xFFD1A56E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // أعلى اليمين
    final topPath = Path();

    topPath.moveTo(size.width * 0.48, 0);
    topPath.lineTo(size.width, 0);
    topPath.lineTo(size.width, size.height * 0.34);

    topPath.cubicTo(
      size.width * 0.91,
      size.height * 0.29,
      size.width * 0.86,
      size.height * 0.20,
      size.width * 0.69,
      size.height * 0.16,
    );

    topPath.cubicTo(
      size.width * 0.56,
      size.height * 0.13,
      size.width * 0.50,
      size.height * 0.07,
      size.width * 0.48,
      0,
    );

    topPath.close();

    canvas.drawPath(topPath, brownPaint);

    // أسفل اليسار
    final bottomPath = Path();

    bottomPath.moveTo(0, size.height * 0.83);

    bottomPath.cubicTo(
      size.width * 0.10,
      size.height * 0.89,
      size.width * 0.17,
      size.height * 0.98,
      size.width * 0.37,
      size.height,
    );

    bottomPath.lineTo(0, size.height);
    bottomPath.close();

    canvas.drawPath(bottomPath, darkBrownPaint);

    // الخطوط الذهبية أسفل الصفحة
    for (int i = 0; i < 5; i++) {
      final path = Path();

      path.moveTo(size.width * 0.35, size.height * (0.89 + i * 0.015));

      path.cubicTo(
        size.width * 0.58,
        size.height * (0.82 + i * 0.015),
        size.width * 0.75,
        size.height * (0.98 + i * 0.012),
        size.width * 1.05,
        size.height * (0.83 + i * 0.015),
      );

      canvas.drawPath(path, goldPaint);
    }

    // نقاط زخرفية
    final dotPaint = Paint()
      ..color = const Color(0xFFD8B991)
      ..style = PaintingStyle.fill;

    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(12 + col * 18, size.height * 0.48 + row * 18),
          2.5,
          dotPaint,
        );
      }
    }

    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(size.width - 15 - col * 18, size.height * 0.91 + row * 14),
          2.5,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
