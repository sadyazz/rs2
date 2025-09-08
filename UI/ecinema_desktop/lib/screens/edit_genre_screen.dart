import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/genre.dart';
import 'package:ecinema_desktop/providers/genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';

class EditGenreScreen extends StatefulWidget {
  final Genre? genre;

  const EditGenreScreen({super.key, this.genre});

  @override
  State<EditGenreScreen> createState() => _EditGenreScreenState();
}

class _EditGenreScreenState extends State<EditGenreScreen> {
  late GenreProvider provider;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<GenreProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.genre != null;
    
    return MasterScreen(
      isEditing ? l10n.editGenre : l10n.addGenre,
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
          'name': widget.genre?.name ?? '',
          'description': widget.genre?.description ?? '',
        },
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(
                labelText: l10n.genreName,
                border: const OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterGenreName),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(
                labelText: l10n.genreDescription,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterGenreDescription),
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
            onPressed: _isSaving ? null : _saveGenre,
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

  Future<void> _saveGenre() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = _formKey.currentState!.value;
    
    setState(() {
      _isSaving = true;
    });

    try {
      final genre = Genre(
        id: widget.genre?.id,
        name: formData['name'],
        description: formData['description'],
        isDeleted: widget.genre?.isDeleted ?? false,
      );

      if (widget.genre == null) {
        await provider.insert(genre);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.genreCreatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await provider.update(widget.genre!.id!, genre);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.genreUpdatedSuccessfully),
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
            content: Text('${l10n.failedToSaveGenre}: $e'),
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
