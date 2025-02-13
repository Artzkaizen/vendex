import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildListTile(context, Icons.person, 'Personal Details', PersonalDetailsScreen()),
          _buildListTile(context, Icons.shopping_bag, 'My Orders', MyOrdersScreen()),
          _buildListTile(context, Icons.privacy_tip, 'Privacy Settings', PrivacySettingsScreen()),
          _buildListTile(context, Icons.notifications, 'Notifications', NotificationsScreen()),
          _buildActionTile(context, Icons.help, 'Help', _handleHelp),
          _buildActionTile(context, Icons.logout, 'Log Out', _handleLogOut),
          _buildActionTile(context, Icons.close, 'Close Account', _handleCloseAccount),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String title, Function(BuildContext) action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => action(context),
    );
  }

  void _handleHelp(BuildContext context){
    const SnackBar(content: Text("Help"));
  }

  void _handleLogOut(BuildContext context) {
          const SnackBar(content: Text("Logged out"));
  }

  void _handleCloseAccount(BuildContext context) {
          const SnackBar(content: Text("Account closed"));
  }
}

// Screens

class PersonalDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
             decoration: InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(labelText: "Last Name"),
               ),
            const SizedBox(height: 10),
            const TextField(
            obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Details saved")),
                  );
                },
                child: const Text("Save"),
              ),),
          ],
        ),
      ),
    );
  }
}

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView(
            children: [
              _buildListTile(context, Icons.shopping_bag, "Order History", OrderHistoryScreen()),
              _buildListTile(context, Icons.shopping_bag, "Payment Information", PaymentInformationScreen()),
            ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Order Number: #12345", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Items: Pen"),
                  const SizedBox(height: 8),
                  const Text("Vending Machine: Building A - 3rd Floor"),
                  const SizedBox(height: 8),
                  const Text("Order Date: 12 Feb 2025"),
                  const SizedBox(height: 8),
                  const Text("Order Total: \$5.99", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Name"),
            const SizedBox(height: 12),
            _buildTextField("Last Name"),
            const SizedBox(height: 12),
            _buildTextField("Card Number", keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            _buildTextField("Expiration Date (MM/YY)", keyboardType: TextInputType.datetime),
            const SizedBox(height: 12),
            _buildTextField("CVV", keyboardType: TextInputType.number, obscureText: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: const Center(child: Text('Privacy Settings View')),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _reminderNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationToggle("Push Notifications", _pushNotifications, (value) {
              setState(() {
                _pushNotifications = value;
              });
            }),
            _buildNotificationToggle("Order Updates", _orderUpdates, (value) {
              setState(() {
                _orderUpdates = value;
              });
            }),
            _buildNotificationToggle("Reminder Notifications", _reminderNotifications, (value) {
              setState(() {
                _reminderNotifications = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(String label, bool currentValue, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: currentValue,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }
}

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: const Center(child: Text('Help View')),
    );
  }
}
