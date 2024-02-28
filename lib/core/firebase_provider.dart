import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authProvider = Provider((ref) => FirebaseAuth.instance);

final storageProvider = Provider((ref) => FirebaseStorage.instance);

final googleSignInProvider = Provider((ref) => GoogleSignIn(
    scopes: ['profile', 'email'],
    clientId: Platform.isIOS
        ? '835474148480-81mvj92hhksksbsqd5c9k717coa6vm92.apps.googleusercontent.com'
        : null));
