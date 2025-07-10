import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/hall.dart';
import 'package:ecinema_desktop/providers/hall_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditHallScreen extends StatefulWidget {
  final Hall? hall;

  const EditHallScreen({super.key, this.hall});

  @override
  State<EditHallScreen> createState() => _EditHallScreenState();
}

class _EditHallScreenState extends State<EditHallScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.hall != null;
    
    return MasterScreen(
      isEditing ? l10n.editHall : l10n.addNewHall,
      Column(
        children: [
          _buildForm(l10n, isEditing),
          _save(l10n, isEditing),
        ],
      ),
      showDrawer: false,
    );
  }

  Widget _buildForm(AppLocalizations l10n, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: {
          'name': widget.hall?.name ?? '',
          'location': widget.hall?.location ?? '',
          'capacity': (widget.hall?.capacity ?? 1).toString(),
          'screenType': widget.hall?.screenType ?? '',
          'soundSystem': widget.hall?.soundSystem ?? '',
          'isActive': widget.hall?.isActive ?? true,
        },
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(
                labelText: l10n.hallName,
                border: const OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallName),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'location',
              decoration: InputDecoration(
                labelText: l10n.hallLocation,
                border: const OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallLocation),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'capacity',
              decoration: InputDecoration(
                labelText: l10n.hallCapacity,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallCapacity),
                FormBuilderValidators.min(1, errorText: l10n.capacityMustBeAtLeastOne),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'screenType',
              decoration: InputDecoration(
                labelText: l10n.hallScreenType,
                border: const OutlineInputBorder(),
                hintText: l10n.screenTypeHint,
              ),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'soundSystem',
              decoration: InputDecoration(
                labelText: l10n.hallSoundSystem,
                border: const OutlineInputBorder(),
                hintText: l10n.soundSystemHint,
              ),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderSwitch(
              name: 'isActive',
              title: Text(l10n.isActive),
            ),
          ],
        ),
      ),
    );
  }

  Widget _save(AppLocalizations l10n, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveHall,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(isEditing ? l10n.update : l10n.create),
          ),
        ],
      ),
    );
  }

  Future<void> _saveHall() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final formData = _formKey.currentState!.value;
        final hallProvider = Provider.of<HallProvider>(context, listen: false);
        
        final hall = Hall(
          id: widget.hall?.id,
          name: formData['name'],
          location: formData['location'],
          capacity: int.tryParse(formData['capacity']) ?? 1,
          screenType: formData['screenType'],
          soundSystem: formData['soundSystem'],
          isActive: formData['isActive'],
          isDeleted: widget.hall?.isDeleted ?? false,
        );

        if (widget.hall == null) {
          await hallProvider.insert(hall);
        } else {
          await hallProvider.update(widget.hall!.id!, hall);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.hallSavedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToSaveHall),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
} 