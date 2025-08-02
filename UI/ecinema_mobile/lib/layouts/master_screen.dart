import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/home_screen.dart';
import '../screens/tickets_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {
    super.key,
    this.showAppBar = true,
    this.showBackButton = false,
    this.transparentAppBar = false,
    this.showBottomNav = true,
    this.floatingActionButton,
  });

  String? title;
  Widget? child;
  bool showAppBar;
  bool showBackButton;
  bool transparentAppBar;
  bool showBottomNav;
  Widget? floatingActionButton;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TicketsScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final List<String> _titles = [
      'eCinema',
      l10n.tickets,
      l10n.notifications,
      l10n.profile,
    ];
    
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text(widget.title ?? _titles[_currentIndex]),
        backgroundColor: widget.transparentAppBar ? Colors.transparent : const Color(0xFF4F8593),
        foregroundColor: widget.transparentAppBar ? const Color(0xFF4F8593) : Colors.white,
        elevation: widget.transparentAppBar ? 0 : 0,
        centerTitle: false,
        leading: widget.showBackButton 
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: widget.transparentAppBar ? const Color(0xFF4F8593) : Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      ) : null,
      body: widget.child ?? IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: widget.showBottomNav ? Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home),
            _buildNavItem(1, Icons.confirmation_number_outlined, Icons.confirmation_number),
            _buildNavItem(2, Icons.notifications_outlined, Icons.notifications),
            _buildNavItem(3, Icons.person_outline, Icons.person),
          ],
        ),
      ) : null,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 80,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? const Color(0xFF4F8593) : Colors.grey[400],
          size: 28,
        ),
      ),
    );
  }
} 