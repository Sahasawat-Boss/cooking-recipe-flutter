import 'package:flutter/material.dart';

import '../data/recipe.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'cooking_mode_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe, required this.heroTag});

  final Recipe recipe;
  final String heroTag;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<int> _checked = {};
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final p = Palette.of(context);
    final r = widget.recipe;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.height * 0.45,
              pinned: true,
              stretch: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: _CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FavoriteButton(recipeId: r.id, size: 40, showSnack: true),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Hero(
                  tag: widget.heroTag,
                  child: Image.asset(r.image, fit: BoxFit.cover),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                transform: Matrix4.translationValues(0, -28, 0),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: p.surfaceAlt, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    Text(s.category(r.category).toUpperCase(),
                        style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 1.2)),
                    const Spacer(),
                    Icon(Icons.star_rounded, color: p.gold, size: 18),
                    const SizedBox(width: 4),
                    Text(r.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 6),
                  Text(r.title.of(s.lang), style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text(r.description.of(s.lang),
                      style: TextStyle(color: p.muted, height: 1.55, fontSize: 15)),
                  const SizedBox(height: 22),
                  _StatsRow(recipe: r),
                  const SizedBox(height: 26),
                  _TabSwitcher(
                    labels: [s.ingredients, s.steps],
                    index: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _tab == 0 ? _ingredients(s, r) : _steps(s, r),
                  ),
                  const SizedBox(height: 110),
                ]),
              ),
            ),
          ],
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 0,
          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 58,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  elevation: 6,
                  shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => CookingModeScreen(recipe: r),
                )),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(s.startCooking),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _ingredients(S s, Recipe r) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    return Column(
      key: const ValueKey('ingredients'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.itemsCount(r.ingredients.length), style: TextStyle(color: p.muted)),
        const SizedBox(height: 10),
        for (var i = 0; i < r.ingredients.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _checked.contains(i) ? _checked.remove(i) : _checked.add(i)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _checked.contains(i) ? theme.colorScheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _checked.contains(i) ? theme.colorScheme.primary : p.muted.withValues(alpha: 0.5),
                          width: 1.6,
                        ),
                      ),
                      child: _checked.contains(i)
                          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        r.ingredients[i].name.of(s.lang),
                        style: TextStyle(
                          fontSize: 15,
                          decoration: _checked.contains(i) ? TextDecoration.lineThrough : null,
                          color: _checked.contains(i) ? p.muted : null,
                        ),
                      ),
                    ),
                    Text(r.ingredients[i].amount.of(s.lang),
                        style: TextStyle(color: p.muted, fontWeight: FontWeight.w500)),
                  ]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _steps(S s, Recipe r) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    return Column(
      key: const ValueKey('steps'),
      children: [
        for (var i = 0; i < r.steps.length; i++)
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Column(children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text('${i + 1}',
                      style: TextStyle(
                          color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
                ),
                if (i < r.steps.length - 1)
                  Expanded(child: Container(width: 2, color: p.surfaceAlt)),
              ]),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22, top: 2),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s.stepLabel(i + 1),
                        style: TextStyle(color: p.muted, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(r.steps[i].of(s.lang), style: const TextStyle(fontSize: 15, height: 1.5)),
                  ]),
                ),
              ),
            ]),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final items = [
      (Icons.schedule_rounded, s.time, s.minutes(recipe.minutes)),
      (Icons.people_alt_rounded, s.serves, s.servings(recipe.servings)),
      (Icons.signal_cellular_alt_rounded, s.level, s.difficulty(recipe.difficulty)),
      (Icons.local_fire_department_rounded, s.calories, s.kcal(recipe.kcal)),
    ];
    final theme = Theme.of(context);
    final p = Palette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(children: [
        for (final (icon, label, value) in items)
          Expanded(
            child: Column(children: [
              Icon(icon, color: theme.colorScheme.primary, size: 22),
              const SizedBox(height: 6),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(label, style: TextStyle(color: p.muted, fontSize: 11)),
            ]),
          ),
      ]),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.labels, required this.index, required this.onChanged});

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth / labels.length;
        return Stack(children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            left: w * index,
            width: w,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8),
                ],
              ),
            ),
          ),
          Row(children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
                  child: Center(
                    child: Text(labels[i],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: i == index ? theme.colorScheme.onSurface : p.muted,
                        )),
                  ),
                ),
              ),
          ]),
        ]);
      }),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Icon(icon, size: 18, color: const Color(0xFF1C1A17)),
      ),
    );
  }
}
