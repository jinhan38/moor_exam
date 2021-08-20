import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:moor_exam/data/Database.dart';
import 'package:moor_exam/data/Diary.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({Key? key}) : super(key: key);

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  String? title;
  String? content;
  String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moor"), centerTitle: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 600,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  renderTextFields(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                          //     textStyle: TextStyle(fontSize: 20, ),
                          // ),
                          style: ButtonStyle(
                              textStyle:
                                  MaterialStateProperty.all<TextStyle>(
                                      TextStyle(fontSize: 20)),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 60))),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (this.content != null &&
                                  this.title != null) {
                                final dao = GetIt.instance<DiaryDao>();
                                await dao.insertDiary(DiaryCompanion(
                                    title: Value(this.title!),
                                    content: Value(this.content!)));
                                // dao.insertDiary(DiaryCompanion.insert(
                                //     title: this.title!,
                                //     content: this.content!));

                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: Text('저장하기'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  renderTextFields() {
    return Expanded(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: '제목',
            ),
            onSaved: (val) {
              this.title = val;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '내용',
            ),
            maxLines: 10,
            onSaved: (val) {
              this.content = val;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '태그',
            ),
            onSaved: (val) {
              this.tag = val;
            },
          ),
        ],
      ),
    );
  }
}
