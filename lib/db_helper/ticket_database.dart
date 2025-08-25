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
    final path = join(dbPath, 'tickets.db');

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fromStation TEXT,
        toStation TEXT,
        journeyType TEXT,
        tickets INTEGER,
        ticketNumber TEXT,
        validTill TEXT,
        qrData TEXT,
        isUsed INTEGER
      )
    ''');
  }

  Future<void> insertTicket(TicketModel ticket) async {
    final db = await instance.database;
    await db.insert('tickets', ticket.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TicketModel>> fetchTickets({bool? isUsed}) async {
    final db = await instance.database;
    final whereClause = isUsed != null ? 'WHERE isUsed = ${isUsed ? 1 : 0}' : '';
    final result = await db.rawQuery('SELECT * FROM tickets $whereClause');
    return result.map((map) => TicketModel.fromMap(map)).toList();
  }

  Future<void> updateTicketUsage(String ticketNumber, bool used) async {
    final db = await instance.database;
    await db.update(
      'tickets',
      {'isUsed': used ? 1 : 0},
      where: 'ticketNumber = ?',
      whereArgs: [ticketNumber],
    );
  }
}
