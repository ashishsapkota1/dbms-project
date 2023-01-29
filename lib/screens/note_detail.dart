
import 'package:flutter/material.dart';
import 'package:myproject/models/note.dart';
import 'package:myproject/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  NoteDetailState createState() => NoteDetailState(this.note, this.appBarTitle);
}

class NoteDetailState extends State<NoteDetail> {

  static var _priorities = ['High', 'Low'];
  final String appBarTitle;
  final Note note;
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title ?? '';
    descriptionController.text = note.description ?? '';

    return WillPopScope(

      onWillPop: () async {
        moveToLastScreen();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding:const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: [
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  value: getPriorityAsString(note.priority!),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser.toString());
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15.0, 0.0, 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15.0, 0.0, 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0, 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Save", textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Delete", textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String? value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }


  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }


  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', "Note Saved Successfully!");
    } else {
      _showAlertDialog('Status', "Problem Saving Note");
    }
  }
  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', 'No note was deleted!');
      return;
    }
    int result = await helper.deleteNote(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
  String? getPriorityAsString(int value) {
    String? priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }
}