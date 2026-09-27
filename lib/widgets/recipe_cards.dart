import 'package:flutter/material.dart';

import '../data/recipe.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Large image card for the featured carousel.
class FeaturedRecipeCard extends StatelessWidget {
  const FeaturedRecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final heroTag = 'featured-${recipe.id}';
    return GestureDetector(
      onTap: () => openRecipe(context, recipe, heroTag),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(fit: StackFit.expand, children: [
          Hero(tag: heroTag, child: Image.asset(recipe.image, fit: BoxFit.cover)),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 1],
                colors: [Colors.transparent, Color(0xDD000000)],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            right: 14,
            child: Row(children: [
              RatingBadge(rating: recipe.rating),
              const Spacer(),
              FavoriteButton(recipeId: recipe.id),
            ]),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(s.category(recipe.category),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              Text(
                recipe.title.of(s.lang),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, height: 1.2),
              ),
              const SizedBox(height: 6),
              Row(children: [
                MetaLabel(
                    icon: Icons.schedule_rounded, text: s.minutes(recipe.minutes), color: Colors.white70),
                const SizedBox(width: 14),
                MetaLabel(
                    icon: Icons.local_fire_department_rounded,
                    text: s.kcal(recipe.kcal),
                    color: Colors.white70),
                const SizedBox(width: 14),
                MetaLabel(
                    icon: Icons.signal_cellular_alt_rounded,
                    text: s.difficulty(recipe.difficulty),
                    color: Colors.white70),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Compact grid card with image on top and details below.
class RecipeGridCard extends StatelessWidget {
  const RecipeGridCard({super.key, required this.recipe, this.heroPrefix = 'grid'});

  final Recipe recipe;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final heroTag = '$heroPrefix-${recipe.id}';
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openRecipe(context, recipe, heroTag),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(fit: StackFit.expand, children: [
                  Hero(tag: heroTag, child: Image.asset(recipe.image, fit: BoxFit.cover)),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(recipeId: recipe.id, size: 32),
                  ),
                  Positioned(left: 8, bottom: 8, child: RatingBadge(rating: recipe.rating)),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                recipe.title.of(s.lang),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(children: [
                MetaLabel(icon: Icons.schedule_rounded, text: s.minutes(recipe.minutes)),
                const SizedBox(width: 10),
                Flexible(
                  child: MetaLabel(
                      icon: Icons.local_fire_department_rounded, text: s.kcal(recipe.kcal)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
