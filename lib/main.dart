import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Recipe Book',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, String>> favoriteRecipes = [];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      RecipeListScreen(onFavoriteToggle: _toggleFavorite, favoriteRecipes: favoriteRecipes),
      FavoriteScreen(favoriteRecipes: favoriteRecipes),
      ProfileScreen(),
    ]);
  }

  void _toggleFavorite(Map<String, String> recipe) {
    setState(() {
      if (favoriteRecipes.any((r) => r['name'] == recipe['name'])) {
        favoriteRecipes.removeWhere((r) => r['name'] == recipe['name']);
      } else {
        favoriteRecipes.add(recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ✅ Recipe List Screen with Favorites Fix
class RecipeListScreen extends StatefulWidget {
  final Function(Map<String, String>) onFavoriteToggle;
  final List<Map<String, String>> favoriteRecipes;

  RecipeListScreen({required this.onFavoriteToggle, required this.favoriteRecipes});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Map<String, String>> recipes = [
    {
      'name': 'Pancakes',
      'image': 'Assets/pancakes.jpg',
      'ingredients': 'Flour, Milk, Eggs, Sugar, Butter',
      'steps': '1. Mix ingredients\n2. Cook on pan\n3. Serve with syrup',
    },
    {
      'name': 'Spaghetti',
      'image': 'Assets/Spaghetti.jpg',
      'ingredients': 'Spaghetti, Tomato Sauce, Garlic, Olive Oil',
      'steps': '1. Boil pasta\n2. Prepare sauce\n3. Mix & serve',
    },
    {
      'name': 'Greek Salad',
      'image': 'Assets/Greek_Salad.jpg',
      'ingredients': 'Tomatoes, Cucumber, Feta Cheese, Olives, Olive Oil',
      'steps': '1. Chop vegetables\n2. Mix with feta cheese and olives\n3. Add olive oil & serve',
    },
    {
      'name': 'Chicken Stir Fry',
      'image': 'Assets/Chicken_Stir_Fry.jpg',
      'ingredients': 'Chicken, Bell Peppers, Soy Sauce, Garlic, Ginger',
      'steps': '1. Cook chicken in pan\n2. Add bell peppers & sauce\n3. Stir-fry and serve',
    },
  ];

  List<Map<String, String>> filteredRecipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
    searchController.addListener(() {
      filterRecipes();
    });
  }

  void filterRecipes() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredRecipes = recipes
          .where((recipe) =>
              recipe['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mini Recipe Book', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset('Assets/logo.jpg', width: 40),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search for recipes',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  final isFavorite = widget.favoriteRecipes.any((r) => r['name'] == recipe['name']);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.asset(
                              recipe['image']!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  recipe['name']!,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.onFavoriteToggle(recipe);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Recipe Detail Screen (Now Added!)
class RecipeDetailScreen extends StatelessWidget {
  final Map<String, String> recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['name']!)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(recipe['image']!, height: 250, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text("Ingredients:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(recipe['ingredients']!, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Steps:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(recipe['steps']!, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}


// ✅ Favorite Screen
class FavoriteScreen extends StatelessWidget {
  final List<Map<String, String>> favoriteRecipes;

  FavoriteScreen({required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: favoriteRecipes.isEmpty
          ? Center(child: Text("No favorite recipes yet!"))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(favoriteRecipes[index]['image']!,
                      width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(favoriteRecipes[index]['name']!),
                );
              },
            ),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset('Assets/logo.jpg', width: 40),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('Assets/profile_picture.jpg'),
            ),
            SizedBox(height: 10),
            Text("Gana Ayman", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("ganat@gmail.com", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.bookmark, color: Colors.orange),
                title: Text("My Recipes"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.history, color: Colors.orange),
                title: Text("History Views"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}