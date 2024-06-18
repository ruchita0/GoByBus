import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeesReceiptAdmin extends StatelessWidget {
  const FeesReceiptAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Receipts'),
      ),
      body: const UserEmailList(),
    );
  }
}

class UserEmailList extends StatefulWidget {
  const UserEmailList({super.key});

  @override
  _UserEmailListState createState() => _UserEmailListState();
}

class _UserEmailListState extends State<UserEmailList> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0), // Add space above the search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search by email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query.toLowerCase();
              });
            },
          ),
        ),
        const SizedBox(height: 8.0), // Add space below the search bar
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('studs_bus_fees_receipts')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;
              final filteredDocs = docs.where((doc) {
                final email = doc.id.toLowerCase();
                return email.contains(_searchQuery);
              }).toList();

              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Text(
                    'Search not found',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final String userEmail = filteredDocs[index].id;

                  return ListTile(
                    title: Text(userEmail),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserImages(userEmail: userEmail),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserImages extends StatelessWidget {
  final String userEmail;

  const UserImages({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipts'),
      ),
      body: UserImageList(userEmail: userEmail),
    );
  }
}

class UserImageList extends StatelessWidget {
  final String userEmail;

  const UserImageList({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('studs_bus_fees_receipts')
          .doc(userEmail)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final images = data?['images'] as List<dynamic>?;

        if (images == null || images.isEmpty) {
          return const Center(child: Text('No images uploaded.'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final image = images[index] as Map<String, dynamic>;
            final fileName = image['fileName'] as String;
            final downloadUrl = image['downloadUrl'] as String;

            return Card(
              child: InkWell(
                onTap: () => _viewImageInDialog(context, downloadUrl),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        downloadUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(fileName),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _viewImageInDialog(BuildContext context, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(downloadUrl),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the image dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade900, // Changed button color
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
