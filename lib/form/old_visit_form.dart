import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../main.dart';

get isAdmin => isAdminStatus;

class OldVisits extends StatefulWidget {
  const OldVisits({Key? key}) : super(key: key);
  @override
  State<OldVisits> createState() => _OldVisits();
}

class _OldVisits extends State<OldVisits> {

  late Query _ref;

  @override
  void initState() {
    super.initState();
    if(isAdmin){
      _ref = FirebaseDatabase.instance
          .ref("School Visits")
          .orderByChild('school');
    }else {
      _ref = FirebaseDatabase.instance
          .ref("Users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("School Visits")
          .orderByChild('school');
    }
  }

  Widget _buildContactItem({required Map visitRecord}) {
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
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map visitRecord = snapshot.value as Map;
            visitRecord['key'] = snapshot.key;
            return _buildContactItem(visitRecord: visitRecord);
          },
        ),
      ),
    );
  }
}
