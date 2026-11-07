import 'package:bayt_ahlana_estaurant/Screen/Home/categories_section.dart';
import 'package:bayt_ahlana_estaurant/Screen/Home/meals_section.dart';
import 'package:bayt_ahlana_estaurant/Screen/my_orders_screen.dart';
import 'package:bayt_ahlana_estaurant/Services/api_malse.dart';
import 'package:bayt_ahlana_estaurant/Services/api_offers.dart';
import 'package:bayt_ahlana_estaurant/Widgets/cart_dialog_ofeers_2.dart';
import 'package:bayt_ahlana_estaurant/Widgets/cart_dialog_ofeer.dart';
import 'package:bayt_ahlana_estaurant/Widgets/restaurant_ads_banner.dart';
import 'package:bayt_ahlana_estaurant/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bayt_ahlana_estaurant/Services/api_category.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;
  int selectedIndex = 0;
  bool showAll = false;
  late Future<List<dynamic>> categories;

  //بحث
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> meals = [];

  final List<Map<String, dynamic>> offers = [];
  final List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();

    categories = CategoryService.getCategories();

    // جلب جميع الأكلات
    loadMeals();

    loadCart();
    // جلب العروض
    loadOffers();
  }

  // حفظ السلة محلياً
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('cartItems', jsonEncode(cartItems));
  }

  // استرجاع السلة عند فتح التطبيق
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCart = prefs.getString('cartItems');

    if (savedCart == null || savedCart.isEmpty) return;

    try {
      final decoded = jsonDecode(savedCart) as List;
      final restoredItems = decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .where((item) => item['type'] == 'offer')
          .toList();

      if (!mounted) return;

      setState(() {
        cartItems
          ..clear()
          ..addAll(restoredItems);
      });

      await saveCart();
      if (!mounted) return;

      setState(() {
        cartItems
          ..clear()
          ..addAll(restoredItems);
      });
    } catch (e) {
      debugPrint('خطأ في استرجاع السلة: $e');
    }
  }

  // ==============================================================
  // جلب جميع الأكلات
  // ==============================================================
  // إضافة وجبة إلى السلة وحفظها محلياً

  // طلب الوجبة العادية مباشرة بدون إضافتها إلى السلة
  Future<void> orderMealDirectly(Map<String, dynamic> meal) async {
    final mealOrder = [
      {...meal, 'type': 'meal', 'quantity': 1},
    ];

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CartDialog(cartItems: mealOrder);
      },
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الطلب بنجاح '),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // إضافة عرض خاص إلى السلة وحفظه محلياً
  Future<void> addOfferToCart(Map<String, dynamic> offer) async {
    setState(() {
      cartItems.add({...offer, 'type': 'offer'});
    });

    await saveCart();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة العرض الخاص إلى السلة'),
        backgroundColor: Color(0xFF765237),
      ),
    );
  }

  Future<void> loadMeals() async {
    try {
      final data = await MealService.getMeals();

      if (!mounted) return;

      setState(() {
        meals.clear();

        meals.addAll(List<Map<String, dynamic>>.from(data));
      });

      print('ALL MEALS: $meals');
    } catch (e) {
      print('ALL MEALS ERROR: $e');
    }
  }

  // ==============================================================
  // جلب أكلات القسم المحدد
  // ==============================================================

  Future<void> loadMealsByCategory(int categoryId) async {
    try {
      print('CATEGORY ID: $categoryId');

      final data = await MealService.getMealsByCategory(categoryId);

      if (!mounted) return;

      setState(() {
        meals.clear();

        meals.addAll(List<Map<String, dynamic>>.from(data));
      });

      print('CATEGORY MEALS: $meals');
    } catch (e) {
      print('CATEGORY MEALS ERROR: $e');
    }
  }

  // ==============================================================
  // جلب العروض
  // ==============================================================

  Future<void> loadOffers() async {
    try {
      final data = await OfferService.getOffers();

      if (!mounted) return;

      setState(() {
        offers.clear();

        offers.addAll(List<Map<String, dynamic>>.from(data));
      });

      print('ALL OFFERS: $offers');
    } catch (e) {
      print('ALL OFFERS ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F3),

        body: SafeArea(
          child: selectedIndex == 0
              ? CustomScrollView(
                  slivers: [
                    // ==================================================
                    // الهيدر
                    // ==================================================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),

                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,

                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CartDialog(cartItems: cartItems);
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
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

                                    child: Center(
                                      child: Text(
                                        cartItems.length.toString(),
                                        style: const TextStyle(
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
                                  'أطيب الأكلات .. من مطعم بيت اهلنا',

                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF806E60),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            const Icon(
                              Icons.restaurant_rounded,
                              size: 28,
                              color: Colors.brown,
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
                          child: TextField(
                            textDirection: TextDirection.rtl,

                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.trim().toLowerCase();
                              });
                            },

                            decoration: InputDecoration(
                              hintText: 'ابحث عن أكلتك المفضلة',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 30,
                                color: Color(0xFF765237),
                              ),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          searchQuery = '';
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
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
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RestaurantAdsBanner(),
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
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 15)),
                    // ==================================================
                    // الأقسام
                    // ==================================================
                    CategoriesSection(
                      categories: categories,

                      selectedCategory: selectedCategory,

                      onCategorySelected: (index, categoryId) {
                        setState(() {
                          selectedCategory = index;
                        });

                        // جلب أكلات القسم المحدد
                        loadMealsByCategory(categoryId);
                      },
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
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showAll = !showAll;
                                });
                              },
                              child: Text(
                                showAll ? 'عرض أقل' : 'عرض الكل',
                                style: const TextStyle(
                                  color: Color(0xFF765237),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==================================================
                    // الأكلات
                    // ==================================================
                    MealsSection(
                      meals: searchQuery.isNotEmpty
                          ? meals.where((meal) {
                              final name = (meal['name'] ?? '')
                                  .toString()
                                  .toLowerCase();

                              return name.contains(searchQuery);
                            }).toList()
                          : (showAll ? meals : meals.take(4).toList()),

                      onAddToCart: orderMealDirectly,
                    ),

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
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 25)),

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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),

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
                )
              : selectedIndex == 1
              ? const MyOrdersScreen()
              : const ProfileScreen(),
        ),

        // ========================================================
        // Bottom Navigation
        // ========================================================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,

          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },

          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF765237),
          unselectedItemColor: const Color(0xFF9A8D83),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'طلباتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'صفحتي',
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // بطاقة العرض
  // ==============================================================

  Widget _offerCard(Map<String, dynamic> offer) {
    final imageName = offer['image']?.toString().split('/').last ?? '';

    return Container(
      width: 310,
      margin: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C2118), Color(0xFF765237)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // ==========================================
          // الصورة
          // ==========================================
          SizedBox(
            width: 125,
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'http://127.0.0.1:8000/api/offer-image/$imageName',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('OFFER IMAGE ERROR: $error');

                    return Container(
                      color: const Color(0xFF4D3726),
                      child: const Center(
                        child: Icon(
                          Icons.local_offer_rounded,
                          size: 48,
                          color: Color(0xFFE8C985),
                        ),
                      ),
                    );
                  },
                ),

                // تدرج على الصورة
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                ),

                // شارة العرض
                Positioned(
                  top: 10,
                  left: 10,
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
          ),

          // ==========================================
          // معلومات العرض
          // ==========================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 15, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    offer['title']?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFE8C985),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // الوصف
                  Text(
                    offer['description']?.toString() ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),

                  const Spacer(),

                  // السعر
                  Text(
                    '${offer['new_price'] ?? 0} د.ع',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // السعر القديم
                  Text(
                    '${offer['old_price'] ?? 0} د.ع',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // زر اطلب الآن
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        // استخراج معرّف العرض
                        final offerId = offer['id']?.toString();

                        // التحقق إذا كان هذا العرض موجوداً مسبقاً في السلة
                        final alreadyAdded = cartItems.any((item) {
                          return item['type'] == 'offer' &&
                              item['id']?.toString() == offerId;
                        });

                        if (alreadyAdded) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'هذا العرض موجود بالسلة بالفعل، يمكنك طلبه مرة واحدة فقط',
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                          return;
                        }

                        // فتح نافذة تفاصيل العرض
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (dialogContext) {
                            return SpecialOfferDialog(offer: offer);
                          },
                        );

                        if (!mounted || result == null) return;

                        // التحقق مرة أخرى قبل الإضافة
                        final resultId = result['id']?.toString();

                        final exists = cartItems.any((item) {
                          return item['type'] == 'offer' &&
                              item['id']?.toString() == resultId;
                        });

                        if (exists) return;

                        // إضافة العرض مرة واحدة
                        await addOfferToCart({
                          ...result,
                          'type': 'offer',
                          'quantity': 1,
                        });
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8C985),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'اطلب الآن',
                          style: TextStyle(
                            color: Color(0xFF4D3726),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
