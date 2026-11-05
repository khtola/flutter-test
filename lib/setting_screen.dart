import 'dart:io';
import 'package:first_app/api/api_config.dart';
import 'package:first_app/controllers/nav_controller.dart';
import 'package:first_app/controllers/theme_controller.dart';
import 'package:first_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File? _profileImage; // សម្រាប់រក្សាទុករូបភាពដែលបានរើស
  final ImagePicker _picker = ImagePicker();

  // មុខងារសម្រាប់រើសរូបភាពពីទូរស័ព្ទ
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // អាចដូរជា ImageSource.camera បើចង់ថតផ្ទាល់
      imageQuality: 80, // កាត់បន្ថយទំហំរូបភាពកុំឱ្យធំពេក
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
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
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(Icons.person,
                                  size: 65, color: Colors.grey[600])
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ApiConfig.demoUsername, // បង្ហាញឈ្មោះ Demo ឬអាចប្តូរតាមចិត្តបាន
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SectionTitle('Common', textStyle: titleStyle),
              SettingsItem(
                Icon(Icons.language, color: iconColor),
                'Language',
                'English',
                onTap: () => _showLanguageDialog(context),
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
                '${ApiConfig.demoUsername} / ${ApiConfig.demoPassword}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                titleStyle: titleStyle,
                valueStyle: valueStyle,
              ),
              SettingsItem(
                Icon(Icons.local_shipping, color: iconColor),
                'My orders',
                'Track delivery',
                onTap: () => Get.find<NavController>().goTo(1),
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
          color: Colors
              .transparent, // Make the container transparent to detect taps
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
      {super.key,
      required this.onTap,
      required this.titleStyle,
      required this.valueStyle});

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
