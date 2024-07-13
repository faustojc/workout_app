import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/sources/schema.dart';

class Database {
  Database._();

  static final Database _instance = Database._();

  static Database get instance => _instance;

  late PowerSyncDatabase powersyncDb;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://fubkrstvdjgoytlbqjax.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1Ymtyc3R2ZGpnb3l0bGJxamF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDUxMjk1NzAsImV4cCI6MjAyMDcwNTU3MH0.NbDk02y0NwZoQmYUE2Qna9fDnO-R66aaG9tZviDvAkE',
    );

    powersyncDb = PowerSyncDatabase(
      schema: schema,
      path: await _getDatabasePath(),
    );

    await powersyncDb.initialize();

    final connector = _PowerSyncConnector(powersyncDb);
    if (Supabase.instance.client.auth.currentSession?.accessToken != null) {
      await powersyncDb.connect(connector: connector);
    }

    Supabase.instance.client.auth.onAuthStateChange.listen((state) async {
      if (state.event == AuthChangeEvent.signedIn) {
        await powersyncDb.connect(connector: connector);
      } else if (state.event == AuthChangeEvent.signedOut) {
        await powersyncDb.disconnect();
      } else if (state.event == AuthChangeEvent.tokenRefreshed) {
        await connector.prefetchCredentials();
      }
    });
  }

  Future<String> _getDatabasePath() async {
    final dir = await getApplicationSupportDirectory();

    return join(dir.path, "powersync.db");
  }
}

class _PowerSyncConnector extends PowerSyncBackendConnector {
  final List<RegExp> _fatalResponseCodes = [
    // Class 22 — Data Exception
    // Examples include data type mismatch.
    RegExp(r'^22...$'),
    // Class 23 — Integrity Constraint Violation.
    // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
    RegExp(r'^23...$'),
    // INSUFFICIENT PRIVILEGE - typically a row-level security violation
    RegExp(r'^42501$'),
  ];
  final log = Logger(
    printer: PrettyPrinter(
      methodCount: 8,
      printTime: true,
      lineLength: 180,
    ),
  );

  Future<void>? _refreshFuture;
  PowerSyncDatabase db;

  _PowerSyncConnector(this.db);

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    await _refreshFuture;

    final currSession = Supabase.instance.client.auth.currentSession;

    if (currSession == null) {
      return Future.value();
    }

    final token = currSession.accessToken;
    final userId = currSession.user.id;

    return PowerSyncCredentials(
      endpoint: "https://65b1a8504078d9a211d72c4b.powersync.journeyapps.com",
      token: token,
      userId: userId,
    );
  }

  @override
  void invalidateCredentials() {
    _refreshFuture = Supabase.instance.client.auth
        .refreshSession() //
        .timeout(const Duration(seconds: 10))
        .then((response) => null, onError: (error) => null);
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();

    if (transaction == null) return;

    final rest = Supabase.instance.client.rest;
    CrudEntry? lastEntry;

    try {
      for (var entry in transaction.crud) {
        lastEntry = entry;
        final table = rest.from(entry.table);

        if (entry.op == UpdateType.put) {
          final data = Map<String, dynamic>.from(entry.opData!);
          data['id'] = entry.id;

          await table.upsert(data);
        } else if (entry.op == UpdateType.delete) {
          await table.delete().eq('id', entry.id);
        } else if (entry.op == UpdateType.patch) {
          await table.update(entry.opData!).eq('id', entry.id);
        }
      }

      await transaction.complete();
    } on PostgrestException catch (e) {
      if (e.code != null && _fatalResponseCodes.any((re) => re.hasMatch(e.code!))) {
        log.f('Data upload error - discarding $lastEntry');
        await transaction.complete();
      } else {
        rethrow;
      }
    }
  }
}
