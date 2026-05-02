import 'package:flutter/material.dart';
import '../services/category_service.dart';

class PageDetailCategory extends StatefulWidget {
  final String idMeal;
  const PageDetailCategory({super.key, required this.idMeal});

  @override
  State<PageDetailCategory> createState() => _PageDetailCategoryState();
}

class _PageDetailCategoryState extends State<PageDetailCategory> {
  late Future<Map<String, dynamic>> futureDetail;

  @override
  void initState() {
    super.initState();
    futureDetail = CategoryService.getMealDetail(widget.idMeal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Masakan")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          } else {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal['strMealThumb']),
                  const SizedBox(height: 12),
                  Text(meal['strMeal'],
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("${meal['strCategory']} - ${meal['strArea']}"),
                  const SizedBox(height: 16),
                  const Text("Instruksi:",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(meal['strInstructions'] ?? ""),
                  const SizedBox(height: 16),
                  const Text("Bahan:",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...List.generate(20, (i) {
                    final ing = meal['strIngredient${i + 1}'];
                    final measure = meal['strMeasure${i + 1}'];
                    if (ing != null &&
                        ing.toString().isNotEmpty &&
                        measure != null &&
                        measure.toString().isNotEmpty) {
                      return Text("- $ing : $measure");
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
