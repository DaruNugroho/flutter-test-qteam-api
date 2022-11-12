import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_application/service/api_feedback.dart';

import 'model/feedback.dart';

typedef FormCallback = void Function();

class MyForm extends StatefulWidget {
  final FormCallback onUpdate;
  late String? id;
  MyForm({super.key, required this.onUpdate, this.id});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  FeedbackModel? _feedback;
  @override
  void initState() {
    if (widget.id != null) {
      _findOne(widget.id);
    }
    super.initState();
  }

  void _findOne(id) async {
    await ApiFeedback().findOne(id).then((res) {
      if (res.code == 200) {
        //Add to model
        setState(() {
          _feedback = FeedbackModel.fromJson(res.content!);
        });

        _subjectController.text = _feedback!.subject;
        _contentController.text = _feedback!.content!;
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.id != null ? 'Update Data' : 'Create Data'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                //Save
                final Map body = {
                  "content": _contentController.text,
                  "subject": _subjectController.text
                };
                if (widget.id != null) {
                  //Update
                  await ApiFeedback().update(widget.id!, body).then((res) {
                    if (res.code == 200) {
                      //Update List
                      widget.onUpdate();
                      //back
                      Navigator.pop(context);
                    }
                  });
                } else {
                  //Create
                  await ApiFeedback().create(body).then((res) {
                    if (res.code == 201) {
                      //Update List
                      widget.onUpdate();
                      //back
                      Navigator.pop(context);
                    }
                  });
                }
              },
              child: Text(
                widget.id != null ? 'Perbarui' : 'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              TextField(
                controller: _subjectController,
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
              TextField(
                controller: _contentController,
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
              if (_feedback != null) ...[
                SizedBox(height: 100),
                Text('FeedBack WITH Model'),
                Text(_feedback!.id),
                Text(_feedback!.subject),
                Text(_feedback!.content!),
              ]
            ])));
  }
}
