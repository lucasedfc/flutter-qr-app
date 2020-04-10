import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }
  ScansBloc._internal() {
    // Get scans
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

// Listener

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validateGeo); // Stream Geo
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validateHttp); // Stream Http

  dispose() {
    _scansController?.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAll();
//_scansController.sink.add([]);
    getScans();
  }
}
