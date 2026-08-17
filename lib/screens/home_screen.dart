import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../services/login_service.dart';
import 'details_screen.dart';
import 'login_page.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<dynamic> allRecipes = [];
  List<dynamic> filteredRecipes = [];
  List<String> cuisines = ["All"];
  String selectedCuisine = "All";
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        allRecipes = data['recipes'];
        filteredRecipes = allRecipes;
        cuisines.addAll(
          allRecipes.map((r) => r['cuisine'].toString()).toSet().toList(),
        );
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      filteredRecipes = allRecipes.where((recipe) {
        final matchesSearch = recipe['name'].toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final matchesCuisine =
            selectedCuisine == "All" || recipe['cuisine'] == selectedCuisine;
        return matchesSearch && matchesCuisine;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: Text(
          "Hungry?",
          style: GoogleFonts.philosopher(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () async {
                await LoginService().logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyLogin()),
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 5),
                child: Text(
                  "log out",
                  style: GoogleFonts.philosopher(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchBar(
                    hintText: "Search recipes...",
                    leading: const Icon(Icons.search),
                    onChanged: (val) {
                      searchQuery = val;
                      _applyFilters();
                    },
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
                  ),
                ),

                // Horizontal Cuisine Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cuisines.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cuisines[i]),
                        selected: selectedCuisine == cuisines[i],
                        onSelected: (val) {
                          selectedCuisine = cuisines[i];
                          _applyFilters();
                        },
                      ),
                    ),
                  ),
                ), 

                // Recipe Grid
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                       double width = constraints.maxWidth;
                      int crossAxisCount = 2; // Mobile by default
                      double childAspectRatio = 0.75;

                      if (width >= 1200) {
                        crossAxisCount = 5; // Desktop Large: 5 cards
                        childAspectRatio = 0.85;
                      } else if (width >= 800) {
                        crossAxisCount = 4; // Desktop/Laptop: 4 cards
                        childAspectRatio = 0.80;
                      } else if (width >= 600) {
                        crossAxisCount = 3; // Tablet: 3 cards
                        childAspectRatio = 0.75;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredRecipes.length,
                        itemBuilder: (ctx, i) =>
                            RecipeCard(recipe: filteredRecipes[i]),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
class RecipeCard extends StatelessWidget {
  final dynamic recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  recipe['image'],
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        " ${recipe['rating']}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        "${recipe['cookTimeMinutes']} min",
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
