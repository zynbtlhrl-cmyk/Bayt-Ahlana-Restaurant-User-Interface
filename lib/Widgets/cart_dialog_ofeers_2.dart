import 'package:bayt_ahlana_estaurant/Services/api_order.dart';
import 'package:flutter/material.dart';

class CartDialog extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartDialog({super.key, required this.cartItems});

  @override
  State<CartDialog> createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  int currentStep = 0;
  final Set<int> selectedIndices = {};

  late List<Map<String, dynamic>> cartItems;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isSending = false;

  static const Color brown = Color(0xFF765237);
  static const Color orange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFE0B2);
  static const Color background = Color(0xFFFAF7F3);

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    // إذا كان الطلب المباشر صنفاً واحداً، حدده تلقائياً.
    if (cartItems.length == 1) {
      selectedIndices.add(0);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get selectedCartItems {
    return selectedIndices
        .where((index) => index >= 0 && index < cartItems.length)
        .toList()
        .map((index) => cartItems[index])
        .toList();
  }

  bool get isOfferOrder {
    return selectedCartItems.isNotEmpty &&
        selectedCartItems.every((item) => item['type']?.toString() == 'offer');
  }

  double get totalPrice {
    double total = 0;
    for (final item in selectedCartItems) {
      final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
      final quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
      total += price * quantity;
    }
    return total;
  }

  int get totalSelectedQuantity {
    return selectedCartItems.fold<int>(0, (sum, item) {
      return sum + (int.tryParse(item['quantity']?.toString() ?? '1') ?? 1);
    });
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  void toggleSelectAll() {
    setState(() {
      if (selectedIndices.length == cartItems.length) {
        selectedIndices.clear();
      } else {
        selectedIndices
          ..clear()
          ..addAll(List<int>.generate(cartItems.length, (index) => index));
      }
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      final quantity =
          int.tryParse(cartItems[index]['quantity']?.toString() ?? '1') ?? 1;
      cartItems[index]['quantity'] = quantity + 1;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      final quantity =
          int.tryParse(cartItems[index]['quantity']?.toString() ?? '1') ?? 1;
      if (quantity > 1) {
        cartItems[index]['quantity'] = quantity - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: Container(
          key: ValueKey(currentStep),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
            maxWidth: 520,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: currentStep == 0 ? _cartView() : _checkoutView(),
        ),
      ),
    );
  }

  Widget _cartView() {
    final allSelected =
        cartItems.isNotEmpty && selectedIndices.length == cartItems.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightOrange,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: brown),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'سلة المشتريات',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
            ),
            IconButton(
              tooltip: 'إغلاق',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (cartItems.isNotEmpty)
          Row(
            children: [
              Text(
                'المحدد: ${selectedIndices.length} من ${cartItems.length}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: toggleSelectAll,
                icon: Icon(
                  allSelected
                      ? Icons.deselect
                      : Icons.library_add_check_outlined,
                  size: 18,
                ),
                label: Text(allSelected ? 'إلغاء التحديد' : 'تحديد الكل'),
                style: TextButton.styleFrom(foregroundColor: orange),
              ),
            ],
          ),
        const SizedBox(height: 4),
        Flexible(
          child: cartItems.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_shopping_cart_outlined,
                          size: 55,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text('السلة فارغة', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) =>
                      _cartItem(cartItems[index], index),
                ),
        ),
        const Divider(height: 22),
        Row(
          children: [
            const Expanded(
              child: Text(
                'مجموع المحدد',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${totalPrice.toStringAsFixed(2)} د.ع',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: selectedIndices.isEmpty
                ? null
                : () => setState(() => currentStep = 1),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text('متابعة الطلب (${selectedIndices.length})'),
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cartItem(Map<String, dynamic> item, int index) {
    final isSelected = selectedIndices.contains(index);
    final isOffer = item['type']?.toString() == 'offer';
    final imageName = (item['image']?.toString() ?? '').split('/').last;
    final title =
        item['title']?.toString() ?? item['name']?.toString() ?? 'أكلة';
    final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    final quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

    return GestureDetector(
      onTap: () => toggleSelection(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? lightOrange : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? orange : Colors.grey.shade200,
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: orange.withOpacity(0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                isOffer
                    ? 'http://127.0.0.1:8000/api/offer-image/$imageName'
                    : 'http://127.0.0.1:8000/api/meal-image/$imageName',
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 62,
                    height: 62,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isOffer
                          ? const Color(0xFFFFE0B2)
                          : const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      isOffer ? 'عرض خاص' : 'طلب عادي',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isOffer ? Colors.deepOrange : Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${price.toStringAsFixed(2)} د.ع',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: brown,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _quantityButton(
                      icon: Icons.remove,
                      onPressed: () => decreaseQuantity(index),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _quantityButton(
                      icon: Icons.add,
                      onPressed: () => increaseQuantity(index),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? orange : Colors.grey.shade400,
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
          border: Border.all(color: orange.withOpacity(0.45)),
        ),
        child: Icon(icon, size: 16, color: brown),
      ),
    );
  }

  Widget _checkoutView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => currentStep = 0),
              icon: const Icon(Icons.arrow_back),
            ),
            const Expanded(
              child: Text(
                'إكمال الطلب',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مراجعة طلبك',
                style: TextStyle(fontWeight: FontWeight.bold, color: brown),
              ),
              const SizedBox(height: 6),
              ...selectedCartItems.map((item) {
                final name =
                    item['title']?.toString() ??
                    item['name']?.toString() ??
                    'أكلة';
                final qty =
                    int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
                final price =
                    double.tryParse(item['price']?.toString() ?? '0') ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$name × $qty',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${(price * qty).toStringAsFixed(2)} د.ع'),
                    ],
                  ),
                );
              }),
              const Divider(),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'المجموع الكلي',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${totalPrice.toStringAsFixed(2)} د.ع',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: brown,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _field(
                  controller: nameController,
                  icon: Icons.person_outline,
                  label: 'الاسم الكامل',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                _field(
                  controller: phoneController,
                  icon: Icons.phone_outlined,
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                _field(
                  controller: addressController,
                  icon: Icons.location_on_outlined,
                  label: 'العنوان بالتفصيل',
                  maxLines: 2,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                _field(
                  controller: notesController,
                  icon: Icons.note_alt_outlined,
                  label: 'ملاحظات (اختياري)',
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isSending ? null : _sendOrder,
            icon: isSending
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.verified_outlined),
            label: Text(
              isSending ? 'جارٍ إرسال الطلب...' : 'تأكيد الطلب',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.orange.shade200,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendOrder() async {
    if (isSending) return;

    if (selectedCartItems.isEmpty) {
      _showMessage('يرجى تحديد طلب واحد على الأقل');
      setState(() => currentStep = 0);
      return;
    }

    if (nameController.text.trim().isEmpty) {
      _showMessage('يرجى كتابة الاسم');
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      _showMessage('يرجى كتابة رقم الهاتف');
      return;
    }

    if (addressController.text.trim().isEmpty) {
      _showMessage('يرجى كتابة العنوان');
      return;
    }

    setState(() => isSending = true);

    try {
      final foodNames = selectedCartItems
          .map((item) {
            final name = item['title'] ?? item['name'] ?? 'أكلة';
            final isOffer = item['type']?.toString() == 'offer';

            return isOffer ? '$name (عرض خاص)' : '$name (طلب عادي)';
          })
          .join('، ');

      final success = await OrderService.createOrder(
        customerName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        foodName: foodNames,
        quantity: totalSelectedQuantity,
        totalPrice: totalPrice,
        orderType: isOfferOrder ? 'offer' : 'normal',
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => isSending = false);
        _showMessage('فشل إرسال الطلب، حاول مرة أخرى');
      }
    } catch (error) {
      if (!mounted) return;

      setState(() => isSending = false);
      debugPrint('SEND ORDER ERROR: $error');
      _showMessage('حدث خطأ أثناء إرسال الطلب');
    }
  }

  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: brown),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.brown.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: orange, width: 1.5),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
