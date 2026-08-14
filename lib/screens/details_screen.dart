import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    
    List instructions = recipe['instructions'] ?? [];
    List ingredients = recipe['ingredients'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(recipe['name'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe['image'], width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(" ${recipe['rating']} Rating", style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 20),
                      const Icon(Icons.timer, color: Colors.grey),
                      Text(" ${recipe['cookTimeMinutes']} mins", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Ingredients Section (Bonus)
                  const Text("Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...ingredients.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text("• $item", style: const TextStyle(fontSize: 16)),
                  )).toList(),

                  const SizedBox(height: 20),

                  // Instructions Section  
                  const Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                   
                  ...instructions.asMap().entries.map((entry) {
                    int idx = entry.key + 1;
                    String step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("$idx. $step", style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
