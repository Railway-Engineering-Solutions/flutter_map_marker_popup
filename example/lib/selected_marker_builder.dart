import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';
import 'example_popup.dart';

class SelectedMarkerBuilder extends StatefulWidget {
  static const route = 'selectedMarkerBuilder';

  const SelectedMarkerBuilder({Key? key}) : super(key: key);

  @override
  State<SelectedMarkerBuilder> createState() => _SelectedMarkerBuilderState();
}

class _SelectedMarkerBuilderState extends State<SelectedMarkerBuilder> {
  late final List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markers = [
      LatLng(44.421, 10.404),
      LatLng(45.683, 10.839),
      LatLng(45.246, 5.783),
    ]
        .map(
          (markerPosition) => Marker(
            point: markerPosition,
            width: 40,
            height: 40,
            builder: (_) => const Icon(Icons.location_on, size: 40),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected marker builder example'),
      ),
      drawer: buildDrawer(context, SelectedMarkerBuilder.route),
      body: FlutterMap(
        options: MapOptions(
          zoom: 5.0,
          center: LatLng(44.421, 10.404),
          onTap: (_, __) => _popupLayerController
              .hideAllPopups(), // Hide popup when the map is tapped.
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              popupController: _popupLayerController,
              markers: _markers,
              markerRotateAlignment:
                  PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
              popupBuilder: (BuildContext context, Marker marker) =>
                  ExamplePopup(marker),
              selectedMarkerBuilder: (context, marker) => const Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
