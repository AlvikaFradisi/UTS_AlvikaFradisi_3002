import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/daftar_category.dart';

class CategoryService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";


  static Future<DaftarCategory> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse("$baseUrl/filter.php?c=$category"));
    if (response.statusCode == 200) {
      return DaftarCategory.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal ambil data kategori");
    }
  }


  static Future<Map<String, dynamic>> getMealDetail(String idMeal) async {
    final response = await http.get(Uri.parse("$baseUrl/lookup.php?i=$idMeal"));
    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'][0];
    } else {
      throw Exception("Gagal ambil detail masakan");
    }
  }


  static Future<List<dynamic>> searchMeals(String keyword) async {
    final response = await http.get(Uri.parse("$baseUrl/search.php?s=$keyword"));
    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'] ?? [];
    } else {
      throw Exception("Gagal cari masakan");
    }
  }
}
