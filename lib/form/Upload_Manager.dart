import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import '../auth/home_page.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.teal.shade300,
    ));
    final dataSnapshot = database.onValue;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) =>MyHomePage()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/stemrobo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.tealAccent, Colors.teal]),
          ),
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.teal.shade400,
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
                              mainAxisExtent: 120,
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
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
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
