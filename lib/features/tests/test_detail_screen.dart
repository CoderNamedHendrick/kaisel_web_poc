import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

/// Detail page for a [SkillTest], opened from the Tests tab.
///
/// Accepts a resolved [test] when the caller has it, or a [testId] looked up in
/// [MockData] (the deep-link case).
class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({super.key, this.test, this.testId})
    : assert(test != null || testId != null, 'Provide a test or a testId');

  final SkillTest? test;
  final String? testId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolved = test ?? (testId != null ? MockData.skillTestById(testId!) : null);

    if (resolved == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Skill test')),
        body: Center(child: Text('No skill test found for "$testId".')),
      );
    }

    final t = resolved;
    return Scaffold(
      appBar: AppBar(title: const Text('Skill test', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(t.level, icon: Icons.bar_chart),
              Pill('${t.durationMin} min', icon: Icons.timer_outlined),
            ],
          ),
          const SizedBox(height: 16),
          Text(t.description, style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4)),
          const SizedBox(height: 24),
          _action(context, t),
        ],
      ),
    );
  }

  Widget _action(BuildContext context, SkillTest t) {
    final scheme = Theme.of(context).colorScheme;
    switch (t.status) {
      case TestStatus.passed:
        final score = t.score ?? 0;
        return Card(
          color: scheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    const Text('Passed', style: TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('$score / 100', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green.shade700)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 8,
                    backgroundColor: scheme.surfaceContainerHighest,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      case TestStatus.scheduled:
        return Card(
          color: scheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                PlayerAvatar(player: t.scheduledWith!, radius: 18),
                const SizedBox(width: 12),
                Expanded(child: Text('Scheduled with ${t.scheduledWith!.name}')),
                OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manage booking — coming soon')),
                  ),
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),
        );
      case TestStatus.available:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Starting ${t.title} — coming soon')),
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start test'),
          ),
        );
    }
  }
}
