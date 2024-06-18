import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FeesReceiptUpload extends StatefulWidget {
  final String userEmail;

  const FeesReceiptUpload({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _FeesReceiptUploadState createState() => _FeesReceiptUploadState();
}

class _FeesReceiptUploadState extends State<FeesReceiptUpload> {
  String? _uploadedImageName;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUploadedImageName();
  }

  Future<void> _loadUploadedImageName() async {
    final String userEmail = widget.userEmail;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('studs_bus_fees_receipts')
        .doc(userEmail)
        .get();

    if (userDoc.exists) {
      final List<dynamic>? images = userDoc.get('images');
      if (images != null && images.isNotEmpty) {
        setState(() {
          _uploadedImageName = images.last['fileName'];
        });
      }
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<void> _getImage() async {
    if (await _requestPermission(Permission.photos)) {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        String fileName = pickedFile.name;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Upload'),
            content: const Text('Do you want to upload this image?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _uploadImageToFirebase(File(pickedFile.path), fileName);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      }
    } else {
      // Handle case when permission is not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access gallery is denied.')),
      );
    }
  }

  Future<void> _uploadImageToFirebase(File imageFile, String fileName) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String userEmail = widget.userEmail;
      final Reference storageRef =
          storage.ref().child('studs_bus_fees_receipts/$userEmail/$fileName');

      final UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      await _addImageDetailsToFirestore(userEmail, fileName, downloadUrl);

      setState(() {
        _uploadedImageName = fileName;
        _uploadProgress = 1.0;
      });
    } catch (error) {
      print('Failed to upload image: $error');
    }
  }

  Future<void> _addImageDetailsToFirestore(
      String userEmail, String fileName, String downloadUrl) async {
    try {
      final CollectionReference imagesCollection =
          FirebaseFirestore.instance.collection('studs_bus_fees_receipts');

      await imagesCollection.doc(userEmail).set({
        'images': FieldValue.arrayUnion([
          {
            'fileName': fileName,
            'downloadUrl': downloadUrl,
          }
        ]),
      }, SetOptions(merge: true));
    } catch (error) {
      print('Failed to add image details to Firestore: $error');
    }
  }

  void _viewImage(BuildContext context) async {
    if (_uploadedImageName != null) {
      try {
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String userEmail = widget.userEmail;
        final Reference storageRef = storage
            .ref()
            .child('studs_bus_fees_receipts/$userEmail/$_uploadedImageName');
        final String downloadUrl = await storageRef.getDownloadURL();

        _showImageOptionsDialog(context, downloadUrl);
      } catch (error) {
        print('Failed to download image: $error');
      }
    }
  }

  void _showImageOptionsDialog(BuildContext context, String downloadUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _viewImageInDialog(context, downloadUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: const Text('View'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadImage(downloadUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: const Text('Download'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewImageInDialog(BuildContext context, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
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

  void _downloadImage(String downloadUrl) async {
    try {
      await launch(downloadUrl);
    } catch (error) {
      print('Failed to download image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Receipt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Upload Your Receipt',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _getImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Upload Receipt'),
            ),
            if (_uploadProgress > 0 && _uploadProgress < 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(value: _uploadProgress),
              ),
            if (_uploadedImageName != null)
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  const Center(
                    child: Text(
                      'Uploaded Image Name:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: InkWell(
                      onTap: () => _viewImage(context),
                      child: Text(
                        _uploadedImageName!,
                        style:
                            const TextStyle(fontSize: 16.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
