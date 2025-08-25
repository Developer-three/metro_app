import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../dashboard_screens/my_tickets/ticket_modal.dart';


class TicketDatabase {
  static final TicketDatabase instance = TicketDatabase._init();
  static Database? _database;

  TicketDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'DbTickets.db');

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE DbTickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fromStation TEXT,
        toStation TEXT,
        journeyType TEXT,
        tickets INTEGER,
        ticketId TEXT,
        orderId TEXT,
        transactionId TEXT,
        validTill TEXT,
        qrData TEXT,
        isUsed INTEGER
      )
    ''');
  }

  Future<void> insertTicket(TicketModel ticket) async {
    final db = await instance.database;
    await db.insert('DbTickets', ticket.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TicketModel>> fetchTickets({bool? isUsed}) async {
    final db = await instance.database;
    final whereClause = isUsed != null ? 'WHERE isUsed = ${isUsed ? 1 : 0}' : '';
    final result = await db.rawQuery('SELECT * FROM DbTickets $whereClause');
    return result.map((map) => TicketModel.fromMap(map)).toList();
  }

  Future<List<TicketModel>> getAllTickets() async {
    final db = await instance.database;
    // final whereClause = isUsed != null ? 'WHERE isUsed = ${isUsed ? 1 : 0}' : '';
    final result = await db.rawQuery('SELECT * FROM DbTickets');
    return result.map((map) => TicketModel.fromMap(map)).toList();
  }

  // ✅ UPDATED METHOD IN DATABASE
  Future<void> updateTicketUsage(String transactionId, bool isUsed) async {
    final db = await instance.database;
    final result = await db.update(
      'DbTickets',
      {'isUsed': isUsed ? 1 : 0},
      where: 'transactionId = ?',
      whereArgs: [transactionId],
    );
    print('Updated $result rows for transactionId=$transactionId'); // ✅ Log for debugging
  }

}
