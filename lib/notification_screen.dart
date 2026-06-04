import 'package:first_app/styles/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  List<Map<String, dynamic>> notifications = [
  {'title': 'Notification 1', 'name': 'John Doe', 'icon': Icons.notification_important},
  {'title': 'Notification 2', 'name': 'Jane Doe', 'icon': Icons.notification_important},
  {'title': 'Notification 3', 'name': 'Bob Smith', 'icon': Icons.notification_important},
  // Add more notifications as needed
];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final appBarBackgroundColor = theme.appBarTheme.backgroundColor ?? (theme.brightness == Brightness.dark ? Colors.black : Colors.white);
    final appBarTextColor = theme.appBarTheme.titleTextStyle?.color ?? ( theme.brightness == Brightness.dark ? Colors.white : Colors.black);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification',style: TextStyle(color: textColor),),
        centerTitle: true,

        backgroundColor: appBarBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new ,color: appBarTextColor,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: textColor), // Adjust border color
            ),
            elevation: 5, // Adjust elevation as needed
            margin: const EdgeInsets.all(10), // Adjust margin as needed
            child: ListTile(
              title: Text(notifications[index]['title'],style: TextStyle(color: textColor),),
              subtitle: Text('Name: ${notifications[index]['name']}',style: TextStyle(color: textColor),),
              leading: Icon(notifications[index]['icon']),
            ),
          );
        },
      ),
    );
  }
}
