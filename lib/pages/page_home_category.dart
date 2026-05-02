import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/daftar_category.dart';
import 'page_detail_category.dart';

class PageHomeCategory extends StatefulWidget {
  const PageHomeCategory({super.key});

  @override
  State<PageHomeCategory> createState() => _PageHomeCategoryState();
}

class _PageHomeCategoryState extends State<PageHomeCategory> {
  late Future<DaftarCategory> futureMeals;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    futureMeals = CategoryService.getMealsByCategory("Seafood");
  }

  void _searchMeals() {
    setState(() {
      futureMeals = CategoryService.searchMeals(_searchController.text)
          .then((list) => DaftarCategory(meals: list.map((m) {
        return Meal(
          strMeal: m['strMeal'],
          strMealThumb: m['strMealThumb'],
          idMeal: m['idMeal'],
          strArea: m['strArea'] ?? "",
          strCountry: m['strCountry'] ?? "",
        );
      }).toList()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Masakan")),
      backgroundColor: Colors.yellow,
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Cari masakan...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchMeals,
                  child: const Text("Cari"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<DaftarCategory>(
              future: futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.meals.isEmpty) {
                  return const Center(child: Text("Tidak ada data"));
                } else {
                  final meals = snapshot.data!.meals;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailCategory(idMeal: meal.idMeal),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  meal.strMealThumb,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  meal.strMeal,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "${meal.strArea} - ${meal.strCountry}",
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
