import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadManager extends StatefulWidget {
  const UploadManager({Key? key}) : super(key: key);

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<UploadManager> {
  final database = FirebaseDatabase.instance
      .ref("Users")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("Images");

  @override
  Widget build(BuildContext context) {
    final dataSnapshot = database.onValue;
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
                stream: dataSnapshot,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List images = [];
                    final dataSnapshot = snapshot.data!.snapshot;
                    for (var element in dataSnapshot.children) {
                      for (var element2 in element.children) {
                        if (element2.key == "imageURL") {
                          images.add(element2.value);
                          print(element2.value);
                        }
                      }
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisExtent: 200,
                              maxCrossAxisExtent: 150,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemCount: images.length,
                      itemBuilder: (context, count) {
                        return Transform(
                          transform: Matrix4.rotationZ(0),
                          alignment: FractionalOffset.centerRight,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                images[count],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )
        ]),
      ),
    );
  }
}
