import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDreal extends StatefulWidget {
  CRUDreal({Key key}) : super(key: key);

  @override
  _CRUDrealState createState() => _CRUDrealState();
}

class _CRUDrealState extends State<CRUDreal> {
  List<Map<String, dynamic>> realList;
  String updateName;
  String updateWork;
  String name;
  String work;
  @override
  Widget build(BuildContext context) {
    Map<String, String> dmoData = {"name": name, "work": work};
    CollectionReference collectionReference =
        Firestore.instance.collection('data');
    void addData(Map demoData) {
      collectionReference.add(demoData);
    }

    void fetchData() {
      collectionReference.snapshots().listen((snapshot) {
        List<Map<String, dynamic>> list;
        list = snapshot.documents.map((element) => element.data).toList();
        setState(() {
          realList = list;
        });
      });
    }

    void deleteData(int index) async {
      QuerySnapshot querySnapshot = await collectionReference.getDocuments();
      querySnapshot.documents[index].reference.delete();
    }

    void updateData(int index) async {
      QuerySnapshot querySnapshot = await collectionReference.getDocuments();
      querySnapshot.documents[index].reference
          .updateData({'name': updateName, 'work': updateWork});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD real"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Add Data"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(hintText: "Enter Name"),
                            onChanged: (value) {
                              name = value;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: "Enter Work"),
                            onChanged: (value) {
                              work = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        RaisedButton(
                          onPressed: () {
                            dmoData.addAll({"name": name, "work": work});
                            addData(dmoData);
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Success!"),
                                    content: Text(
                                        "Your data is added successfully!"),
                                    actions: [
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text("Add"),
                        )
                      ],
                    );
                  });
            },
            child: Text("Add Data"),
          ),
          SizedBox(
            height: 30.0,
          ),
          RaisedButton(
            onPressed: () {
              fetchData();
            },
            child: Text("Fetch Data"),
          ),
          SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: Container(
              child: realList != null
                  ? realList.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: realList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  setState(() {
                                    realList.removeAt(index);
                                    deleteData(index);
                                  });
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                    '${realList[index]['name']} removed',
                                  )));
                                },
                                child: Tooltip(
                                  message: "Tap to update data",
                                  showDuration: Duration(seconds: 1),
                                  child: ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text("Update Data!"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Enter Name'),
                                                      onChanged: (value) {
                                                        updateName = value;
                                                      },
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Enter Work'),
                                                      onChanged: (value) {
                                                        updateWork = value;
                                                      },
                                                    ),
                                                    RaisedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        updateData(index);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Updated"),
                                                                content: Text(
                                                                    "Successfully Updated"),
                                                                actions: [
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Text("Update"),
                                                    )
                                                  ],
                                                ));
                                          });
                                    },
                                    title: Text(realList[index]['name']),
                                    subtitle: Text(realList[index]['work']),
                                  ),
                                ));
                          })
                      : Container(
                          child: Center(child: Text("Data is Empty")),
                        )
                  : Container(
                      child: Center(child: Text("Data is Empty")),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
