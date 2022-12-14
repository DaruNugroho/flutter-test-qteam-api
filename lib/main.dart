import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_api_application/network/feedback_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ItemChat> itemChats = [
    ItemChat(title: "title", subtitle: "subtitle"),
    ItemChat(title: "title", subtitle: "subtitle"),
    ItemChat(title: "title", subtitle: "subtitle"),
    ItemChat(title: "title", subtitle: "subtitle"),
  ];
  late Future futureFindOne;
  //late Future futureCreateFeedback;
  String nilai = "Kosong";
  late Future futureAllFeedback;
  List<String> char = [];

  @override
  void initState() {
    futureFindOne = findOne();
    futureAllFeedback = findAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: futureFindOne,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.id),
                      Text(snapshot.data!.subject),
                      Text(snapshot.data!.content),
                      Text(snapshot.data!.created),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Text("Data tidak ada!");
                }
              },
            ),
            FutureBuilder(
              future: futureAllFeedback,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.content[0]);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Text("data kosong");
                }
              }),
            ),
            Text(nilai),
            TextButton(
              onPressed: () {
                createFeedback(
                  "Layanan Qteams",
                  "Saya ingin pasang layanan internet",
                ).then((value) {
                  nilai = value.toString();
                  setState(() {});
                });
              },
              child: Text('Post'),
            )
          ],
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  final String title;
  final String subtitle;

  const ItemChat({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: FlutterLogo(),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
        onPressed: () {},
        icon: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('Edit'),
            ),
            PopupMenuItem(
              child: Text('Hapus'),
            )
          ],
        ),
      ),
    );
  }
}

Future _updateItemDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Tentang",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Teks...",
                  hintMaxLines: 1,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  hintStyle: const TextStyle(
                    fontSize: 14.0,
                  ),
                  fillColor: Colors.white60,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 0.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 0.2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 7,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: "Tulis Pesan...",
                  hintMaxLines: 1,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  hintStyle: const TextStyle(
                    fontSize: 14.0,
                  ),
                  fillColor: Colors.white60,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 0.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Batal'),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Simpan'),
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}
