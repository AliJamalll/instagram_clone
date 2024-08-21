import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///adding image to firebase storage
  Future<String> uploadImageToStorage(String childName,Uint8List? file, bool isPost)async{
    ///ref is a pointer to a file
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadtask = ref.putData(file!);

    TaskSnapshot snap = await uploadtask;
    String download = await snap.ref.getDownloadURL();
    return download;
  }

}