import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

/// Edit-profile page, opened from the Profile tab. Fields are pre-filled from
/// [MockData.me] and read-only in this POC — "Save" shows a placeholder
/// SnackBar.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = MockData.me;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved — coming soon')),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: PlayerAvatar(player: me, radius: 44)),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change photo — coming soon')),
              ),
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Change photo'),
            ),
          ),
          const SizedBox(height: 8),
          _Field(label: 'Name', value: me.name),
          _Field(label: 'Location', value: me.location),
          _Field(label: 'NTRP rating', value: '${me.ntrp}'),
          if (me.bio != null) _Field(label: 'Bio', value: me.bio!, maxLines: 3),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.maxLines = 1});

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
