import 'package:flutter/material.dart';

import '../models/place.dart';
import '../styles/app_styles.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceCard({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppStyles.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusMd),
      ),
      child: ListTile(
        leading: const Text('🐧', style: TextStyle(fontSize: 24)),
        title: Text(place.name, style: AppStyles.titleMedium),
        subtitle: Text(
          '${place.admin2} · ${place.admin1}',
          style: AppStyles.bodySecondary,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}