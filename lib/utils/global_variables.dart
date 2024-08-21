import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/add_post.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

  List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPost(),
  Center(child: Text('fav')),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];