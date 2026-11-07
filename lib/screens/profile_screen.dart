import 'dart:convert';

import 'package:bayt_ahlana_estaurant/Screen/my_orders_screen.dart';
import 'package:bayt_ahlana_estaurant/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const brown = Color(0xFF765237);

  String userName = '';
  String userEmail = '';

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // جلب بيانات المستخدم من Laravel
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            errorMessage = 'يرجى تسجيل الدخول أولاً';
          });
        }
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('USER API STATUS: ${response.statusCode}');
      debugPrint('USER API RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];

        if (mounted) {
          setState(() {
            userName = user['name']?.toString() ?? '';
            userEmail = user['email']?.toString() ?? '';
            errorMessage = null;
          });
        }
      } else if (mounted) {
        setState(() {
          errorMessage = response.statusCode == 401
              ? 'انتهت جلسة تسجيل الدخول، يرجى تسجيل الدخول مجدداً'
              : 'حدث خطأ أثناء جلب بيانات الحساب';
        });
      }
    } catch (e) {
      debugPrint('USER DATA ERROR: $e');

      if (mounted) {
        setState(() {
          errorMessage = 'تعذر الاتصال بالخادم';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F3),

        appBar: AppBar(
          title: const Text(
            'صفحتي الشخصية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFFAF7F3),
          elevation: 0,
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: brown))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 15),

                  // الصورة الشخصية
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: brown, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundColor: Color(0xFFEDE2D5),
                        child: Icon(Icons.person, size: 60, color: brown),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // اسم المستخدم
                  Center(
                    child: Text(
                      userName.isEmpty ? 'مستخدم بيت أهلنا' : userName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: brown,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // جيميل المستخدم
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 17,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            userEmail.isEmpty
                                ? 'لا يوجد بريد إلكتروني'
                                : userEmail,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (errorMessage != null) ...[
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          loadUserData();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ),
                  ],

                  const SizedBox(height: 25),

                  const Text(
                    'حسابك الشخصي في مطعم بيت أهلنا',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: brown),
                  ),

                  const SizedBox(height: 25),

                  // طلباتي
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long, color: brown),
                      title: const Text('طلباتي'),
                      trailing: const Icon(Icons.chevron_left),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.9,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                                child: const MyOrdersScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // حول التطبيق
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.info_outline, color: brown),
                      title: const Text('حول التطبيق'),
                      trailing: const Icon(Icons.chevron_left),

                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.85,
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFAF7F3),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    const Text(
                                      'حول التطبيق',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF765237),
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    Expanded(
                                      child: ListView(
                                        children: [
                                          // واجهة المطعم
                                          Container(
                                            padding: const EdgeInsets.all(22),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF39291D),
                                                  Color(0xFF765237),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.restaurant,
                                                    size: 40,
                                                    color: Color(0xFF765237),
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  'مطعم بيت أهلنا',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 6),
                                                Text(
                                                  'أطيب الأكلات .. من مطعم بيت أهلنا',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          // نبذة عنا
                                          _aboutCard(
                                            icon: Icons.info_outline,
                                            title: 'نبذة عنا',
                                            description:
                                                'مطعم بيت أهلنا يقدم لكم أشهى المأكولات '
                                                'بنكهة مميزة واهتمام بالجودة، ونسعى دائماً '
                                                'لتقديم أفضل تجربة لزبائننا.',
                                          ),

                                          // معلومات المطعم
                                          _aboutCard(
                                            icon: Icons.location_on_outlined,
                                            title: 'عنوان المطعم',
                                            description: 'تلعفر - العراق',
                                          ),

                                          _aboutCard(
                                            icon: Icons.phone_outlined,
                                            title: 'رقم الهاتف',
                                            description:
                                                'يمكنك التواصل معنا عبر رقم المطعم',
                                          ),

                                          _aboutCard(
                                            icon: Icons.access_time,
                                            title: 'أوقات العمل',
                                            description:
                                                'نستقبلكم يومياً بكل حب',
                                          ),

                                          // خدماتنا
                                          _aboutCard(
                                            icon: Icons.room_service_outlined,
                                            title: 'خدماتنا',
                                            description:
                                                'وجبات متنوعة، عروض خاصة، واستقبال طلبات الطعام '
                                                'بسهولة من خلال التطبيق.',
                                          ),

                                          const SizedBox(height: 15),

                                          const Center(
                                            child: Text(
                                              'بيت أهلنا © 2026',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_left,
                        color: Colors.red,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('تسجيل الخروج'),
                              content: const Text(
                                'هل أنت متأكد من تسجيل الخروج؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    logoutUser();
                                  },
                                  child: const Text(
                                    'تسجيل الخروج',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _aboutCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEDE2D5),
            child: Icon(icon, color: const Color(0xFF765237)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF765237),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_token');
    await prefs.remove('user');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
