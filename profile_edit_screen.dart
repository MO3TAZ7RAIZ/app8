import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'database_helper.dart';

class ProfileEditScreen extends StatefulWidget {
  final AuthService authService;
  final String username;

  const ProfileEditScreen({
    Key? key,
    required this.authService,
    required this.username,
  }) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late Map<String, dynamic> _userData;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await DatabaseHelper.instance.getUserComplete(widget.username);
    setState(() {
      _userData = data ?? {};
      _initializeControllers();
      _isLoading = false;
    });
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController(text: _userData['full_name'] ?? '');
    _emailController = TextEditingController(text: _userData['email'] ?? '');
    _phoneController = TextEditingController(text: _userData['phone'] ?? '');
    _emergencyPhoneController = TextEditingController(text: _userData['emergency_phone'] ?? '');
    _addressController = TextEditingController(text: _userData['address'] ?? '');
    _cityController = TextEditingController(text: _userData['city'] ?? '');
    _stateController = TextEditingController(text: _userData['state'] ?? '');
    _zipCodeController = TextEditingController(text: _userData['zip_code'] ?? '');
    _dobController = TextEditingController(text: _userData['date_of_birth'] ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedData = {
        'username': widget.username,
        'full_name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'emergency_phone': _emergencyPhoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'zip_code': _zipCodeController.text.trim(),
        'date_of_birth': _dobController.text.trim(),
      };

      final success = await widget.authService.updateUser(updatedData);

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Personal Information
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),

                    SizedBox(height: 24),
                    // Contact Information
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emergencyPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Emergency Phone',
                        prefixIcon: Icon(Icons.emergency),
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 24),
                    // Address Information
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.home),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              prefixIcon: Icon(Icons.location_city),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: InputDecoration(
                              labelText: 'State',
                              prefixIcon: Icon(Icons.map),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: InputDecoration(
                        labelText: 'ZIP Code',
                        prefixIcon: Icon(Icons.markunread_mailbox),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}