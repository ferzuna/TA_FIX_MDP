import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:tugas/screens/artifact.dart';
import 'package:tugas/screens/dashboard.dart';

class DetailArtifact extends StatefulWidget {
  final int id;
  const DetailArtifact({Key? key, required this.id}) : super(key: key);

  @override
  _DetailArtifactState createState() => _DetailArtifactState();
}

class _DetailArtifactState extends State<DetailArtifact> {
  late Future<Artifact> futureArtifact;

  @override
  void initState() {
    super.initState();
    futureArtifact = fetchArtifact(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Detail Character'),
          backgroundColor: Colors.lightBlue[900]),
      backgroundColor: Colors.grey[400],
      body: FutureBuilder(
        future: futureArtifact,
        builder: (context, AsyncSnapshot<Artifact> snapshot) {
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
                    leading: Text(
                      "2 Piece: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(snapshot.data!.s2PieceBonus),
                  ),
                ),
                Card(
                    color: Colors.blueGrey[400],
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
                    child: ListTile(
                      leading: Text(
                        "4 Piece: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text(snapshot.data!.s4PieceBonus),
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

Future<Artifact> fetchArtifact(id) async {
  final response = await http.get(Uri.parse(
      'https://my-json-server.typicode.com/ferzuna/api_artifact/artifact/${id}/'));
  if (response.statusCode == 200) {
    print(response.body);

    return Artifact.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load episodes');
  }
}
