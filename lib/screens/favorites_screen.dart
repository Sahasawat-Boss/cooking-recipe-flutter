import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../l10n/strings.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/recipe_cards.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final state = AppScope.of(context);
    final saved = recipes.where((r) => state.isFavorite(r.id)).toList();

    return CustomScrollView(slivers: [
      SliverSafeArea(
        bottom: false,
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.favorites, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(s.savedCount(saved.length),
                  style: TextStyle(color: Palette.of(context).muted)),
            ]),
          ),
        ),
      ),
      if (saved.isEmpty)
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: EmptyState(
              icon: Icons.favorite_border_rounded,
              title: s.noFavorites,
              subtitle: s.noFavoritesHint,
            ),
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.74,
            ),
            itemCount: saved.length,
            itemBuilder: (context, i) => RecipeGridCard(recipe: saved[i], heroPrefix: 'fav'),
          ),
        ),
    ]);
  }
}
