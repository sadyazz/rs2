import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/promotion.dart';
import 'package:ecinema_desktop/providers/promotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EditPromotionScreen extends StatefulWidget {
  final Promotion? promotion;

  const EditPromotionScreen({super.key, this.promotion});

  @override
  State<EditPromotionScreen> createState() => _EditPromotionScreenState();
}

class _EditPromotionScreenState extends State<EditPromotionScreen> {
  late PromotionProvider provider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.promotion != null) {
      _initialValue = {
        'name': widget.promotion!.name ?? '',
        'description': widget.promotion!.description ?? '',
        'code': widget.promotion!.code ?? '',
        'discountPercentage': (widget.promotion!.discountPercentage ?? 0.0).toString(),
        'startDate': widget.promotion!.startDate ?? DateTime.now(),
        'endDate': widget.promotion!.endDate ?? DateTime.now().add(const Duration(days: 30)),
        'isActive': widget.promotion!.isActive ?? true,
      };
    } else {
      _initialValue = {
        'name': '',
        'description': '',
        'code': '',
        'discountPercentage': '0.0',
        'startDate': DateTime.now(),
        'endDate': DateTime.now().add(const Duration(days: 30)),
        'isActive': true,
      };
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<PromotionProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.promotion != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editPromotion : l10n.addPromotion),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildForm(),
          ),
          _buildSaveButtons(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: _initialValue,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(
                  labelText: l10n.title,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.pleaseEnterName),
                  FormBuilderValidators.maxLength(100, errorText: l10n.nameTooLong),
                ]),
              ),
              
              const SizedBox(height: 16),
              
              FormBuilderTextField(
                name: 'description',
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.pleaseEnterDescription),
                  FormBuilderValidators.maxLength(500, errorText: l10n.descriptionTooLong),
                ]),
              ),
              
              const SizedBox(height: 16),
              
              FormBuilderTextField(
                name: 'code',
                decoration: InputDecoration(
                  labelText: l10n.code,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.code),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.maxLength(20, errorText: l10n.codeTooLong),
                ]),
              ),
              
              const SizedBox(height: 16),
              
              FormBuilderTextField(
                name: 'discountPercentage',
                decoration: InputDecoration(
                  labelText: l10n.discountPercentage,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.percent),
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.pleaseEnterDiscountPercentage),
                  FormBuilderValidators.min(0, errorText: l10n.discountPercentageInvalid),
                  FormBuilderValidators.max(100, errorText: l10n.discountPercentageInvalid),
                ]),
              ),
              
              const SizedBox(height: 16),
              
              FormBuilderDateTimePicker(
                name: 'startDate',
                decoration: InputDecoration(
                  labelText: l10n.startDate,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                inputType: InputType.date,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.pleaseEnterStartDate),
                ]),
                onChanged: (value) {
                  if (value != null) {
                    _formKey.currentState?.fields['endDate']?.validate();
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              FormBuilderDateTimePicker(
                name: 'endDate',
                decoration: InputDecoration(
                  labelText: l10n.endDate,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                inputType: InputType.date,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.pleaseEnterEndDate),
                  (value) {
                    final startDate = _formKey.currentState?.fields['startDate']?.value as DateTime?;
                    if (value != null && startDate != null && value.isBefore(startDate)) {
                      return l10n.endDateMustBeAfterStartDate;
                    }
                    return null;
                  },
                ]),
              ),
              
              const SizedBox(height: 16),
              
              FormBuilderSwitch(
                name: 'isActive',
                title: Text(l10n.active),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButtons() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                try {
                  final formData = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
                  
                  if (formData['startDate'] != null && formData['startDate'] is DateTime) {
                    formData['startDate'] = formData['startDate'].toIso8601String();
                  }
                  
                  if (formData['endDate'] != null && formData['endDate'] is DateTime) {
                    formData['endDate'] = formData['endDate'].toIso8601String();
                  }
                  
                  if (formData['discountPercentage'] != null) {
                    final discountStr = formData['discountPercentage'].toString();
                    formData['discountPercentage'] = double.tryParse(discountStr) ?? 0.0;
                  }
                  
                  formData['isActive'] = formData['isActive'] ?? true;

                  if (widget.promotion != null) {
                    await provider.update(widget.promotion!.id!, formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.promotionUpdatedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    await provider.insert(formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.promotionCreatedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }

                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.failedToSavePromotion),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(widget.promotion == null ? l10n.addPromotion : l10n.updatePromotion),
          ),
        ],
      ),
    );
  }
} 