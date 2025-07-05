// admin_dashboard.dart placeholder
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/firebase_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final reports = await FirebaseService.fetchReports();
    setState(() {
      for (var report in reports) {
        _markers.add(Marker(
          markerId: MarkerId(report['timestamp'].toString()),
          position: LatLng(report['latitude'], report['longitude']),
          infoWindow: InfoWindow(title: report['category'], snippet: report['description']),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(target: LatLng(18.5204, 73.8567), zoom: 12),
        markers: _markers,
      ),
    );
  }
}

