import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  int _seats = 3;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(title: const Text('Post a Shared Trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Where are you going?',
                style: MasaratTypography.headlineSmall),
            const SizedBox(height: 24),

            // Route fields
            TextField(
              controller: _departureController,
              decoration: const InputDecoration(
                labelText: 'Departure City',
                hintText: 'e.g. Tunis',
                prefixIcon: Icon(Icons.radio_button_checked_rounded,
                    color: MasaratColors.primary, size: 18),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination City',
                hintText: 'e.g. Sousse',
                prefixIcon: Icon(Icons.location_on_rounded,
                    color: MasaratColors.primary, size: 18),
              ),
            ),
            const SizedBox(height: 28),

            // Date & Time row
            Text('Date & Time', style: MasaratTypography.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PickerCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: _selectedDate == null
                        ? 'Select'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerCard(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: _selectedTime == null
                        ? 'Select'
                        : _selectedTime!.format(context),
                    onTap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) setState(() => _selectedTime = time);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Seats stepper
            Text('Available Seats', style: MasaratTypography.titleMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepperButton(
                    icon: Icons.remove_rounded,
                    onTap: () {
                      if (_seats > 1) setState(() => _seats--);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          '$_seats',
                          style: MasaratTypography.headlineLarge,
                        ),
                        Text('seats', style: MasaratTypography.labelSmall),
                      ],
                    ),
                  ),
                  _StepperButton(
                    icon: Icons.add_rounded,
                    onTap: () {
                      if (_seats < 4) setState(() => _seats++);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // CTA
            _GradientButton(label: 'Publish Trip', onPressed: _publishTrip),
          ],
        ),
      ),
    );
  }

  void _publishTrip() {
    // Check posting limit → publish
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}

class _PickerCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _PickerCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MasaratColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: MasaratTypography.labelSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, size: 16, color: MasaratColors.primary),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: MasaratTypography.labelLarge.copyWith(
                    color: value == 'Select'
                        ? MasaratColors.onSurfaceVariant
                        : MasaratColors.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: MasaratColors.surfaceContainerLowest,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: MasaratColors.onSurface.withOpacity(0.06),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, color: MasaratColors.primary, size: 20),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: MasaratColors.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: MasaratColors.primary.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(label, style: MasaratTypography.buttonText),
        ),
      ),
    );
  }
}
