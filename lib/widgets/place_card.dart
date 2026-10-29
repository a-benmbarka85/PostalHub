import 'package:flutter/material.dart';

import '../models/place.dart';
import '../styles/app_styles.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceCard({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.cardBackground,
        borderRadius: BorderRadius.circular(AppStyles.radiusMd),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppStyles.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.spacingMd),
            child: Row(
              children: [
                const Text('🐧', style: TextStyle(fontSize: 28)),
                const SizedBox(width: AppStyles.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name, style: AppStyles.titleMedium),
                      const SizedBox(height: AppStyles.spacingXs),
                      Text(
                        '${place.admin2} · ${place.admin1}',
                        style: AppStyles.bodySecondary,
                      ),
                      if (place.population != null) ...[
                        const SizedBox(height: AppStyles.spacingXs),
                        Text(
                          '${place.population} habitants',
                          style: AppStyles.caption,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppStyles.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}