import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.leading,
  });

  final String title;
  final Widget leading;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
