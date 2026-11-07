import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  final Future<List<dynamic>> categories;
  final int selectedCategory;
  final Function(int, int) onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 145,
        child: FutureBuilder<List<dynamic>>(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 124, 24),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'خطأ: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد أقسام حالياً',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final category = data[index];

                final bool selected = selectedCategory == index;

                final int categoryId =
                    int.tryParse(category['id'].toString()) ?? 0;

                // اسم صورة القسم
                final imageName =
                    category['image']?.toString().split('/').last ?? '';

                // رابط الصورة المباشر
                final imageUrl =
                    'http://127.0.0.1:8000/api/category-image/$imageName';

                return GestureDetector(
                  onTap: () {
                    onCategorySelected(index, categoryId);
                  },
                  child: Container(
                    width: 105,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF765237)
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: imageName.isEmpty
                              ? _buildFallbackImage()
                              : Image.network(
                                  imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('CATEGORY IMAGE URL: $imageUrl');
                                    print('CATEGORY IMAGE ERROR: $error');

                                    return _buildFallbackImage();
                                  },
                                ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          category['name']?.toString() ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selected
                                ? const Color.fromARGB(118, 0, 0, 0)
                                : const Color.fromRGBO(118, 82, 55, 1),
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
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFEDE5DC),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.restaurant_rounded,
        size: 30,
        color: Color(0xFF765237),
      ),
    );
  }
}
