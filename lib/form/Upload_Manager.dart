import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CircleAvatar(
                                  radius: 5,
                                  backgroundImage: NetworkImage(images[count])),
                            ),
                            transform: Matrix4.rotationZ(-0.2),
                            alignment: FractionalOffset.centerRight,
                          );
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )
        ]),
      ),
    );
  }
}
