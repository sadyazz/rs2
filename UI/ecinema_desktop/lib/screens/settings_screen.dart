import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.settings, SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.manageYourApplicationPreferences ?? 'Manage your application preferences and system configuration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          // Settings Categories
          _buildSettingsSection(
            title: l10n.adminProfile,
            icon: Icons.person,
            children: [
              _buildInfoTile(
                title: l10n.username,
                subtitle: 'admin',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, l10n.username, 'admin'),
                ),
              ),
              _buildInfoTile(
                title: l10n.fullName,
                subtitle: 'Administrator',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, l10n.fullName, 'Administrator'),
                ),
              ),
              _buildInfoTile(
                title: l10n.email ?? 'Email',
                subtitle: 'admin@ecinema.com',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, l10n.email ?? 'Email', 'admin@ecinema.com'),
                ),
              ),
              _buildInfoTile(
                title: l10n.phone ?? 'Phone',
                subtitle: '+387 33 123 456',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, l10n.phone ?? 'Phone', '+387 33 123 456'),
                ),
              ),
              _buildInfoTile(
                title: l10n.role,
                subtitle: 'System Administrator',
                trailing: const Icon(Icons.admin_panel_settings, color: Colors.grey),
              ),
              _buildInfoTile(
                title: l10n.lastLogin,
                subtitle: '2024-01-15 14:30',
                trailing: const Icon(Icons.access_time, color: Colors.grey),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSettingsSection(
            title: l10n.contentManagement,
            icon: Icons.category,
            children: [
              _buildManagementTile(
                title: l10n.genres,
                subtitle: l10n.manageMovieGenres ?? 'Manage movie genres and categories',
                icon: Icons.theater_comedy,
                onTap: () => _navigateToGenres(),
              ),
              _buildManagementTile(
                title: l10n.actors,
                subtitle: l10n.manageActors ?? 'Manage actors and performers',
                icon: Icons.person,
                onTap: () => _navigateToActors(),
              ),
              _buildManagementTile(
                title: l10n.screeningFormats,
                subtitle: l10n.manageScreeningFormats ?? 'Manage 3D, IMAX, and other formats',
                icon: Icons.aspect_ratio,
                onTap: () => _navigateToScreeningFormats(),
              ),
              _buildManagementTile(
                title: l10n.halls,
                subtitle: l10n.manageHalls ?? 'Manage cinema halls and seating',
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
                subtitle: l10n.manageUsers ?? 'Manage system users and permissions',
                icon: Icons.people,
                onTap: () => _navigateToUsers(),
              ),
              _buildManagementTile(
                title: l10n.roles,
                subtitle: l10n.manageRoles ?? 'Manage user roles and access levels',
                icon: Icons.security,
                onTap: () => _navigateToRoles(),
              ),
              _buildManagementTile(
                title: l10n.newsArticles,
                subtitle: l10n.manageNewsArticles ?? 'Manage news and announcements',
                icon: Icons.article,
                onTap: () => _navigateToNews(),
              ),
              _buildManagementTile(
                title: l10n.promotions,
                subtitle: l10n.managePromotions ?? 'Manage promotional offers and discounts',
                icon: Icons.local_offer,
                onTap: () => _navigateToPromotions(),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save),
                  label: Text(l10n.saveSettings ?? 'Save Settings'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetSettings,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.resetToDefault ?? 'Reset to Default'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
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

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
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

  void _showEditDialog(BuildContext context, String title, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you would typically save the new value
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveSettings() {
    // Here you would typically save all settings to persistent storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text('Are you sure you want to reset all settings to their default values?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset admin profile to default values
                setState(() {
                  // Reset admin profile fields if needed
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to default'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToGenres() {
    // TODO: Navigate to genres management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Genres management - Coming soon')),
    );
  }

  void _navigateToActors() {
    // TODO: Navigate to actors management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Actors management - Coming soon')),
    );
  }

  void _navigateToScreeningFormats() {
    // TODO: Navigate to screening formats management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Screening formats management - Coming soon')),
    );
  }

  void _navigateToHalls() {
    // TODO: Navigate to halls management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Halls management - Coming soon')),
    );
  }

  void _navigateToUsers() {
    // TODO: Navigate to users management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Users management - Coming soon')),
    );
  }

  void _navigateToRoles() {
    // TODO: Navigate to roles management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Roles management - Coming soon')),
    );
  }

  void _navigateToNews() {
    // TODO: Navigate to news management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('News management - Coming soon')),
    );
  }

  void _navigateToPromotions() {
    // TODO: Navigate to promotions management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Promotions management - Coming soon')),
    );
  }
}
