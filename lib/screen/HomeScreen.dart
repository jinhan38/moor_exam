import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moor_exam/components/diary_card.dart';
import 'package:moor_exam/data/Database.dart';
import 'package:moor_exam/data/Diary.dart';

import 'WriteScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    if (!GetIt.instance.isRegistered<DiaryDao>()) {
      final db = Database();
      GetIt.instance.registerSingleton<DiaryDao>(DiaryDao(db));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dao = GetIt.instance<DiaryDao>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => WriteScreen())
          );
        },
      ),
      body: StreamBuilder<List<DiaryData>>(
        stream: dao.streamDiaries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  final item = data![index];
                  return DiaryCard(
                      title: item.title,
                      content: item.content,
                      createdAt: item.createdAt);
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: data!.length);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
