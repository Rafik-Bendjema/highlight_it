import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseImpl {
  static final DatabaseImpl _instance = DatabaseImpl._internal();
  static Database? _database;

  // Private constructor
  DatabaseImpl._internal();

  // Factory constructor
  factory DatabaseImpl() {
    return _instance;
  }

  // Method to get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'highlight_it.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, ver) async {
        // Create the category table
        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            nb_quotes INTEGER DEFAULT 0
          )
        ''');

        // Create the quote table
        await db.execute('''
          CREATE TABLE quote (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            book TEXT,
            page INTEGER,
            color TEXT,
            category INTEGER,
            FOREIGN KEY (category) REFERENCES category(id)
          )
        ''');

        // Create the trigger to increment nb_quotes after insert
        await db.execute('''
          CREATE TRIGGER increment_nb_quotes_after_insert
          AFTER INSERT ON quote
          BEGIN
              UPDATE category
              SET nb_quotes = nb_quotes + 1
              WHERE id = NEW.category;
          END;
        ''');

        // Create the trigger to decrement nb_quotes after delete
        await db.execute('''
          CREATE TRIGGER decrement_nb_quotes_after_delete
          AFTER DELETE ON quote
          BEGIN
              UPDATE category
              SET nb_quotes = nb_quotes - 1
              WHERE id = OLD.category;
          END;
        ''');
      },
    );
  }
}
