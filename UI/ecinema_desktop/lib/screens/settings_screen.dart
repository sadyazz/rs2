import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/screens/genres_list_screen.dart';
import 'package:ecinema_desktop/screens/actors_list_screen.dart';
import 'package:ecinema_desktop/screens/screening_formats_list_screen.dart';
import 'package:ecinema_desktop/screens/halls_list_screen.dart';
import 'package:ecinema_desktop/screens/users_list_screen.dart';
import 'package:ecinema_desktop/screens/news_list_screen.dart';
import 'package:ecinema_desktop/screens/promotions_list_screen.dart';
import 'package:ecinema_desktop/screens/roles_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ecinema_desktop/providers/user_provider.dart';
import 'package:ecinema_desktop/models/user.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditing = false;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final user = await UserProvider.getCurrentUserProfile();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _usernameController.text = user.username;
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber ?? '';
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final success = await UserProvider.updateUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
      );

      if (success) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        await _loadUserProfile();
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.failedToUpdateProfile(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(
      l10n.settings,
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              l10n.manageYourApplicationPreferences,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),

            _buildSettingsSection(
              title: l10n.adminProfile,
              icon: Icons.person,
              children: [
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.profileInformation,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isEditing)
                        ElevatedButton.icon(
                          onPressed: _toggleEditMode,
                          icon: const Icon(Icons.edit),
                          label: Text(l10n.editProfile),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: l10n.firstName,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: l10n.lastName,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: l10n.phone,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(l10n.saveChanges),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _toggleEditMode,
                            child: Text(l10n.cancel),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: l10n.contentManagement,
              icon: Icons.category,
              children: [
                _buildManagementTile(
                  title: l10n.genres,
                  subtitle: l10n.manageMovieGenres,
                  icon: Icons.theater_comedy,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenresListScreen(),
                      ),
                    );
                  },
                ),
                _buildManagementTile(
                  title: l10n.actors,
                  subtitle: l10n.manageActors,
                  icon: Icons.person,
                  onTap: () => _navigateToActors(),
                ),
                _buildManagementTile(
                  title: l10n.screeningFormats,
                  subtitle: l10n.manageScreeningFormats,
                  icon: Icons.aspect_ratio,
                  onTap: () => _navigateToScreeningFormats(),
                ),
                _buildManagementTile(
                  title: l10n.hallsAndSeats,
                  subtitle: l10n.manageHalls,
                  icon: Icons.event_seat,
                  onTap: () => _navigateToHalls(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: l10n.systemManagement,
              icon: Icons.admin_panel_settings,
              children: [
                _buildManagementTile(
                  title: l10n.users,
                  subtitle: l10n.manageUsers,
                  icon: Icons.people,
                  onTap: () => _navigateToUsers(),
                ),
                _buildManagementTile(
                  title: l10n.newsArticles,
                  subtitle: l10n.manageNewsArticles,
                  icon: Icons.article,
                  onTap: () => _navigateToNews(),
                ),
                _buildManagementTile(
                  title: l10n.promotions,
                  subtitle: l10n.managePromotions,
                  icon: Icons.local_offer,
                  onTap: () => _navigateToPromotions(),
                ),
                _buildManagementTile(
                  title: l10n.roles,
                  subtitle: l10n.manageRoles,
                  icon: Icons.admin_panel_settings,
                  onTap: () => _navigateToRoles(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[600],
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _navigateToActors() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActorsListScreen(),
      ),
    );
  }

  void _navigateToScreeningFormats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScreeningFormatsListScreen(),
      ),
    );
  }

  void _navigateToHalls() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HallsListScreen(),
      ),
    );
  }

  void _navigateToUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsersListScreen(),
      ),
    );
  }

  void _navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewsListScreen(),
      ),
    );
  }

  void _navigateToPromotions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PromotionsListScreen(),
      ),
    );
  }

  void _navigateToRoles() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RolesListScreen(),
      ),
    );
  }
}
