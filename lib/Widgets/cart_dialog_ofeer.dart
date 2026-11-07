import 'package:flutter/material.dart';

class SpecialOfferDialog extends StatefulWidget {
  final Map<String, dynamic> offer;

  const SpecialOfferDialog({super.key, required this.offer});

  @override
  State<SpecialOfferDialog> createState() => _SpecialOfferDialogState();
}

class _SpecialOfferDialogState extends State<SpecialOfferDialog> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    final String title = offer['title']?.toString() ?? 'عرض خاص';

    final String description =
        offer['description']?.toString() ?? 'عرض مميز من بيت أهلنا';

    final double newPrice =
        double.tryParse(offer['new_price']?.toString() ?? '0') ?? 0;

    final double oldPrice =
        double.tryParse(offer['old_price']?.toString() ?? '0') ?? 0;

    final String imageName = offer['image']?.toString().split('/').last ?? '';

    final double total = newPrice * quantity;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F3),
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الصورة
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    child: imageName.isNotEmpty
                        ? Image.network(
                            'http://127.0.0.1:8000/api/offer-image/$imageName',
                            height: 210,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 210,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 55,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 210,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.local_offer_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),

                  // زر الإغلاق
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),

                  // شارة العرض
                  Positioned(
                    top: 15,
                    left: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF765237),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'عرض خاص ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // المحتوى
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF765237),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      description,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // الأسعار والخصم
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (oldPrice > newPrice && oldPrice > 0) ...[
                              Text(
                                '${oldPrice.toStringAsFixed(0)} د.ع',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              '${newPrice.toStringAsFixed(0)} د.ع',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF765237),
                              ),
                            ),
                          ],
                        ),
                        if (oldPrice > newPrice && oldPrice > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'خصم ${(((oldPrice - newPrice) / oldPrice) * 100).round()}%',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // الكمية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الكمية',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF765237),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: quantity > 1
                                    ? () {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.remove, size: 20),
                                color: const Color(0xFF765237),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                icon: const Icon(Icons.add, size: 20),
                                color: const Color(0xFF765237),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // المجموع
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE5DC),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF765237),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${total.toStringAsFixed(0)} د.ع',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF765237),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // إضافة العرض إلى السلة
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, {
                            'type': 'offer',
                            'id': offer['id'],
                            'title': title,
                            'description': description,
                            'price': newPrice,
                            'quantity': quantity,
                            'image': offer['image']?.toString() ?? '',
                            'total': total,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF765237),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text(
                          'إضافة إلى السلة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
