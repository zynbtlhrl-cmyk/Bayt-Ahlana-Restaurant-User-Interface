import 'package:flutter/material.dart';
import 'package:bayt_ahlana_estaurant/Services/api_category.dart';

class CategoriesTestScreen extends StatefulWidget {
  const CategoriesTestScreen({super.key});

  @override
  State<CategoriesTestScreen> createState() => _CategoriesTestScreenState();
}

class _CategoriesTestScreenState extends State<CategoriesTestScreen> {
  late Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();

    categories = CategoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: categories,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('جاري جلب البيانات...'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,

            itemBuilder: (context, index) {
              final category = data[index];

              return Text(
                category.toString(),
                style: const TextStyle(fontSize: 20),
              );
            },
          );
        },
      ),
    );
  }
}
