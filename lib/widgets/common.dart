import 'package:flutter/material.dart';

import '../data/recipe.dart';
import '../l10n/strings.dart';
import '../screens/recipe_detail_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

void openRecipe(BuildContext context, Recipe recipe, String heroTag) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => RecipeDetailScreen(recipe: recipe, heroTag: heroTag),
  ));
}

/// Heart button that toggles a recipe in favorites.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.recipeId, this.size = 36, this.showSnack = false});

  final String recipeId;
  final double size;
  final bool showSnack;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final fav = state.isFavorite(recipeId);
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          final added = state.toggleFavorite(recipeId);
          if (showSnack) {
            final s = S.of(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(added ? s.savedToFavorites : s.removedFromFavorites),
                duration: const Duration(milliseconds: 1400),
              ));
          }
        },
        child: SizedBox.square(
          dimension: size,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Icon(
              fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(fav),
              size: size * 0.5,
              color: fav ? AppColors.accent : const Color(0xFF1C1A17),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small icon + text label used for time, kcal, etc.
class MetaLabel extends StatelessWidget {
  const MetaLabel({super.key, required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Palette.of(context).muted;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: c),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(fontSize: 12, color: c, fontWeight: FontWeight.w500)),
    ]);
  }
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
        const SizedBox(width: 3),
        Text(rating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(color: p.surfaceAlt, shape: BoxShape.circle),
          child: Icon(icon, size: 38, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 20),
        Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(subtitle, style: TextStyle(color: p.muted), textAlign: TextAlign.center),
      ]),
    );
  }
}
