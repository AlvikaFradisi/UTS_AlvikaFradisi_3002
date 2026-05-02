import 'package:flutter/material.dart';
import '../models/daftar_category.dart';
import 'page_detail_category.dart';

class PageListCategory extends StatelessWidget {
  final List<Meal> meals;
  const PageListCategory({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return ListTile(
          leading: Image.network(meal.strMealThumb, width: 60),
          title: Text(meal.strMeal),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${meal.strArea} - ${meal.strCountry}"),
              Text("ID: ${meal.idMeal}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageDetailCategory(idMeal: meal.idMeal),
              ),
            );
          },
        );
      },
    );
  }
}
