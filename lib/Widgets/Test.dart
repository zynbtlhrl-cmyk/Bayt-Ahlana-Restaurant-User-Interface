import 'package:flutter/material.dart';
import 'package:bayt_ahlana_estaurant/Services/api_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;

  late Future<List<dynamic>> categories;

  final List<Map<String, dynamic>> meals = [];

  final List<Map<String, dynamic>> offers = [];

  @override
  void initState() {
    super.initState();

    categories = CategoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F3),

        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ==================================================
              // الهيدر
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Row(
                    children: [
                      // الإشعارات
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 31,
                              color: Color(0xFF765237),
                            ),
                          ),

                          Positioned(
                            right: 4,
                            top: 2,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Column(
                        children: const [
                          Text(
                            'بيت أهلنا',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF765237),
                            ),
                          ),
                          Text(
                            'أطيب الأكلات .. من بيتنا لبيتك',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF806E60),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu_rounded,
                          size: 32,
                          color: Color(0xFF765237),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // البحث
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const TextField(
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن أكلتك المفضلة',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 30,
                          color: Color(0xFF765237),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // البانر
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF39291D), Color(0xFF765237)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 25,
                          top: 35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'أكل بيتي',
                                style: TextStyle(
                                  color: Color(0xFFE8C985),
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'بطعم لا يُنسى',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          left: 20,
                          bottom: 15,
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 100,
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 25)),

              // ==================================================
              // عنوان الأقسام
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'الأقسام',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF765237),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'عرض الكل',
                          style: TextStyle(
                            color: Color(0xFF765237),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // الأقسام
              // ==================================================
              SliverToBoxAdapter(
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

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                              });
                            },

                            child: Container(
                              width: 105,

                              margin: const EdgeInsets.only(left: 12),

                              decoration: BoxDecoration(
                                // الكارت دائماً أبيض
                                color: Colors.white,

                                // عند الاختيار يتغير الإطار فقط
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
                                  // صورة القسم
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image.network(
                                      'http://127.0.0.1:8000/storage/${category['image']}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                          },
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // اسم القسم
                                  Text(
                                    category['name'] ?? '',

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      fontSize: 14,

                                      fontWeight: FontWeight.bold,

                                      color: selected
                                          ? const Color.fromARGB(118, 0, 0, 0)
                                          : const Color.fromRGBO(
                                              118,
                                              82,
                                              55,
                                              1,
                                            ),
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
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 25)),

              // ==================================================
              // عنوان الأكلات
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'الأكلات',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF765237),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'عرض الكل',
                          style: TextStyle(color: Color(0xFF765237)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // الأكلات
              // ==================================================
              meals.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            'لا توجد أكلات حالياً',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final meal = meals[index];

                          return _mealCard(meal);
                        }, childCount: meals.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.67,
                            ),
                      ),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 25)),

              // ==================================================
              // العروض الخاصة
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'عروض خاصة',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF765237),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'عرض الكل',
                          style: TextStyle(color: Color(0xFF765237)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              offers.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            'لا توجد عروض حالياً',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        height: 180,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: offers.length,
                          itemBuilder: (context, index) {
                            final offer = offers[index];

                            return _offerCard(offer);
                          },
                        ),
                      ),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),

        // ========================================================
        // Bottom Navigation
        // ========================================================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              return;
            }

            if (index == 1) {
              // افتح صفحة طلباتي
            }

            if (index == 2) {
              // افتح صفحة صفحتي
            }
          },

          type: BottomNavigationBarType.fixed,

          backgroundColor: Colors.white,

          selectedItemColor: const Color(0xFF765237),

          unselectedItemColor: const Color(0xFF9A8D83),

          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag_rounded),
              label: 'طلباتي',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'صفحتي',
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // بطاقة الأكلة
  // ==============================================================

  Widget _mealCard(Map<String, dynamic> meal) {
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
          // صورة الأكلة
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              meal['image'] ?? '',
              height: 125,
              width: double.infinity,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 125,
                  color: const Color(0xFFEDE5DC),
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
                  meal['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D3726),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  meal['description'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 8),

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

                    Container(
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // بطاقة العرض
  // ==============================================================

  Widget _offerCard(Map<String, dynamic> offer) {
    return Container(
      width: 330,
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2118), Color(0xFF765237)],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer['name'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFFE8C985),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  offer['description'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),

                const Spacer(),

                Text(
                  'خصم ${offer['discount'] ?? 0}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 15,
            bottom: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8C985),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'اطلب الآن',
                style: TextStyle(
                  color: Color(0xFF4D3726),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
