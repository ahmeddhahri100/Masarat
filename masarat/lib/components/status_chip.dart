import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

enum TripStatus { pending, accepted, declined, cancelled }

class StatusChip extends StatelessWidget {
  final TripStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case TripStatus.pending:
        backgroundColor = MasaratColors.secondaryFixed;
        textColor = MasaratColors.onSecondaryFixed;
        label = 'Pending';
        break;
      case TripStatus.accepted:
        backgroundColor = MasaratColors.primaryFixed;
        textColor = MasaratColors.primary;
        label = 'Accepted';
        break;
      case TripStatus.declined:
      case TripStatus.cancelled:
        backgroundColor = MasaratColors.tertiaryFixed;
        textColor = MasaratColors.onTertiaryFixed;
        label = status == TripStatus.declined ? 'Declined' : 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: MasaratTypography.labelMedium.copyWith(color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
