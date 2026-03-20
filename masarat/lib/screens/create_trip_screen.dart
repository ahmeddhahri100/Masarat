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
  final _seatsController = TextEditingController(text: '3');
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Shared Trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Where are you going?', style: MasaratTypography.headlineMedium.copyWith(fontSize: 20)),
            const SizedBox(height: 24),
            _buildLocationField(
              label: 'Departure City',
              controller: _departureController,
              icon: Icons.circle_outlined,
            ),
            const SizedBox(height: 16),
            _buildLocationField(
              label: 'Destination City',
              controller: _destinationController,
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildPickerField(
                    label: 'Date',
                    value: _selectedDate == null ? 'Select' : '${_selectedDate!.day}/${_selectedDate!.month}',
                    icon: Icons.calendar_today_outlined,
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
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPickerField(
                    label: 'Time',
                    value: _selectedTime == null ? 'Select' : _selectedTime!.format(context),
                    icon: Icons.access_time,
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time != null) setState(() => _selectedTime = time);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Available Seats', style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _seatButton(Icons.remove, () {
                  int val = int.parse(_seatsController.text);
                  if (val > 1) setState(() => _seatsController.text = (val - 1).toString());
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(_seatsController.text, style: MasaratTypography.headlineMedium),
                ),
                _seatButton(Icons.add, () {
                  int val = int.parse(_seatsController.text);
                  if (val < 4) setState(() => _seatsController.text = (val + 1).toString());
                }),
              ],
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Check Posting Limit
                // If limit reached -> Show Limit Reached Modal
                // Else -> Publish Trip
              },
              child: const Text('Publish Trip'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({required String label, required TextEditingController controller, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: MasaratColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        filled: true,
        fillColor: MasaratColors.surfaceContainerLow,
      ),
    );
  }

  Widget _buildPickerField({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
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
            Text(label, style: MasaratTypography.labelMedium),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 16, color: MasaratColors.primary),
                const SizedBox(width: 8),
                Text(value, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: MasaratColors.outlineVariant),
        ),
        child: Icon(icon, color: MasaratColors.primary),
      ),
    );
  }
}
