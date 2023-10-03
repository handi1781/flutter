import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class add_pegawai extends StatefulWidget {
  const add_pegawai({super.key});

  @override
  State<add_pegawai> createState() => _add_pegawaiState();
}

class _add_pegawaiState extends State<add_pegawai> {
  final namaC = TextEditingController();
  final nipC = TextEditingController();
  final emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addpegawai() async {
    if (namaC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "nama": namaC.text,
            "email": emailC.text,
            "uid": uid,
            "dibuat_pada": DateTime.now().toIso8601String(),
          });
          await userCredential.user!.sendEmailVerification();
        }
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print('tidak dapat menambahkan pegawai');
      }
    } else {
      print('Error Blok');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pegawai'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          TextField(
            controller: nipC,
            decoration:
                InputDecoration(labelText: 'NIP', border: OutlineInputBorder()),
          ),
          SizedBox(height: 10),
          TextField(
            controller: namaC,
            decoration: InputDecoration(
                labelText: 'Nama', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: emailC,
            decoration: InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
          ),
          ElevatedButton(
              onPressed: () {
                addpegawai();
              },
              child: Text('Daftar'))
        ],
      ),
    );
  }
}
