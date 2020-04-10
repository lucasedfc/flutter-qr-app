import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/scans_utils.dart' as utils;

class AddressesPage extends StatelessWidget {

  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if( !snapshot.hasData) {
          return Center(
            child: Text('No Data'),
          );
        }


        final scans = snapshot.data;

      
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
              child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
              title: Text(scans[i].value),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.openScan(context, scans[i]),
            ),
          )
          );
      },
    );
  }
}
