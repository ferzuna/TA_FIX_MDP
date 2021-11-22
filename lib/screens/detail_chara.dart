import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:tugas/screens/chara.dart';
import 'package:tugas/screens/dashboard.dart';

class DetailChara extends StatefulWidget {
  final int id;
  const DetailChara({Key? key, required this.id}) : super(key: key);

  @override
  _DetailCharaState createState() => _DetailCharaState();
}

class _DetailCharaState extends State<DetailChara> {
  late Future<Chara> futureChara;

  @override
  void initState() {
    super.initState();
    futureChara = fetchChara(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Detail Character'),
          backgroundColor: Colors.lightBlue[900]),
      backgroundColor: Colors.grey[400],
      body: FutureBuilder(
        future: futureChara,
        builder: (context, AsyncSnapshot<Chara> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 220,
                  height: 250,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                      snapshot.data!.images,
                      fit: BoxFit.cover,
                    ),
                    elevation: 55,
                    margin: EdgeInsets.only(
                        top: 60, bottom: 20, left: 20, right: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    snapshot.data!.name,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Text(
                  'Kelompok 07',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(
                  height: 20.0,
                  width: 200,
                  child: Divider(color: Colors.black),
                ),
                Card(
                  color: Colors.blueGrey[400],
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.badge,
                      color: Colors.blueGrey[100],
                    ),
                    title: Text(snapshot.data!.affiliation),
                  ),
                ),
                Card(
                    color: Colors.blueGrey[400],
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.blueGrey[100],
                      ),
                      title: Text(snapshot.data!.description),
                    )),
              ],
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<Chara> fetchChara(id) async {
  final response = await http.get(Uri.parse(
      'https://my-json-server.typicode.com/ferzuna/api_chara/character/${id}/'));
  if (response.statusCode == 200) {
    print(response.body);

    return Chara.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load episodes');
  }
}
