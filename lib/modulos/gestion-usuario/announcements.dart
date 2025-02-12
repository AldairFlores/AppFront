

import 'dart:convert';
import 'dart:ffi';

import 'package:appfront/modulos/gestion-usuario/models/announcement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Announcements extends StatefulWidget{
  const Announcements({Key? key}) : super(key: key);
  @override
  State<Announcements> createState()=>_AnnouncementsState();

}

class _AnnouncementsState extends State<Announcements> {
  final List<Announcement> announcements = <Announcement>[];
  final TextStyle biggerFont = TextStyle(fontSize: 18);

  final Set<Announcement> saved= Set<Announcement>();


  /////////////////////////////////

  final List<Announcement> dataAnounsment=[];
  Future<http.Response> getadds() async{
    final response = await http.get(Uri.parse("https://timexp.xempre.com/api/v1/advertisements"));
    // setState(() {
    //   String body = utf8.decode(response.bodyBytes);
    //   print(jsonDecode(body)[0]['id']);
    // });
    return response;
  }

  @override
  void initState(){
    super.initState();
    getadds().then((value) => {
      setState(() {
        String body = utf8.decode(value.bodyBytes);
        for(var element in jsonDecode(body)){
          print(element['title']);
          dataAnounsment.add(Announcement(
            dateTime: element['dateTime'],
              description: element['description'],
              promoted: element['promoted'],
              title: element['title'],
              urlToImage: element['urlToImage'],
          ));
        }
      }),

    });
  }

  /////////////////////////////
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Annuncios"),
        actions: <Widget>[IconButton(onPressed: pushSaved, icon: Icon(Icons.book))],
      ),
      body: buildAnnouncements(),

    );
  }
  Widget buildAnnouncements(){
    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemBuilder: (BuildContext context, int i) {
        print(i);
        Announcement item1 = dataAnounsment[i];
        announcements.add(item1);
        return buildRow(announcements[i]);
      },
      itemCount: dataAnounsment.length,
    );
  }


  void pushSaved() {
  }

  Widget buildRow(Announcement announcement) {
    return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: [
            Stack(
              children: [
                Ink.image(image: NetworkImage(
                    announcement.urlToImage
                ),
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Text(announcement.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                    )
                )

              ],
            ),
            Padding(
              padding: EdgeInsets.all(16).copyWith(bottom: 0),
              child: Text(announcement.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              buttonPadding: EdgeInsets.all(16).copyWith(bottom: 5),
              children: [
                ElevatedButton(
                    child: Text(
                      'Adopt pet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    onPressed: (){}
                ),
                ElevatedButton(
                    child: Text(
                      'More information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10),
                    ),
                    onPressed: (){}
                )
              ],
            )

          ],)

        );
  }
}