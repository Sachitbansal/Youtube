import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'package:sizer/sizer.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List docIDs = [];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> dataStream =
        FirebaseFirestore.instance.collection(widget.id.toString()).snapshots();

    return Sizer(builder: (context, orientation, deviceType) {
      CollectionReference DataRef =
          FirebaseFirestore.instance.collection(widget.id.toString());

      Future<void> deleteUser(id) {
        return DataRef.doc(id).delete();
      }

      return Scaffold(
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Home Screen',
                  style: TextStyle(fontSize: 20.sp),
                ),
                IconButton(
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: dataStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Koi error aaya"),
                        duration: Duration(milliseconds: 1000),
                      ));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final List storedocs = [];
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      storedocs.add(a);
                      a['id'] = document.id;
                    }).toList();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        storedocs.length,
                        (i) => Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.lightBlueAccent[100],
                                borderRadius: BorderRadius.circular(10)),
                            height: 120,
                            width: 90.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            margin: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Text: ${storedocs[i]['text']}",
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      storedocs[i]['trueOrFalse'],
                                      style: TextStyle(fontSize: 15.sp),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20.sp,
                                      ),
                                      onPressed: () {
                                        deleteUser(storedocs[i]['id'])
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text("Deleted"),
                                            duration:
                                                Duration(milliseconds: 1000),
                                          ));
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 20.sp),
                                      onPressed: () {
                                        // Todo: Implement Edit Functionality
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Add(id: widget.id),
              ),
            );
          },
        ),
      );
    });
  }
}
