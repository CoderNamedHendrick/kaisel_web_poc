import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tests = MockData.skillTests;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Tests', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _RatingBanner(),
          const SizedBox(height: 20),
          Text('Assessments', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final t in tests) ...[_TestCard(t), const SizedBox(height: 12)],
        ],
      ),
    );
  }
}

class _RatingBanner extends StatelessWidget {
  const _RatingBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your NTRP rating', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
              const SizedBox(height: 4),
              Text(
                '${MockData.me.ntrp}',
                style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.0),
              ),
              const SizedBox(height: 6),
              Text(
                'Verified · expires in 4 months',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.workspace_premium, size: 64, color: Colors.white.withValues(alpha: 0.85)),
        ],
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard(this.test);
  final SkillTest test;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: InkWell(
        onTap: () => context.push(TestDetail(testId: test.id, test: test)),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(test.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                _StatusBadge(test),
              ],
            ),
            const SizedBox(height: 6),
            Text(test.description, style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Row(
              children: [
                Pill(test.level, icon: Icons.bar_chart),
                const SizedBox(width: 8),
                Pill('${test.durationMin} min', icon: Icons.timer_outlined),
              ],
            ),
            const SizedBox(height: 14),
            _action(context),
          ],
        ),
      ),
      ),
    );
  }

  Widget _action(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (test.status) {
      case TestStatus.passed:
        final score = test.score ?? 0;
        return Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: score / 100,
                  minHeight: 8,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: Colors.green.shade600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$score / 100',
              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green.shade700),
            ),
          ],
        );
      case TestStatus.scheduled:
        return Row(
          children: [
            PlayerAvatar(player: test.scheduledWith!, radius: 14),
            const SizedBox(width: 8),
            Expanded(child: Text('Scheduled with ${test.scheduledWith!.name}')),
            OutlinedButton(
              onPressed: () => context.push(TestDetail(testId: test.id, test: test)),
              child: const Text('Manage'),
            ),
          ],
        );
      case TestStatus.available:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.push(TestDetail(testId: test.id, test: test)),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start test'),
          ),
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.test);
  final SkillTest test;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color, icon) = switch (test.status) {
      TestStatus.passed => ('Passed', Colors.green.shade600, Icons.check_circle),
      TestStatus.scheduled => ('Scheduled', scheme.primary, Icons.event_available),
      TestStatus.available => ('Available', scheme.onSurfaceVariant, Icons.lock_open),
    };
    return Pill(label, icon: icon, color: color, bg: color.withValues(alpha: 0.12));
  }
}
