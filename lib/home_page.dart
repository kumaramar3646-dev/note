import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titleController = TextEditingController();
  var descController = TextEditingController();

  String noteCollectionPath = "todo";
  FirebaseFirestore? firestore;
  int selectedPriority = 2;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> mData = [];
  List<String> mPriority = ["Low", "Medium", "High"];


  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  void addTodo({
    required String title,
    required String desc,
  }) async {
    var docRef = await firestore!.collection(noteCollectionPath).add({
      "title": title,
      "desc": desc,
      "isCompleted": false,
      "priority": selectedPriority,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    });

    print("Doc Created with ${docRef.id}");
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore!.collection(noteCollectionPath).snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {


            mData = snapshot.data!.docs;
            return mData.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(11.0),
              child: ListView.builder(
                itemCount: mData.length,
                itemBuilder: (_, index) {

                  var eachData = mData[index].data();
                  Color bgColor = Colors.orange;

                  if(eachData["priority"] == 0){
                    bgColor = Colors.blue.shade100;
                  } else if(eachData["priority"] == 1){
                    bgColor = Colors.orange.shade100;
                  } else {
                    bgColor = Colors.red.shade100;
                  }

                  return Card(
                    color: bgColor,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value){
                        /// update isCompleted
                        firestore!.collection(noteCollectionPath).doc(mData[index].id).update({
                          "isCompleted": value,
                        });
                        //setState(() {});
                      },
                      value: eachData["isCompleted"],
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(eachData["title"]),
                          IconButton(onPressed: (){
                            showModalBottomSheet(context: context, builder: (context) => Container(
                              padding: EdgeInsets.symmetric(vertical: 21, horizontal: 11),
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Are you sure want to delete ?', style: TextStyle(
                                      fontSize: 21
                                  ),),
                                  SizedBox(
                                    height: 11,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(onPressed: (){
                                        firestore!.collection(noteCollectionPath).doc(mData[index].id).delete();
                                        /* setState(() {

                                              });*/
                                        Navigator.pop(context);
                                      }, child: Text('Yes', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      OutlinedButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('No')),
                                    ],
                                  )
                                ],
                              ),
                            ),);
                          }, icon: Icon(Icons.delete, color: Colors.red,))
                        ],
                      ),
                      subtitle: Text(eachData["desc"]),
                    ),
                  );
                },
              ),
            )
                : Center(child: Text('No Todos yet!!'));
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Container(
                padding: EdgeInsets.all(11),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: 'Enter title here..',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      maxLines: 4,
                      controller: descController,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Description",
                        hintText: 'Enter description here..',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    StatefulBuilder(
                        builder: (context, ss) {
                          return Row(
                              children: List.generate(mPriority.length, (index){
                                return RadioMenuButton(value: index, groupValue: selectedPriority, onChanged: (value){
                                  selectedPriority = value ?? 0;
                                  ss((){});
                                }, child: Text(mPriority[index]));
                              })
                          );
                        }
                    ),
                    SizedBox(height: 11),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            addTodo(
                              title: titleController.text,
                              desc: descController.text,
                            );
                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}