// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clonee/model/post.dart';
import 'package:instagram_clonee/resouces/storage_methods.dart';
import 'package:instagram_clonee/utils/utils.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

class FirestoreMethod{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///upload a post
  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
     // String postId,
      String profImage,
      )async{
    String res = 'some error occurred';
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage(
          'posts',
          file,
          true
      );

      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          postId: postId,
          username: username,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    }catch (e){
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId,String uid,List likes)async{
    try{
       if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
           'likes' : FieldValue.arrayRemove([uid])
         });
       }else{
         await _firestore.collection('posts').doc(postId).update({
           'likes' : FieldValue.arrayUnion([uid])
         });
       }
    }catch (e){
      print(e.toString());
    }
  }

  Future<void> postComment(String postId,String text,String uid,String name,String profilePic)async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
       await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic' : profilePic,
          'name' : name,
          'uid' : uid,
          'text' : text,
          'commentId' : commentId,
          'datePublished' : DateTime.now()
            });
      }else{
        print('text is empty');
      }
    }catch(e){
     print(e.toString());
    }
  }

  ///deleting method
  Future<void> deletePost(String postId)async{
    try{
     await _firestore.collection('posts').doc(postId).delete();
    }catch (e){
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}

// class FirestoreMethod {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   ///upload a post
//   Future<String> uploadPost(
//       String description,
//       Uint8List file,
//       String uid,
//       String username,
//       String profImage,
//       ) async {
//     String res = 'some error occurred';
//     try {
//       String photoUrl = await StorageMethods().uploadImageToStorage(
//         'posts',
//         file,
//         true,
//       );
//
//       String postId = const Uuid().v1();
//
//       Post post = Post(
//         description: description,
//         uid: uid,
//         postId: postId,
//         username: username,
//         datePublished: DateTime.now(),
//         postUrl: photoUrl,
//         profImage: profImage,
//         likes: [],
//       );
//
//       await _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = 'success';
//     } catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }
// }
