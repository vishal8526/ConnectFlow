import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  const AppHeader({super.key, required this.title, this.onSettings, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(onPressed: onSettings, icon: const Icon(Icons.settings)),
        IconButton(onPressed: onLogout, icon: const Icon(Icons.logout)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


