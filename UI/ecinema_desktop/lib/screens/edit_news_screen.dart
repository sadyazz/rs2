import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/news.dart';
import 'package:ecinema_desktop/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
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
        'publishDate': widget.news!.publishDate ?? DateTime.now().toUtc(),
        'type': widget.news!.type ?? 'news',
        'eventDate': widget.news!.eventDate,
      };
    } else {
      _initialValue = {
        'title': '',
        'content': '',
        'publishDate': DateTime.now().toUtc(),
        'type': 'news',
        'eventDate': null,
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
      isEditing ? l10n.editNewsArticle : l10n.addNewsArticle,
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
              decoration: InputDecoration(
                labelText: l10n.title,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.title),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterTitle),
                FormBuilderValidators.maxLength(100, errorText: l10n.titleTooLong),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'content',
              decoration: InputDecoration(
                labelText: l10n.content,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.article),
              ),
              maxLines: 8,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterContent),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'publishDate',
                    decoration: InputDecoration(
                      labelText: l10n.publishDate,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    inputType: InputType.date,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderDropdown<String>(
                    name: 'type',
                    decoration: InputDecoration(
                      labelText: l10n.type,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'news',
                        child: Text(l10n.news),
                      ),
                      DropdownMenuItem(
                        value: 'event',
                        child: Text(l10n.event),
                      ),
                    ],
                    validator: FormBuilderValidators.required(errorText: l10n.pleaseSelectType),
                    onChanged: (value) {
                      setState(() {
                      });
                    },
                  ),
                ),
              ],
            ),

            FormBuilderField<String>(
              name: 'type_listener',
              builder: (FormFieldState<String> field) {
                final type = _formKey.currentState?.fields['type']?.value as String?;
                if (type == 'event') {
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      FormBuilderDateTimePicker(
                        name: 'eventDate',
                        decoration: InputDecoration(
                          labelText: l10n.eventDate,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.event),
                        ),
                        inputType: InputType.both,
                        validator: FormBuilderValidators.required(errorText: l10n.pleaseSelectEventDate),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
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

                  if (formData['eventDate'] != null && formData['eventDate'] is DateTime) {
                    formData['eventDate'] = formData['eventDate'].toIso8601String();
                  }


                  if (widget.news != null) {
                    await provider.update(widget.news!.id!, formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.newsArticleUpdatedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    await provider.insert(formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.newsArticleCreatedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }

                  Navigator.pop(context, true);
                } catch (e) {
                  String errorMessage = e.toString();
                  String displayMessage;

                  if (errorMessage.startsWith('Exception: ')) {
                    errorMessage = errorMessage.substring('Exception: '.length);
                  }

                  if (errorMessage.contains('Publish date cannot be in the future')) {
                    displayMessage = l10n.publishDateCannotBeInFuture;
                  } else if (errorMessage.contains('Event date is required for events')) {
                    displayMessage = l10n.eventDateRequired;
                  } else if (errorMessage.contains('News articles cannot have an event date')) {
                    displayMessage = l10n.newsCannotHaveEventDate;
                  } else {
                    displayMessage = errorMessage;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(displayMessage),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5), 
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(widget.news == null ? l10n.addNewsArticle : l10n.updateNewsArticle),
          ),
        ],
      ),
    );
  }
} 
