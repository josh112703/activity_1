import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? titleStyle; // New parameter for custom title styling
  final String? logoPath;
  final VoidCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleStyle,
    this.logoPath,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          if (logoPath != null) Image.asset(logoPath!, height: 40),
          if (logoPath != null) const SizedBox(width: 8),
          Text(
            title,
            style: titleStyle ?? const TextStyle(),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 61, 83, 30),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: onLogout ??
              () {
                Navigator.pushReplacementNamed(
                    context, '/login'); // Default navigation to login
              },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
