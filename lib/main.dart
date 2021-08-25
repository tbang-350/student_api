import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  @override
  Widget build(BuildContext context) {
    Future getStudentData() async {
      var response = await http
          .get(Uri.http('http://localhost:1919/management/student', 'students'));
      var jsonData = jsonDecode(response.body);
      List<Student> students = [];

      for (var s in jsonData) {
        Student student = Student(s["fullname"], s["gender"], s["course"]);
        students.add(student);
      }
      print(students.length);
      return students;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Student Data'),
        ),
        body: Container(
          child: Card(
            child: FutureBuilder(
              future: getStudentData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text('Loading....'),
                    ),
                  );
                } else
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${snapshot.data![index].fullname}'),
                          subtitle: Text(snapshot.data[index].gender),
                          trailing: Text(snapshot.data[index].grade),
                        );
                      });
              },
            ),
          ),
        ));
  }
}

class Student {
  final String fullname, gender, course;

  Student(this.fullname, this.gender, this.course);
}
