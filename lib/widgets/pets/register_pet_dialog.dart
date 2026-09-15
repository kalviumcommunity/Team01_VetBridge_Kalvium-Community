import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/pet_model.dart';
import '../common/custom_text_field.dart';
import '../common/primary_button.dart';

class RegisterPetDialog extends StatefulWidget {
  const RegisterPetDialog({required this.onRegistered, super.key});

  final ValueChanged<Pet> onRegistered;

  @override
  State<RegisterPetDialog> createState() => _RegisterPetDialogState();
}

class _RegisterPetDialogState extends State<RegisterPetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _petName = TextEditingController();
  final _breed = TextEditingController();
  final _color = TextEditingController();
  final _weight = TextEditingController();
  final _microchip = TextEditingController();
  final _ownerName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  String _species = 'Dog';
  String _gender = 'Male';
  DateTime? _dateOfBirth;
  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in [_petName, _breed, _color, _weight, _microchip, _ownerName, _phone, _email, _address]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: MediaQuery.sizeOf(context).height * .92),
        child: LightGlassPanel(
          padding: EdgeInsets.zero,
          borderRadius: 18,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _DialogHeader(onClose: () => Navigator.pop(context)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _SectionTitle(title: 'Pet Information'),
                        _field('Pet Name *', _petName, validator: _required('Enter the pet name')),
                        _row(width, [
                          CustomDropdownField<String>(label: 'Species', value: _species, items: _speciesItems, onChanged: (value) => setState(() => _species = value!),),
                          CustomTextField(label: 'Breed', controller: _breed),
                        ]),
                        _row(width, [
                          CustomDropdownField<String>(label: 'Gender', value: _gender, items: _genderItems, onChanged: (value) => setState(() => _gender = value!)),
                          _DateField(date: _dateOfBirth, onTap: _pickDate),
                        ]),
                        _row(width, [
                          CustomTextField(label: 'Color', controller: _color),
                          CustomTextField(label: 'Weight (kg)', controller: _weight, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                        ]),
                        CustomTextField(label: 'Microchip ID', controller: _microchip),
                        const _SectionTitle(title: 'Owner Information'),
                        _field('Owner Name *', _ownerName, validator: _required('Enter the owner name')),
                        _field('Phone *', _phone, keyboardType: TextInputType.phone, validator: _required('Enter the owner phone')),
                        CustomTextField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
                        CustomTextField(label: 'Address', controller: _address),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: SecondaryButton(label: 'Cancel', onPressed: () => Navigator.pop(context))),
                            const SizedBox(width: 12),
                            Expanded(child: PrimaryButton(label: 'Register Pet', loadingLabel: 'Registering...', isLoading: _isLoading, onPressed: _submit)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {String? Function(String?)? validator, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomTextField(label: label, controller: controller, validator: validator, keyboardType: keyboardType),
    );
  }

  Widget _row(double width, List<Widget> children) {
    if (width < 430) {
      return Column(children: children.map((child) => Padding(padding: const EdgeInsets.only(bottom: 12), child: child)).toList());
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [Expanded(child: children[0]), const SizedBox(width: 12), Expanded(child: children[1])]),
    );
  }

  String? Function(String?) _required(String message) => (value) => value == null || value.trim().isEmpty ? message : null;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: _dateOfBirth ?? DateTime(2021),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    // TODO: Replace this mock callback with a Firestore write to `pets`.
    final pet = Pet(
      id: 'PET-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _petName.text.trim(),
      species: _species,
      breed: _breed.text.trim(),
      gender: _gender,
      dateOfBirth: _dateOfBirth ?? DateTime.now(),
      color: _color.text.trim(),
      weightKg: double.tryParse(_weight.text.trim()),
      microchipId: _microchip.text.trim().isEmpty ? null : _microchip.text.trim(),
      ownerName: _ownerName.text.trim(),
      ownerPhone: _phone.text.trim(),
      ownerEmail: _email.text.trim().isEmpty ? null : _email.text.trim(),
      ownerAddress: _address.text.trim().isEmpty ? null : _address.text.trim(),
      currentBranch: 'North Clinic',
      lastVisit: null,
      status: PetStatus.active,
    );
    widget.onRegistered(pet);
    Navigator.pop(context);
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 14, 10),
      child: Row(
        children: [
          const Expanded(child: Text('Register New Pet', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800))),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close, size: 19)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: .5)),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final value = date == null ? null : '${date!.day.toString().padLeft(2, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.year}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD5E1DF))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD5E1DF))),
        ),
        child: Text(value ?? 'dd-mm-yyyy', style: TextStyle(color: value == null ? AppColors.textSecondary : AppColors.textPrimary, fontSize: 14)),
      ),
    );
  }
}

final _speciesItems = ['Dog', 'Cat', 'Rabbit', 'Bird', 'Other'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList();
final _genderItems = ['Male', 'Female'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList();
