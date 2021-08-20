import 'Database.dart';
import 'package:moor/moor.dart';

part 'Diary.g.dart';

class Diary extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 20)();

  TextColumn get content => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(Constant(DateTime.now()))();
}

@UseDao(tables: [Diary])
class DiaryDao extends DatabaseAccessor<Database> with _$DiaryDaoMixin {
  DiaryDao(Database db) : super(db);

  // Future<List<DiaryData>> streamDiaries() => select(diary).get();
  Stream<List<DiaryData>> streamDiaries() => select(diary).watch();

  Stream<DiaryData> streamDiary(int id) =>
      (select(diary)
        ..where((tbl) => tbl.id.equals(id))).watchSingle();

  Future insertDiary(DiaryCompanion data) =>
      into(diary).insert(data);

}
