
// លំហាត់អនុវត្ត (៣០–៤៥ នាទី)
// ១) បង្កើត project ថ្មី ហើយសរសេរ Screen មាន៖

// AppBar + ListView

// ធាតុ Card មួយចំនួន (ប្រើ Card ឬ Container មាន shadow)

// ប៊ូតុងមួយចុចហើយ setState ផ្លាស់ប្តូរអត្ថបទ ឬ icon។

// ២) បំបែក Widget ជា component តូចៗ (ដូច RN):

// ProfileCard, ProductTile, SectionHeader ជា StatelessWidget ទទួល parameter តាម constructor។

// ៣) អនុវត្ត null safety ឲ្យច្បាស់៖ ប្រើ ?, ??, ! ត្រូវកន្លែង។


import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  String? _favoriteStatus; 
  bool _isLiked = false;

  void _toggleFavorite() {
    setState(() {
      _isLiked = !_isLiked;
      // ប្រើ ?? (Null Coalescing) បើសិនជា null ឲ្យទៅជាពាក្យលំនាំដើម
      _favoriteStatus = _isLiked ? 'បានចូលចិត្ត!' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('លំហាត់អនុវត្ត Flutter'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SectionHeader(title: 'ប្រវត្តិរូបសង្ខេប'),
    
          const ProfileCard(
            name: 'សុខ ជា',
            role: 'Mobile Developer',
            imageUrl: null, // សាកល្បងហុចតម្លៃ null ដើម្បីតេស្ត Null Safety
          ),
          
          const SizedBox(height: 20),
          const SectionHeader(title: 'ផលិតផលពេញនិយម'),
          
          const ProductTile(
            title: 'ទូរស័ព្ទដៃជំនាន់ថ្មី',
            price: 999.99,
          ),
                    
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                  label: const Text('ចូលចិត្ត'),
                ),
                const SizedBox(height: 10),
                Text(
                  _favoriteStatus ?? 'សូមចុចប៊ូតុងដើម្បីចូលចិត្ត',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
   return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),);
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl;

  const ProfileCard({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null ? const Icon(Icons.person, size: 30) : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(role, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String title;
  final double price;

  const ProductTile({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title),
        subtitle: Text('\$${price.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}