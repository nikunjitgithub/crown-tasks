import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//MyListItem class represents the structure of each item in the list.
class MyListItem {
  final int id;
  final String title;
  final String body;

  MyListItem({
    required this.id,
    required this.title,
    required this.body,
  });
}

class MyListPage extends StatefulWidget {
  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  late Future<List<MyListItem>> _futureList;

  @override
  void initState() {
    super.initState();
    _futureList = fetchData();
  }

  Future<List<MyListItem>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<MyListItem> myList = data
          .map((item) => MyListItem(
                id: item['id'],
                title: item['title'],
                body: item['body'],
              ))
          .toList();
      return myList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Items',
          style: TextStyle(color: Colors.white), // Text color white
        ),
        backgroundColor: Colors.blue, // Blue color for the AppBar
      ),
      body: FutureBuilder<List<MyListItem>>(
        future: _futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add margin around the container
                  decoration: BoxDecoration(
                    color: Colors.lightGreen, // Light green color for the box
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data![index].title,
                      style: TextStyle(color: Colors.black), // Text color black
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Details'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${snapshot.data![index].id}'),
                                SizedBox(height: 8),
                                Text('Title: ${snapshot.data![index].title}'),
                                SizedBox(height: 8),
                                Text('Body: ${snapshot.data![index].body}'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyListPage(),
  ));
}