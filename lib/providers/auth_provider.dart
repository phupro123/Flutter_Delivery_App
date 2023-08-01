import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_final/model/user_model.dart';
// import 'package:project_final/screens/otp_screen.dart';
import 'package:project_final/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  dynamic _number = 0;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  dynamic get number {
    return _number;
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }
  void editUser({

    required Map<Object,Object> data1,
  }) async {
    try {
      // Get Array

      await _firebaseFirestore.collection("users").doc(_firebaseAuth.currentUser!.uid).update(data1);


      getDataFromFirestore().then(
            (value) =>
            saveUserDataToSP().then(
                  (value) =>
                  null
            ),
      );
    } on FirebaseAuthException catch (e) {


      notifyListeners();
    }
  }
  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }
  void setNumberCart() async{

    await _firebaseFirestore
        .collection("carts")
        .doc(_userModel?.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
           var array = snapshot['arrayCart'];
           var sum = 0;
           var a = array.map((e) async {
            sum =  e['quantity'] + sum;
            return 1;
          });
           print(a);
           _number = sum;

           notifyListeners();

    });
  }
  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => OtpScreen(verificationId: verificationId),
            //   ),
            // );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;

        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }
// DATABASE OPERTAIONS
  Future<bool> checkLogin(String name, String pass) async {
    QuerySnapshot snapshot =
    await _firebaseFirestore.collection("users").where('email', isEqualTo:name).where('pass', isEqualTo:pass).get();
    var flag = 0;
    for (var docSnapshot in snapshot.docs) {
      flag = 1;
    }
    if (flag == 1) {
      return true;
    } else {
      return false;
    }
  }
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel = userModel;

      await _firebaseFirestore
          .collection("carts")
          .doc(userModel.uid)
          .set({'arrayCart': FieldValue.arrayUnion([])});


      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }
  void saveUserDataToFirebase2({
    required BuildContext context,
    required UserModel userModel,

  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userModel = userModel;
      await _firebaseFirestore
          .collection("carts")
          .doc(userModel.uid)
          .set({'arrayCart': FieldValue.arrayUnion([])});

      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {

        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }
  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
        pass: snapshot['pass']
      );
      _uid = userModel.uid;
    });
  }
  Future getDataFromFirestore2(String email, String pass) async {
    QuerySnapshot docsnapshot =
    await _firebaseFirestore.collection("users").where('email', isEqualTo:email).where('pass', isEqualTo:pass).get();

    for (var snapshot in docsnapshot.docs) {
      _userModel = UserModel(
          name: snapshot['name'],
          email: snapshot['email'],
          createdAt: snapshot['createdAt'],
          bio: snapshot['bio'],
          uid: snapshot['uid'],
          profilePic: snapshot['profilePic'],
          phoneNumber: snapshot['phoneNumber'],
          pass: snapshot['pass']
      );
      _uid = userModel.uid;
    }

  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));

    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
