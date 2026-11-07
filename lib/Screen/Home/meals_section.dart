import 'package:flutter/material.dart';

class MealsSection extends StatelessWidget {
  final List<Map<String, dynamic>> meals;
  final Future<void> Function(Map<String, dynamic>) onAddToCart;

  const MealsSection({
    super.key,
    required this.meals,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Text(
              'لا توجد أكلات حالياً',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _mealCard(context, meals[index]),
          childCount: meals.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 15,
          childAspectRatio: 0.67,
        ),
      ),
    );
  }

  Widget _mealCard(BuildContext context, Map<String, dynamic> meal) {
    final imageName = meal['image']?.toString().split('/').last ?? '';

    final imageUrl = 'http://127.0.0.1:8000/api/meal-image/$imageName';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 125,
                  color: const Color(0xFFEFEDED),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 50,
                    color: Color(0xFF765237),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name']?.toString() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D3726),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  meal['description']?.toString() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Text(
                      '${meal['price'] ?? 0} د.ع',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9A6A2F),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => onAddToCart(meal),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF765237),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
