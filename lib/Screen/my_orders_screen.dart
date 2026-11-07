import 'package:flutter/material.dart';
import 'package:bayt_ahlana_estaurant/Services/api_order.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  static const Color brown = Color(0xFF765237);
  static const Color background = Color(0xFFFAF7F3);

  late Future<List<dynamic>> ordersFuture;
  final Set<int> cancellingOrders = {};

  @override
  void initState() {
    super.initState();
    ordersFuture = OrderService.getOrders();
  }

  Future<void> refreshOrders() async {
    final future = OrderService.getOrders();

    setState(() {
      ordersFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'طلباتي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: brown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: brown),
                  );
                }

                if (snapshot.hasError) {
                  return _emptyState(
                    icon: Icons.wifi_off_rounded,
                    title: 'تعذر تحميل الطلبات',
                    subtitle: 'تحقق من الاتصال وحاول مرة أخرى',
                    actionText: 'إعادة المحاولة',
                    onAction: refreshOrders,
                  );
                }

                final orders = snapshot.data ?? [];

                if (orders.isEmpty) {
                  return RefreshIndicator(
                    color: brown,
                    onRefresh: refreshOrders,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 110),
                        _emptyState(
                          icon: Icons.receipt_long_rounded,
                          title: 'ما عندك طلبات حالياً',
                          subtitle: 'اختار أكلتك المفضلة من مطعم بيت أهلنا',
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: brown,
                  onRefresh: refreshOrders,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = Map<String, dynamic>.from(
                        orders[index] as Map,
                      );

                      return _orderCard(order);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    Future<void> Function()? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: brown.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: brown, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D3726),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionText),
                style: OutlinedButton.styleFrom(foregroundColor: brown),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final int orderId = int.tryParse(order['id']?.toString() ?? '') ?? 0;

    final String status =
        order['status']?.toString().toLowerCase() ?? 'pending';

    final dynamic rawItems = order['items'];
    final List<dynamic> items = rawItems is List ? rawItems : [];

    final bool canCancel = status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 22, left: 3, right: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFD8B77A), Color(0xFF765237), Color(0xFF3E2B20)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: brown.withOpacity(0.20),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCF7),
          borderRadius: BorderRadius.circular(23),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس الطلب
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF765237), Color(0xFF3E2B20)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFFFFE2A5),
                    size: 27,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طلب رقم #$orderId',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2B20),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _formatDate(order['created_at']),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: brown.withOpacity(0.12)),
                  ),
                  child: _statusBadge(status),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // عنوان المنتجات
            Row(
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  color: brown,
                  size: 19,
                ),
                const SizedBox(width: 7),
                const Text(
                  'تفاصيل الطلب',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF765237),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // المنتجات
            if (items.isNotEmpty)
              ...items.map((item) {
                final meal = Map<String, dynamic>.from(item);
                return _productRow(meal);
              })
            else
              _productRow(order),

            const SizedBox(height: 12),

            Divider(color: brown.withOpacity(0.18), thickness: 1),

            // المبلغ الكلي
            Row(
              children: [
                const Icon(
                  Icons.payments_rounded,
                  color: Color(0xFF765237),
                  size: 23,
                ),
                const SizedBox(width: 8),
                const Text(
                  'المبلغ الكلي',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2B20),
                  ),
                ),
                const Spacer(),
                Text(
                  '${order['total_price'] ?? '0'} د.ع',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF765237),
                  ),
                ),
              ],
            ),

            // إلغاء الطلب
            if (canCancel) ...[
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: cancellingOrders.contains(orderId)
                      ? null
                      : () => _confirmCancelOrder(order),
                  icon: cancellingOrders.contains(orderId)
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.delete_outline_rounded, size: 20),
                  label: Text(
                    cancellingOrders.contains(orderId)
                        ? 'جاري الإلغاء...'
                        : 'إلغاء الطلب',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB83232),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _productRow(Map<String, dynamic> product) {
    final String name =
        product['name']?.toString() ??
        product['food_name']?.toString() ??
        product['meal_name']?.toString() ??
        product['offer_name']?.toString() ??
        'طلب مطعم';

    final String quantity = product['quantity']?.toString() ?? '1';

    final String? imageUrl = _getImageUrl(product);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              width: 72,
              height: 72,
              color: background,
              child: imageUrl == null
                  ? const Icon(Icons.restaurant_rounded, color: brown, size: 32)
                  : Image.network(
                      imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.restaurant_rounded,
                          color: brown,
                          size: 32,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D3726),
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'الكمية: $quantity',
                    style: const TextStyle(color: brown, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _getImageUrl(Map<String, dynamic> product) {
    final rawImage =
        product['image']?.toString() ??
        product['image_url']?.toString() ??
        product['meal_image']?.toString() ??
        product['offer_image']?.toString() ??
        '';

    if (rawImage.trim().isEmpty) return null;

    // إذا الرابط كامل نستخدمه مباشرة
    if (rawImage.startsWith('http://') || rawImage.startsWith('https://')) {
      return rawImage;
    }

    // استخراج اسم الصورة فقط
    final imageName = rawImage.split('/').last.trim();

    if (imageName.isEmpty) return null;

    // تحديد نوع الطلب
    final isOffer =
        product['order_type']?.toString().toLowerCase() == 'offer' ||
        product['type']?.toString().toLowerCase() == 'offer';

    final endpoint = isOffer ? 'offer-image' : 'meal-image';

    return 'http://127.0.0.1:8000/api/$endpoint/$imageName';
  }

  Widget _statusBadge(String status) {
    final Color color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _statusText(status),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancelOrder(Map<String, dynamic> order) async {
    final int? orderId = int.tryParse(order['id']?.toString() ?? '');

    if (orderId == null) {
      _showMessage('رقم الطلب غير صحيح');
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            Icons.warning_amber_rounded,
            size: 46,
            color: Colors.red.shade600,
          ),
          title: const Text(
            'تأكيد إلغاء الطلب',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'هل تريد إلغاء هذا الطلب؟ لا يمكن التراجع بعد تأكيد الإلغاء.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('رجوع', style: TextStyle(color: brown)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('نعم، إلغاء الطلب'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => cancellingOrders.add(orderId));

    final bool success = await OrderService.cancelOrder(orderId);

    if (!mounted) return;

    setState(() => cancellingOrders.remove(orderId));

    if (success) {
      await refreshOrders();
      if (!mounted) return;
      _showMessage('تم إلغاء الطلب بنجاح');
    } else {
      _showMessage('تعذر إلغاء الطلب. تحقق من مسار الإلغاء في Laravel.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        behavior: SnackBarBehavior.floating,
        backgroundColor: brown,
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return '';

    try {
      final date = DateTime.parse(value.toString()).toLocal();

      return '${date.year}/${date.month.toString().padLeft(2, '0')}/'
          '${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return value.toString();
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade800;
      case 'shipping':
        return Colors.blue.shade700;
      case 'delivered':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'shipping':
        return 'قيد التوصيل';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
