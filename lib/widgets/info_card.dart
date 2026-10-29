import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class InfoCard extends StatelessWidget {
  final List<Widget> children;

  const InfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.cardBackground,
        borderRadius: BorderRadius.circular(AppStyles.radiusMd),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.spacingMd),
        child: Column(children: children),
      ),
    );
  }
}