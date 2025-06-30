import 'package:ecinema_desktop/screens/dashboard_screen.dart';
import 'package:ecinema_desktop/screens/movies_list_screen.dart';
import 'package:ecinema_desktop/screens/screenings_list_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {super.key});

  String? title;
  Widget? child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              // Main menu items
              Expanded(
                child: ListView(
                  children: [
                    _buildListTile(
                      icon: Icons.arrow_back,
                      title: "Back",
                      isBackButton: true,
                    ),
                    _buildListTile(
                      icon: Icons.dashboard,
                      title: "Dashboard",
                    ),
                    _buildListTile(
                      icon: Icons.movie,
                      title: "Movies",
                    ),
                    _buildListTile(
                      icon: Icons.schedule,
                      title: "Screenings",
                    ),
                    _buildListTile(
                      icon: Icons.event_seat,
                      title: "Seats & Halls",
                    ),
                    _buildListTile(
                      icon: Icons.article,
                      title: "News",
                    ),
                    _buildListTile(
                      icon: Icons.people,
                      title: "Users",
                    ),
                    _buildListTile(
                      icon: Icons.rate_review,
                      title: "Reviews",
                    ),
                    _buildListTile(
                      icon: Icons.analytics,
                      title: "Reports",
                    ),
                    _buildListTile(
                      icon: Icons.settings,
                      title: "Settings",
                    ),
                  ],
                ),
              ),
              
              // Divider
              Divider(
                color: Colors.white.withOpacity(0.3),
                height: 32,
              ),
              
              // Logout button at bottom
              _buildListTile(
                icon: Icons.logout,
                title: "Logout",
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    bool isBackButton = false,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Close drawer first
            Navigator.pop(context);
            
            if (isBackButton) {
              Navigator.pop(context);
              return;
            }
            
            if (isLogout) {
              Navigator.of(context).pushReplacementNamed('/login');
              return;
            }
            
            // Navigation logic
            switch (title.toLowerCase()) {
              case 'dashboard':
                Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                break;
              case 'movies':
                Navigator.push(context, MaterialPageRoute(builder: (context) => MoviesListScreen()));
                break;
              case 'screenings':
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScreeningsListScreen()));
                break;
              case 'seats & halls':
                // Navigate to seats & halls
                break;
              case 'news':
                // Navigate to news
                break;
              case 'users':
                // Navigate to users
                break;
              case 'reviews':
                // Navigate to reviews
                break;
              case 'reports':
                // Navigate to reports
                break;
              case 'settings':
                // Navigate to settings
                break;
            }
          },
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isBackButton ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: isBackButton ? 20 : 24,
            ),
          ),
        ),
      ),
    );
  }
}