import 'package:flutter/material.dart';
import 'package:flutter_api_application/form.dart';
import 'package:flutter_api_application/service/api_feedback.dart';

import 'model/feedback.dart';

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
      home: const MyHomePage(title: 'CRUD FEEDBACK'),
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
  List<FeedbackModel> _feedback = [];

  @override
  void initState() {
    _findAllFeedback();
    super.initState();
  }

  void _findAllFeedback() async {
    await ApiFeedback().findAll().then((res) {
      if (res.code == 200) {
        final content = res.content!['data'] as List;
        setState(() {
          _feedback = content.map((e) => FeedbackModel.fromJson(e)).toList();
        });
      }
    });
  }

  void onUpdate() {
    _findAllFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _feedback.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemChat(
              onUpdate: onUpdate,
              id: _feedback[index].id,
              subtitle: _feedback[index].subject,
              title: _feedback[index].content!,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyForm(onUpdate: onUpdate)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//Bisa Beda File
typedef ListCallback = void Function();

class ItemChat extends StatelessWidget {
  final ListCallback onUpdate;
  final String id;
  final String title;
  final String subtitle;

  const ItemChat({
    super.key,
    required this.onUpdate,
    required this.id,
    required this.title,
    required this.subtitle,
  });

  void _handleDelete(String id) async {
    await ApiFeedback().delete(id).then((res) {
      if (res.code == 200) {
        onUpdate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: FlutterLogo(),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton(
        onSelected: (newValue) {
          if (newValue == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyForm(onUpdate: onUpdate, id: id)),
            );
          } else {
            //delete
            _handleDelete(id);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text('Edit'),
            value: 0,
          ),
          PopupMenuItem(
            child: Text('Hapus'),
            value: 1,
          )
        ],
      ),
    );
  }
}
