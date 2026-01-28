
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  String noteCollectionPath = "notes";

  List<QueryDocumentSnapshot<Map<String, dynamic>>> mData = [];

 FirebaseFirestore? firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    //fetchNotes();
  }

  void addNotes({required String title,required String description, required int createdAt})async{
    var docRef = await firestore!.collection(noteCollectionPath).add({
      "title":title,
      "description":description,
      "createdAt":createdAt,
    });
    print("Doc created with id ${docRef.id}");
    setState(() {});
    //fetchNotes();
  }

  /*void fetchNotes()async{
    var QuerySnap = await firestore!.collection(noteCollectionPath).get();
   mData = QuerySnap.docs;
    //setState(() { });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(Icons.notifications_on_sharp,size: 30,),
          SizedBox(width: 11),
          Icon(Icons.search,size: 30,),
          SizedBox(width: 11),
          Icon(Icons.more_vert,size: 30,),
          SizedBox(width: 11),
          
        ],
        leading: Icon(Icons.account_circle,size: 30,),
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        title: Text("Note app"),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(future: firestore!.collection(noteCollectionPath).get(), builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()),);
        }
        if(snapshot.hasData){
          mData = snapshot.data!.docs;
        return mData.isNotEmpty ? ListView.builder(
            itemCount: mData.length,
            itemBuilder: (_, index){
              return ListTile(
                title: Text(mData[index].data()["title"]),
                subtitle: Text(mData[index].data()["description"]),
                //trailing: Text(mData[index].data()["createdAt"].toString()),
              );
            }): Center(
          child: Text("No Notes"),

        );
        }
        return Container();
      }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
          onPressed: (){
        showModalBottomSheet(context: context, builder: (_){
          return Container(
            width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Column(
                  children: [
                    Text("Add Notes", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                    SizedBox(height: 11,),
                    TextField(
                      controller: titleController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Enter Title here..",
                        label: Text("Title"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    SizedBox(height: 11,),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text("Description"),
                        hintText: "Enter Desc here..",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    SizedBox(height: 21,),
                    Row(
                      children: [
                        OutlinedButton(onPressed: (){
                          addNotes(
                              title: titleController.text,
                              description: descriptionController.text,
                              createdAt: DateTime.now().millisecondsSinceEpoch);
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        }, child: Text("Save")),
                        SizedBox(width: 11,),
                        OutlinedButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("Cancel")),
                      ],
                    ),


                  ],
                ),
              ),
          );
        });
      }),
    );
  }
}
