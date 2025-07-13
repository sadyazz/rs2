import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/news.dart';
import 'package:ecinema_desktop/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EditNewsScreen extends StatefulWidget {
  final News? news;

  const EditNewsScreen({super.key, this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  late NewsProvider provider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.news != null) {
      _initialValue = {
        'title': widget.news!.title ?? '',
        'content': widget.news!.content ?? '',
        'publishDate': widget.news!.publishDate ?? DateTime.now(),
        'isActive': widget.news!.isActive ?? true,
      };
    } else {
      _initialValue = {
        'title': '',
        'content': '',
        'publishDate': DateTime.now(),
        'isActive': true,
      };
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<NewsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.news != null;
    
    return MasterScreen(
      isEditing ? 'Edit News Article' : 'Add News Article',
      Column(
        children: [
          _buildForm(),
          _buildSaveButtons(),
        ],
      ),
      showDrawer: false,
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'title',
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Please enter a title'),
                FormBuilderValidators.maxLength(100, errorText: 'Title must be less than 100 characters'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'content',
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.article),
              ),
              maxLines: 8,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Please enter content'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'publishDate',
                    decoration: const InputDecoration(
                      labelText: 'Publish Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    inputType: InputType.date,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderSwitch(
                    name: 'isActive',
                    title: const Text('Active'),
                    decoration: const InputDecoration(
                      labelText: 'Make this article visible',
                    ),
                  ),
                ),
              ],
            ),
          ],
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
                  
                  if (formData['publishDate'] != null && formData['publishDate'] is DateTime) {
                    formData['publishDate'] = formData['publishDate'].toIso8601String();
                  }
                  
                  formData['isActive'] = formData['isActive'] ?? true;

                  if (widget.news != null) {
                    await provider.update(widget.news!.id!, formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('News article updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    await provider.insert(formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('News article created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }

                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
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
            child: Text(widget.news == null ? 'Add News Article' : 'Update News Article'),
          ),
        ],
      ),
    );
  }
} 