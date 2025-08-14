import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/role.dart';
import 'package:ecinema_desktop/providers/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditRoleScreen extends StatefulWidget {
  final Role? role;

  const EditRoleScreen({super.key, this.role});

  @override
  State<EditRoleScreen> createState() => _EditRoleScreenState();
}

class _EditRoleScreenState extends State<EditRoleScreen> {
  late RoleProvider provider;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;
  bool _mounted = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<RoleProvider>();
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.role != null;
    if (_isEditing) {
      _nameController.text = widget.role!.name ?? '';
    }
  }

  Future<void> _saveRole() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final request = {
        'name': _nameController.text.trim(),
      };

              if (_isEditing) {
          await provider.update(widget.role!.id!, request);
          if (_mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.roleUpdatedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          await provider.insert(request);
          if (_mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.roleCreatedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

      if (_mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.failedToDeleteRole}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.role != null;
    
    return MasterScreen(
      isEditing ? l10n.editRole : l10n.addRole,
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.roleName,
                border: const OutlineInputBorder(),
              ),
                              validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.roleNameRequired;
                  }
                  if (value.trim().length > 50) {
                    return l10n.roleNameTooLong;
                  }
                  return null;
                },
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
            onPressed: _isLoading ? null : _saveRole,
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

  @override
  void dispose() {
    _mounted = false;
    _nameController.dispose();
    super.dispose();
  }
}
