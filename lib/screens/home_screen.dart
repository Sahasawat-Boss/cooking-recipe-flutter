import 'package:flutter/material.dart';

import '../data/recipe.dart';
import '../data/recipes.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/recipe_cards.dart';

const _featuredIds = ['pad_thai', 'salmon_rice_bowl', 'mango_sticky_rice', 'carbonara'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  final _pager = PageController(viewportFraction: 0.86);
  RecipeCategory? _category;
  String _query = '';
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pager.addListener(() => setState(() => _page = _pager.page ?? 0));
  }

  @override
  void dispose() {
    _search.dispose();
    _pager.dispose();
    super.dispose();
  }

  List<Recipe> _filtered() {
    final q = _query.trim().toLowerCase();
    return recipes.where((r) {
      if (_category != null && r.category != _category) return false;
      if (q.isEmpty) return true;
      return r.title.en.toLowerCase().contains(q) || r.title.th.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final p = Palette.of(context);
    final featured = [for (final id in _featuredIds) recipes.firstWhere((r) => r.id == id)];
    final list = _filtered();
    final showFeatured = _query.isEmpty && _category == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.greeting(DateTime.now().hour),
                            style: TextStyle(color: p.muted, fontSize: 13)),
                        Text(s.appName,
                            style: theme.textTheme.titleMedium?.copyWith(letterSpacing: 0.2)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 22),
                  Text(s.headline, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  _SearchField(
                    controller: _search,
                    hint: s.searchHint,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                children: [
                  _CategoryChip(
                    label: s.catAll,
                    icon: Icons.apps_rounded,
                    selected: _category == null,
                    onTap: () => setState(() => _category = null),
                  ),
                  for (final c in RecipeCategory.values)
                    _CategoryChip(
                      label: s.category(c),
                      icon: _categoryIcon(c),
                      selected: _category == c,
                      onTap: () => setState(() => _category = _category == c ? null : c),
                    ),
                ],
              ),
            ).withTopPadding(18),
          ),
          if (showFeatured) ...[
            _SectionHeader(title: s.featured),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pager,
                  itemCount: featured.length,
                  itemBuilder: (context, i) {
                    final scale = (1 - ((_page - i).abs() * 0.06)).clamp(0.9, 1.0);
                    return Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: FeaturedRecipeCard(recipe: featured[i]),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < featured.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _page.round() == i ? 22 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _page.round() == i ? theme.colorScheme.primary : p.surfaceAlt,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
          _SectionHeader(
            title: _category == null ? s.allRecipes : s.category(_category!),
            trailing: '${list.length}',
          ),
          if (list.isEmpty)
            SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: s.noResults,
                subtitle: s.noResultsHint,
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
                itemCount: list.length,
                itemBuilder: (context, i) => RecipeGridCard(recipe: list[i]),
              ),
            ),
        ],
      ),
    );
  }

  IconData _categoryIcon(RecipeCategory c) => switch (c) {
        RecipeCategory.thai => Icons.rice_bowl_rounded,
        RecipeCategory.asian => Icons.ramen_dining_rounded,
        RecipeCategory.western => Icons.lunch_dining_rounded,
        RecipeCategory.sweets => Icons.cake_rounded,
      };
}

extension on Widget {
  Widget withTopPadding(double v) => Padding(padding: EdgeInsets.only(top: v), child: this);
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.hint, required this.onChanged});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: p.muted),
        prefixIcon: Icon(Icons.search_rounded, color: p.muted),
        suffixIcon: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.close_rounded, color: p.muted),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    final fg = selected ? Colors.white : theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? Colors.transparent : p.surfaceAlt),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: selected ? Colors.white : theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
        child: Row(children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: p.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(trailing!,
                  style: TextStyle(color: p.muted, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
        ]),
      ),
    );
  }
}
