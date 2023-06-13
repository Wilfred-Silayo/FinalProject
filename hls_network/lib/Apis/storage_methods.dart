import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Adding images to Firebase Storage
  Future<List<String>> uploadImagesToStorage(String childName, List<File> files, bool isPost) async {
    List<String> downloadUrls = [];

    for (int i = 0; i < files.length; i++) {
      File file = files[i];

      // Create the storage reference
      Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
      
     if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Add the download URL to the list
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }
}
