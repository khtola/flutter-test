import 'package:first_app/controllers/theme_controller.dart';
import 'package:first_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: Obx(() {
        bool isDarkModeEnabled = themeController.isDarkMode.value;
        Color textColor = isDarkModeEnabled ? Colors.white : Colors.black;
        Color iconColor = isDarkModeEnabled ? Colors.white : Colors.black;
        Color backgroundColor = isDarkModeEnabled ? Colors.black : Colors.white;

        TextStyle titleStyle = TextStyle(
          color: textColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        );

        TextStyle valueStyle = TextStyle(
          color: isDarkModeEnabled ? Colors.white70 : Colors.black54,
        );

        return Container(
          color: backgroundColor,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SectionTitle('Common', textStyle: titleStyle),
              SettingsItem(
                Icon(Icons.language, color: iconColor),
                'Language',
                'English',
                onTap: ()=> _showLanguageDialog(context),
                titleStyle: titleStyle,
                valueStyle: valueStyle,
              ),
              SettingsItem(
                Icon(
                  isDarkModeEnabled ? Icons.dark_mode : Icons.light_mode,
                  color: isDarkModeEnabled ? Colors.yellow : Colors.blue,
                ),
                'Theme',
                isDarkModeEnabled ? 'Dark' : 'Light',
                onTap: themeController.toggleTheme,
                titleStyle: titleStyle,
                valueStyle: valueStyle,
              ),
              SectionTitle('Account', textStyle: titleStyle),
              SettingsItem(
                Icon(Icons.lock, color: iconColor),
                'Login',
                '',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                titleStyle: titleStyle,
                valueStyle: valueStyle,
              ),
        
              SectionTitle('Security', textStyle: titleStyle),
              SettingsItem(
                Icon(Icons.key, color: iconColor),
                'Lock app in background',
                '',
                onTap: () => _showPasswordDialog(context),
                titleStyle: titleStyle,
                valueStyle: valueStyle,
              ),
              SettingsItem(
                Icon(Icons.password, color: iconColor),
                'Two-Factor Auth',
                'Enabled',
                onTap: () => _showTwoFactorAuthDialog(context, backgroundColor),
                titleStyle: titleStyle,
                valueStyle: valueStyle,
              ),
            ],
          ),
        );
      }),
    );
  }
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LanguageDialog();
    },
  );
}
void _showTwoFactorAuthDialog(BuildContext context, Color backgroundColor) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.transparent, // Make the container transparent to detect taps
          child: Column(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Top Button'),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Two-Factor Authentication settings go here.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showPasswordDialog(BuildContext context) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(hintText: "Enter old password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(hintText: "Enter new password"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle the password change
              print('Old password: ${oldPasswordController.text}');
              print('New password: ${newPasswordController.text}');
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final TextStyle textStyle;

  const SectionTitle(this.title, {super.key, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget leadingIcon;
  final VoidCallback onTap;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  const SettingsItem(this.leadingIcon, this.title, this.value,
      {super.key, required this.onTap, required this.titleStyle, required this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: leadingIcon,
        title: Text(title, style: titleStyle),
        subtitle: Text(value, style: valueStyle),
        onTap: onTap,
      ),
    );
  }
}

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: const Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Khmer'),
                value: 'Khmer',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      // Save the selected language to shared preferences or other storage
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}