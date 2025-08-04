import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/screening_format.dart';
import 'package:ecinema_desktop/providers/screening_format_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScreeningFormatScreen extends StatefulWidget {
  final ScreeningFormat? screeningFormat;

  const EditScreeningFormatScreen({super.key, this.screeningFormat});

  @override
  State<EditScreeningFormatScreen> createState() => _EditScreeningFormatScreenState();
}

class _EditScreeningFormatScreenState extends State<EditScreeningFormatScreen> {
  late ScreeningFormatProvider provider;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<ScreeningFormatProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.screeningFormat != null;
    
    return MasterScreen(
      isEditing ? l10n.editScreeningFormat : l10n.addScreeningFormat,
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
          'name': widget.screeningFormat?.name ?? '',
          'description': widget.screeningFormat?.description ?? '',
          'priceMultiplier': (widget.screeningFormat?.priceMultiplier ?? 1.0).toString(),
        },
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(
                labelText: l10n.screeningFormatName,
                border: const OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterScreeningFormatName),
                FormBuilderValidators.maxLength(50, errorText: '${l10n.pleaseEnterScreeningFormatName} (max 50 characters)'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(
                labelText: l10n.screeningFormatDescription,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(200, errorText: '${l10n.pleaseEnterScreeningFormatDescription} (max 200 characters)'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'priceMultiplier',
              decoration: InputDecoration(
                labelText: l10n.priceMultiplier,
                border: const OutlineInputBorder(),
                helperText: '1.0 = regular price, 1.5 = 50% more, etc.',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterPriceMultiplier),
                FormBuilderValidators.numeric(errorText: l10n.pleaseEnterPriceMultiplier),
                (value) {
                  if (value == null || value.isEmpty) return null;
                  final numValue = double.tryParse(value);
                  if (numValue == null) return l10n.pleaseEnterPriceMultiplier;
                  if (numValue < 0.1 || numValue > 10.0) {
                    return '${l10n.pleaseEnterPriceMultiplier} (0.1 - 10.0)';
                  }
                  return null;
                },
              ]),
            ),
            
            const SizedBox(height: 16),
            

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
            onPressed: _isSaving ? null : _saveScreeningFormat,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: _isSaving
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

  Future<void> _saveScreeningFormat() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = _formKey.currentState!.value;
    
    setState(() {
      _isSaving = true;
    });

    try {
      final screeningFormat = ScreeningFormat(
        id: widget.screeningFormat?.id,
        name: formData['name'],
        description: formData['description'],
        priceMultiplier: double.tryParse(formData['priceMultiplier']) ?? 1.0,
        isDeleted: widget.screeningFormat?.isDeleted ?? false,
      );

      if (widget.screeningFormat == null) {
        await provider.insert(screeningFormat);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.screeningFormatCreatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await provider.update(widget.screeningFormat!.id!, screeningFormat);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.screeningFormatUpdatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.failedToSaveScreeningFormat}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
} 