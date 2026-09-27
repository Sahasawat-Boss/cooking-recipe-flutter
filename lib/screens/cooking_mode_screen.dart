import 'package:flutter/material.dart';

import '../data/recipe.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// Distraction-free, one-step-at-a-time cooking view.
class CookingModeScreen extends StatefulWidget {
  const CookingModeScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  final _pager = PageController();
  int _index = 0;

  int get _total => widget.recipe.steps.length;
  bool get _finished => _index == _total;

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  void _go(int i) => _pager.animateToPage(i,
      duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final p = Palette.of(context);
    final r = widget.recipe;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(r.image, width: 40, height: 40, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(r.title.of(s.lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: _index / _total),
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => LinearProgressIndicator(
                  value: v,
                  minHeight: 6,
                  backgroundColor: p.surfaceAlt,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pager,
              itemCount: _total + 1,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                if (i == _total) return _FinishedPage(recipe: r);
                return Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${i + 1}'.padLeft(2, '0'),
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: theme.colorScheme.primary.withValues(alpha: 0.18),
                            fontWeight: FontWeight.w700,
                            fontSize: 96,
                            height: 1,
                          )),
                      const SizedBox(height: 12),
                      Text(s.stepOf(i + 1, _total),
                          style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 14),
                      Text(r.steps[i].of(s.lang),
                          style: theme.textTheme.headlineSmall?.copyWith(height: 1.45)),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Row(children: [
              if (_index > 0)
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: p.surfaceAlt, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => _go(_index - 1),
                      child: Text(s.back),
                    ),
                  ),
                ),
              if (_index > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onPressed: _finished ? () => Navigator.of(context).pop() : () => _go(_index + 1),
                    child: Text(_finished ? s.done : s.next),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _FinishedPage extends StatelessWidget {
  const _FinishedPage({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.primary, width: 4),
            image: DecorationImage(image: AssetImage(recipe.image), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 28),
        Text(s.enjoy, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(s.enjoyHint,
            style: TextStyle(color: Palette.of(context).muted), textAlign: TextAlign.center),
      ]),
    );
  }
}
