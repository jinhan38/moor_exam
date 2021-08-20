import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'Diary.dart';

part 'Database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'diary.sqlite'));
    return VmDatabase(file);
  });
}

// @UseMoor(tables: [Diary, Tag, DiaryWithTag], daos: [DiaryDao])
@UseMoor(tables: [Diary], daos: [DiaryDao])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

}