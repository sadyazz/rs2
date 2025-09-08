import 'dart:convert';
import 'dart:io';
import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/actor.dart';
import 'package:ecinema_desktop/providers/actor_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EditActorScreen extends StatefulWidget {
  final Actor? actor;
  const EditActorScreen({super.key, this.actor});

  @override
  State<EditActorScreen> createState() => _EditActorScreenState();
}

class _EditActorScreenState extends State<EditActorScreen> {
  late ActorProvider provider;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSaving = false;
  String? _imageBase64;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<ActorProvider>();
  }

  @override
  void initState() {
    super.initState();
    if (widget.actor?.image != null && widget.actor!.image!.isNotEmpty) {
      _imageBase64 = widget.actor!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.actor != null;
    return MasterScreen(
      isEditing ? l10n.editActor : l10n.addActor,
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
          'firstName': widget.actor?.firstName ?? '',
          'lastName': widget.actor?.lastName ?? '',
          'biography': widget.actor?.biography ?? '',
          'dateOfBirth': widget.actor?.dateOfBirth,
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.actor,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: (_imageBase64 != null && _imageBase64!.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          base64Decode(_imageBase64!),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: getImage,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 48,
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  l10n.addActor,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'firstName',
                        decoration: InputDecoration(
                          labelText: l10n.actorFirstName,
                          border: const OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterActorFirstName),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'lastName',
                        decoration: InputDecoration(
                          labelText: l10n.actorLastName,
                          border: const OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterActorLastName),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderDateTimePicker(
                        name: 'dateOfBirth',
                        decoration: InputDecoration(
                          labelText: l10n.dateOfBirth,
                          border: const OutlineInputBorder(),
                        ),
                        inputType: InputType.date,
                        format: DateFormat('yyyy-MM-dd'),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'biography',
                        decoration: InputDecoration(
                          labelText: l10n.actorBiography,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterActorBiography),
                        ]),
                      ),
                      const SizedBox(height: 16),

                    ],
                  ),
                ),
              ],
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
            onPressed: _isSaving ? null : _saveActor,
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

  Future<void> _saveActor() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }
    final formData = _formKey.currentState!.value;
    setState(() {
      _isSaving = true;
    });
    try {
      final actor = Actor(
        id: widget.actor?.id,
        firstName: formData['firstName'],
        lastName: formData['lastName'],
        biography: formData['biography'],
        dateOfBirth: formData['dateOfBirth'],
        image: _imageBase64,
        isDeleted: widget.actor?.isDeleted ?? false,
      );
      if (widget.actor == null) {
        await provider.insert(actor);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.actorCreatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await provider.update(widget.actor!.id!, actor);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.actorUpdatedSuccessfully),
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
            content: Text('${l10n.failedToSaveActor}: $e'),
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

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      _imageBase64 = base64Encode(file.readAsBytesSync());
      setState(() {});
    }
  }
} 
