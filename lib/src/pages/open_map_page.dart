import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';


class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = new MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Coordinates QR'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.my_location), 
            onPressed: () {
              mapController.move(scan.getLatLng(), 15);
            }
            )
          ],
        ),
        body: _createFlutterMap(scan),
        floatingActionButton: _createFloatingButton(context),
        );
        
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(center: scan.getLatLng(), zoom: 15),
      layers: [
        _createMap(),
        _createMarker(scan)
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoibHVjYXNlZGZjIiwiYSI6ImNrOHQ1amlwdzAyMTgzZ281NHNkMmZic2EifQ.eUAu7igZRLbPUAfw-NNYSw',
        'id': 'mapbox.$mapType' // streets, dark, light, sattelite, outdoors
      }
    );
  }

   _createMarker(ScanModel scan) {
     return MarkerLayerOptions(
       markers: <Marker> [
         Marker(
           width: 100.0,
           height: 100.0,
           point: scan.getLatLng(),
           builder: (context) => Container(child: Icon(Icons.location_on, size: 45.0, color: Colors.redAccent))
         )
       ]
     );
  }

  Widget _createFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {

        if(mapType == 'streets') {
          mapType = 'dark';
        } else if (mapType == 'dark') {
          mapType = 'light';
        } else if (mapType == 'light') {
          mapType = 'outdoors';
        } else if (mapType == 'outdoors') {
          mapType = 'sattelite';
        } else {
          mapType = 'streets';
        }
        setState(() {});

      }
      );
  }
}
