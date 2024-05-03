import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/recipe.dart';
import 'package:my_flutter_app/pages/recipe_page.dart';
import 'package:my_flutter_app/services/data_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _mealTypeFilter = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'RecipeBook',
        ),
      ),
      body: SafeArea(
        child : _buildUI()
      ),
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: EdgeInsets.all(
        10.0,
      ),
      child: Column(
        children: [
          _recipeTypeButtons(),
          _recipesList()
        ],
      ),
    );
  }

  Widget _recipeTypeButtons() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: FilledButton(
                onPressed: () {
                  setState( () {
                    _mealTypeFilter = "snack";
                  });
                },
                child: const Text("🥕 Snack")
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: FilledButton(
                onPressed: () {
                  setState( () {
                    _mealTypeFilter = "breakfast";
                  });
                },
                child: const Text("🍳 Breakfast")
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: FilledButton(
                onPressed: () {
                  setState( () {
                    _mealTypeFilter = "lunch";
                  });
                },
                child: const Text("🍱 Lunch")
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: FilledButton(
                onPressed: () {
                  setState( () {
                    _mealTypeFilter = "dinner";
                  });
                },
                child: const Text("🍽️ Dinner")
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipesList() {
    //DEV NOTE: expanded means expand child to take all remaining screen spaces
    return Expanded(
        child: FutureBuilder(
            future: DataService().getRecipes( //panggil function to fetch API
                _mealTypeFilter,
            ),
            builder: (context, snapshot) {
               //If data still fetching, show circular loading
               if(snapshot.connectionState == ConnectionState.waiting) {
                 return Center(
                   child: CircularProgressIndicator()
                 );
               }

               //DEV Note: If got error
               if (snapshot.hasError) {
                 return const Center(
                   child: Text('Unable to load data')
                 );
               }
               return ListView.builder(
                 itemCount: snapshot.data?.length,
                 itemBuilder: (context, index) {
                   Recipe recipe = snapshot.data![index];
                   return ListTile(
                     onTap: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) {
                               return RecipePage(recipe: recipe);
                             },
                         ),
                       );
                     },
                     contentPadding: const EdgeInsets.only(
                       top: 20.0,
                     ),
                     isThreeLine: true,
                     subtitle: Text("${recipe.cuisine}\n Difficulty: ${recipe.difficulty}"),
                     title: Text(recipe.name),
                     leading: Image.network(recipe.image),
                     trailing: Text(
                         "${recipe.rating.toString()} ⭐",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                     ),

                   );
                 },
               );
            },
        )
    );
  }


}
