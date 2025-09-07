import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/user.dart';
import 'package:ecinema_desktop/models/role.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/user_provider.dart';
import 'package:ecinema_desktop/providers/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/utils.dart';

class EditUserScreen extends StatefulWidget {
  final User? user;

  const EditUserScreen({super.key, this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late UserProvider userProvider;
  late RoleProvider roleProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _isEditing = false;
  bool _mounted = true;
  bool _isPasswordVisible = false;
  SearchResult<Role>? rolesResult;
  Map<String, dynamic> _initialValue = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    roleProvider = context.read<RoleProvider>();
    _loadRoles();
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.user != null;
  }

  Future<void> _loadRoles() async {
    try {
      rolesResult = await roleProvider.get();
      
      _initialValue = {
        'firstName': widget.user?.firstName ?? '',
        'lastName': widget.user?.lastName ?? '',
        'email': widget.user?.email ?? '',
        'username': widget.user?.username ?? '',
        'phoneNumber': widget.user?.phoneNumber ?? '',
        'password': '',
        'isDeleted': widget.user?.isDeleted ?? false,
      };
      
      if (widget.user != null && widget.user!.role != null) {
        _initialValue['roleId'] = widget.user!.role!.id?.toString();
      } else {
        _initialValue['roleId'] = '1';
      }
      if (_mounted) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_formKey.currentState != null) {
            _formKey.currentState!.patchValue(_initialValue);
          }
        });
      }
    } catch (e) {
      print('Error loading roles: $e');
    }
  }

  Future<void> _saveUser() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    if (_mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final formData = _formKey.currentState!.value;
      
      if (_isEditing) {
        final request = {
          'firstName': widget.user!.firstName,
          'lastName': widget.user!.lastName,
          'email': widget.user!.email,
          'username': widget.user!.username,
          'phoneNumber': widget.user!.phoneNumber,
          'password': '',
          'isDeleted': formData['isDeleted'] ?? false,
          'roleId': int.parse(formData['roleId']),
        };
        await userProvider.update(widget.user!.id!, request);
        if (_mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.userUpdatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final request = {
          'firstName': formData['firstName'],
          'lastName': formData['lastName'],
          'email': formData['email'],
          'username': formData['username'],
          'phoneNumber': formData['phoneNumber'],
          'password': formData['password'],
          'roleId': int.parse(formData['roleId']),
        };
        await userProvider.insert(request);
        if (_mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.userCreatedSuccessfully),
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
            content: Text(l10n.failedToSaveUser(e.toString())),
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
    final isEditing = widget.user != null;
    
    return MasterScreen(
      isEditing ? l10n.editUser : l10n.addUser,
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
        initialValue: _initialValue,
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
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                                                          Text(
                                l10n.user,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.user?.image != null && widget.user!.image!.isNotEmpty
                              ? imageFromString(widget.user!.image!)
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                  ),
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
                      if (!isEditing) ...[
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'firstName',
                                decoration: InputDecoration(
                                  labelText: l10n.firstName,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: l10n.pleaseEnterFirstName),
                                ]),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'lastName',
                                decoration: InputDecoration(
                                  labelText: l10n.lastName,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: l10n.pleaseEnterLastName),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            border: const OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: l10n.pleaseEnterEmail),
                            FormBuilderValidators.email(errorText: l10n.pleaseEnterValidEmail),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'username',
                                decoration: InputDecoration(
                                  labelText: l10n.username,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: l10n.pleaseEnterUsername),
                                  FormBuilderValidators.minLength(3, errorText: l10n.usernameMinLength),
                                  FormBuilderValidators.match(RegExp(r'^[a-zA-Z0-9_]+$'), errorText: l10n.usernameInvalid),
                                ]),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'phoneNumber',
                                decoration: InputDecoration(
                                  labelText: l10n.phoneNumber,
                                  border: const OutlineInputBorder(),
                                  helperText: l10n.phoneNumberFormat,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.match(
                                    RegExp(r'^\+?[\d\s-]+$'),
                                    errorText: l10n.phoneNumberInvalid,
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                            labelText: l10n.password,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: l10n.pleaseEnterPassword),
                            FormBuilderValidators.minLength(6, errorText: l10n.passwordMinLength),
                          ]),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'firstName',
                                decoration: InputDecoration(
                                  labelText: l10n.firstName,
                                  border: const OutlineInputBorder(),
                                ),
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'lastName',
                                decoration: InputDecoration(
                                  labelText: l10n.lastName,
                                  border: const OutlineInputBorder(),
                                ),
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            border: const OutlineInputBorder(),
                          ),
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'username',
                                decoration: InputDecoration(
                                  labelText: l10n.username,
                                  border: const OutlineInputBorder(),
                                ),
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'phoneNumber',
                                decoration: InputDecoration(
                                  labelText: l10n.phoneNumber,
                                  border: const OutlineInputBorder(),
                                ),
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      FormBuilderDropdown(
                        name: 'roleId',
                        decoration: InputDecoration(
                          labelText: l10n.role,
                          border: const OutlineInputBorder(),
                        ),
                        items: rolesResult?.items?.map((role) => DropdownMenuItem(
                          value: role.id.toString(),
                          child: Text(role.name ?? ''),
                        )).toList() ?? [],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.roleNameRequired),
                        ]),
                      ),
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
            onPressed: _isLoading ? null : _saveUser,
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
    super.dispose();
  }
}
