import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class InfoCard extends StatelessWidget {
  final List<Widget> children;

  const InfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppStyles.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.spacingMd),
        child: Column(children: children),
      ),
    );
  }
}