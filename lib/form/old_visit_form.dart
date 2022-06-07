import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth/home_page.dart';

get isAdmin => isAdminStatus;

class OldVisits extends StatefulWidget {
  const OldVisits({Key? key}) : super(key: key);
  @override
  State<OldVisits> createState() => _OldVisits();
}

class _OldVisits extends State<OldVisits> {
  late Query _query;

  @override
  void initState() {
    super.initState();
    if (isAdmin) {
      _query = FirebaseDatabase.instance.ref("School Visits");
    } else {
      _query = FirebaseDatabase.instance
          .ref("Users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("School Visits");
    }
  }

  Widget _buildRecordItem({required Map visitRecord}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                visitRecord['name'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 15,
              ),
              const Icon(
                Icons.email,
                color: Colors.black,
                size: 14,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                visitRecord['email'],
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Icon(
                Icons.school,
                color: Colors.black,
                size: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                visitRecord['school'],
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.group_work,
                color: Colors.black,
                size: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                visitRecord['type'],
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Icon(
                Icons.notes,
                color: Colors.black,
                size: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                visitRecord['note'],
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.black,
                size: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                visitRecord['date'],
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (visitRecord.containsKey("images")) ...[
            Row(
              children: [
                SizedBox(
                  width: 370,
                  height: 114,
                  child: FirebaseAnimatedList(
                    query: FirebaseDatabase.instance
                        .ref("School Visits/" + visitRecord['key'] + "/images"),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map imageList = snapshot.value as Map;
                      imageList['key'] = snapshot.key;
                      return _buildImageItem(imageRecord: imageList);
                    },
                  ),
                ),
              ],
            ),
          ],
          if (visitRecord.containsKey("documents")) ...[
            Row(
              children: [
                SizedBox(
                  width: 370,
                  height: 114,
                  child: FirebaseAnimatedList(
                    query: FirebaseDatabase.instance.ref(
                        "School Visits/" + visitRecord['key'] + "/documents"),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map documentList = snapshot.value as Map;
                      documentList['key'] = snapshot.key;
                      return _buildDocumentItem(documentRecord: documentList);
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageItem({required Map imageRecord}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageRecord.containsKey("imageURL")) ...[
            Row(
              children: [
                GestureDetector(
                  onTap: () => {
                    launch(imageRecord['imageURL'],
                        forceSafariVC: true, forceWebView: true),
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        imageRecord['imageURL'],
                        fit: BoxFit.cover,
                        height: 90,
                        width: 64,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentItem({required Map documentRecord}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (documentRecord.containsKey("documentURL")) ...[
            Row(
              children: [
                SizedBox(
                  height: 80,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.green),
                        padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontSize: 14, color: Colors.white))),
                    onPressed: () {
                      var url = documentRecord['documentURL'];
                      launch(url, forceSafariVC: true, forceWebView: true);
                    },
                    child: const Text(
                      'View\nDocument',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _query.orderByChild('school'),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map visitRecord = snapshot.value as Map;
            visitRecord['key'] = snapshot.key;
            return _buildRecordItem(visitRecord: visitRecord);
          },
        ),
      ),
    );
  }
}
