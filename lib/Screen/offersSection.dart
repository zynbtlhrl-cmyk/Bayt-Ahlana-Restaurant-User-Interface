import 'package:flutter/material.dart';

class OffersSection extends StatelessWidget {
  final List<Map<String, dynamic>> offers;
  final Function(Map<String, dynamic>) onAddToCart;

  const OffersSection({
    super.key,
    required this.offers,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Text(
              'لا توجد عروض حالياً',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final offer = offers[index];
          return _offerCard(offer);
        }, childCount: offers.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 15,

          // زدت ارتفاع الكرت حتى لا يظهر Overflow
          childAspectRatio: 0.72,
        ),
      ),
    );
  }

  Widget _offerCard(Map<String, dynamic> offer) {
    final imageName = offer['image']?.toString().split('/').last ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // الصورة
          // =========================
          Stack(
            children: [
              SizedBox(
                height: 125,
                width: double.infinity,
                child: Image.network(
                  'http://127.0.0.1:8000/storage/offers/$imageName',
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    print('OFFER IMAGE ERROR: $error');

                    return Container(
                      color: const Color(0xFFF3F0ED),
                      child: const Center(
                        child: Icon(
                          Icons.local_offer_rounded,
                          size: 45,
                          color: Color(0xFF765237),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // تدرج أسفل الصورة
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.35),
                      ],
                    ),
                  ),
                ),
              ),

              // شارة العرض
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8C985),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'عرض',
                    style: TextStyle(
                      color: Color(0xFF4D3726),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // =========================
          // معلومات العرض
          // =========================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    offer['title']?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D3726),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // الوصف
                  Text(
                    offer['description']?.toString() ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.3,
                      color: Colors.grey,
                    ),
                  ),

                  const Spacer(),

                  // =========================
                  // السعر + السلة
                  // =========================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // الأسعار
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${offer['new_price'] ?? 0} د.ع',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9A6A2F),
                              ),
                            ),

                            const SizedBox(height: 1),

                            Text(
                              '${offer['old_price'] ?? 0} د.ع',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 6),

                      // زر السلة
                      Material(
                        color: const Color(0xFF765237),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            onAddToCart(offer);
                          },
                          child: const SizedBox(
                            width: 38,
                            height: 38,
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
