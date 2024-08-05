import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:global_app/screens/language_selection_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'profile_screen.dart';
import '../generated/l10n.dart'; // Ensure this path is correct

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    print('Current permission status: $permission'); // Debugging line
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
      print('Requested permission status: $permission'); // Debugging line
    }

    if (permission == PermissionStatus.granted) {
      _loadContacts();
    } else {
      setState(() {
        _errorMessage = 'Permission denied';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadContacts() async {
    try {
      List<Contact> contacts = (await ContactsService.getContacts()).toList();
      print('Loaded contacts: $contacts'); // Debugging line
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load contacts: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageSelectionScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text(S.of(context).profile),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = _contacts[index];
                    return ListTile(
                      title: Text(contact.displayName ?? ''),
                    );
                  },
                ),
    );
  }
}
