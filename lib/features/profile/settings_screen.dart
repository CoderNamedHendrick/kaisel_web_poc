import 'package:flutter/material.dart';

/// Account settings page, opened from the Profile tab. The rows are mock
/// entries — tapping one shows a placeholder SnackBar.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _items = <(IconData, String, String?)>[
    (Icons.credit_card, 'Payment methods', 'Visa •••• 4242'),
    (Icons.notifications_outlined, 'Notifications', 'Match invites, reminders'),
    (Icons.shield_outlined, 'Privacy & safety', null),
    (Icons.help_outline, 'Help & support', null),
    (Icons.logout, 'Log out', null),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final (icon, title, subtitle) in _items)
            ListTile(
              leading: Icon(icon, color: title == 'Log out' ? scheme.error : scheme.onSurfaceVariant),
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, color: title == 'Log out' ? scheme.error : null),
              ),
              subtitle: subtitle == null ? null : Text(subtitle),
              trailing: title == 'Log out' ? null : Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              onTap: () =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title — coming soon'))),
            ),
        ],
      ),
    );
  }
}
