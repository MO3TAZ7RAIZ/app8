import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'database_helper.dart';
import 'profile_edit_screen.dart';  // Add this import

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final String username;

  const HomeScreen({
    Key? key,
    required this.authService,
    required this.username,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await DatabaseHelper.instance.getUserComplete(widget.username);
    setState(() {
      _userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(
                    authService: widget.authService,
                    username: widget.username,
                  ),
                ),
              );
              
              if (result == true) {
                // Reload data if profile was updated
                _loadUserData();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard('Personal Information', [
                    _buildInfoItem('Full Name', _userData!['full_name']),
                    _buildInfoItem('Date of Birth', _userData!['date_of_birth']),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoCard('Account Information', [
                    _buildInfoItem('Username', _userData!['username']),
                    _buildInfoItem('Email', _userData!['email']),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoCard('Contact Information', [
                    _buildInfoItem('Phone', _userData!['phone']),
                    _buildInfoItem('Emergency Contact', _userData!['emergency_phone']),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoCard('Address Information', [
                    _buildInfoItem('Address', _userData!['address']),
                    _buildInfoItem('City', _userData!['city']),
                    _buildInfoItem('State', _userData!['state']),
                    _buildInfoItem('ZIP Code', _userData!['zip_code']),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'Not provided'),
          ),
        ],
      ),
    );
  }
}