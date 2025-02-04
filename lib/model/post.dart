import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String username;
  final  datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes
  });

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'uid': uid,
        'description': description,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'postId': postId,
        'likes' : likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'] ,
      profImage:snapshot['profImage'] ,
      likes: snapshot['likes']
    );
  }
}
