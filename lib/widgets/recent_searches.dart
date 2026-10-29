import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class RecentSearches extends StatelessWidget {
  final List<String> terms;
  final ValueChanged<String> onTap;

  const RecentSearches({super.key, required this.terms, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cerques recents', style: AppStyles.caption),
        const SizedBox(height: AppStyles.spacingXs),
        Wrap(
          spacing: AppStyles.spacingSm,
          runSpacing: AppStyles.spacingXs,
          children: terms.map((term) {
            return ActionChip(
              label: Text(term),
              onPressed: () => onTap(term),
            );
          }).toList(),
        ),
      ],
    );
  }
}