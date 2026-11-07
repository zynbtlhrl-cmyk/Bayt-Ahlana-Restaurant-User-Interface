import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F3),

        appBar: AppBar(
          backgroundColor: const Color(0xFFFAF7F3),
          elevation: 0,
          centerTitle: true,

          title: const Text(
            'طلباتي',
            style: TextStyle(
              color: Color(0xFF765237),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // ==========================================
              // إذا ماكو طلبات
              // ==========================================
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,

                        decoration: BoxDecoration(
                          color: const Color(0xFFE8DED5),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 50,
                          color: Color(0xFF765237),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'لا توجد طلبات حالياً',
                        style: TextStyle(
                          color: Color(0xFF765237),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'عند تأكيد طلبك سيظهر هنا',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
