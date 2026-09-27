/// Text available in both supported languages.
class LText {
  const LText(this.en, this.th);

  final String en;
  final String th;

  String of(String languageCode) => languageCode == 'th' ? th : en;
}

enum RecipeCategory { thai, asian, western, sweets }

enum Difficulty { easy, medium }

class Ingredient {
  const Ingredient(this.amount, this.name);

  final LText amount;
  final LText name;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.category,
    required this.minutes,
    required this.servings,
    required this.difficulty,
    required this.kcal,
    required this.rating,
    required this.ingredients,
    required this.steps,
  });

  final String id;
  final String image;
  final LText title;
  final LText description;
  final RecipeCategory category;
  final int minutes;
  final int servings;
  final Difficulty difficulty;
  final int kcal;
  final double rating;
  final List<Ingredient> ingredients;
  final List<LText> steps;
}
