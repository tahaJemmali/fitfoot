import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService extends StatefulWidget {
  static Address addresse;

  @override
  _GoogleMapServiceState createState() => _GoogleMapServiceState();
}

class _GoogleMapServiceState extends State<GoogleMapService> {
  @override
  void dispose() {
    super.dispose();
    if (_streamSubscription != null) _streamSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    if (_coordinates != null) {
                      convertCoordinatesToAddress(_coordinates).then((value) {
                        print("S10:" + value.addressLine);
                        setState(() {
                          _address = value;
                        });
                        Marker m = Marker(
                          markerId: MarkerId('id-1'),
                          onDragEnd: _onTapOnMap,
                          infoWindow: InfoWindow(
                            title: value.countryName,
                            snippet: value.addressLine,
                          ),
                          position: LatLng(
                              _coordinates.latitude, _coordinates.longitude),
                          draggable: true,
                        );
                        setState(() {
                          if (_markers.length > 0)
                            _markers.remove(_markers.elementAt(0));
                          _markers.add(m);

                          _googleMapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(_coordinates.latitude,
                                    _coordinates.longitude),
                                zoom: 15),
                          ))
                              .then((value) async {
                            await Future.delayed(Duration(milliseconds: 500));
                            _googleMapController
                                .showMarkerInfoWindow(MarkerId('id-1'));
                          });
                        });
                      });
                    } else {
                      _streamSubscription = Geolocator.getPositionStream(
                              distanceFilter: 10,
                              desiredAccuracy: LocationAccuracy.high)
                          .listen((Position p) {
                        setState(() {
                          print(p);
                          _position = p;
                          _coordinates = Coordinates(p.latitude, p.longitude);
                          convertCoordinatesToAddress(_coordinates)
                              .then((value) {
                            setState(() {
                              _address = value;
                            });
                            Marker m = Marker(
                              markerId: MarkerId('id-1'),
                              onDragEnd: _onTapOnMap,
                              infoWindow: InfoWindow(
                                title: _address.countryName,
                                snippet: _address.addressLine,
                              ),
                              position: LatLng(p.latitude, p.longitude),
                              draggable: true,
                            );
                            setState(() {
                              if (_markers.length > 0) {
                                _markers.remove(_markers.elementAt(0));
                                _markers.add(m);
                              } else {
                                _markers.add(m);
                              }
                            });
                            _googleMapController
                                .animateCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(_coordinates.latitude,
                                      _coordinates.longitude),
                                  zoom: 15),
                            ))
                                .then((value) async {
                              await Future.delayed(Duration(seconds: 1));
                              _googleMapController
                                  .showMarkerInfoWindow(MarkerId('id-1'));
                            });
                          });
                        });
                      });
                    }
  }

  Set<Marker> _markers = {};
  Position _position;
  StreamSubscription<Position> _streamSubscription;
  Address _address;
  GoogleMapController _googleMapController;
  var _coordinates;

  void _onGoogleMapCreated(GoogleMapController googleMapController) {
    setState(() {
      _googleMapController = googleMapController;
    });
  }

  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var address;
    try {
      address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    } catch (e) {
      //print(e);
    }
    if (address != null) return address.first;
    return address;
  }

  Future<void> _onTapOnMap(LatLng latLng) {
    final coordinates = Coordinates(latLng.latitude, latLng.longitude);
    convertCoordinatesToAddress(coordinates).then((value) async {
      if (value == null) {
        setState(() {
          _markers.clear();
          _address = null;
        });
        return;
      }
      setState(() {
        _address = value;
      });

      Marker m = Marker(
        markerId: MarkerId('id-1'),
        onDragEnd: _onTapOnMap,
        infoWindow: InfoWindow(
          title: _address.countryName,
          snippet: _address.addressLine,
        ),
        position: latLng,
        draggable: true,
      );
      setState(() {
        if (_markers.length > 0) _markers.remove(_markers.elementAt(0));
        _markers.add(m);
      });
      await Future.delayed(Duration(milliseconds: 500));
      _googleMapController.showMarkerInfoWindow(MarkerId('id-1'));
    });
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //statusBarBrightness: Brightness.light,
      //systemNavigationBarColor: Colors.transparent,
      //systemNavigationBarDividerColor: Colors.transparent,

      //statusBarBrightness: Brightness.light,
      //systemNavigationBarIconBrightness: Brightness.light,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));*/
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.zero,
              child: AppBar(
          bottomOpacity: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,          
          ),
      ),
      body: GoogleMap(
        padding: EdgeInsets.only(bottom: 70, left: 15, right: 10),
        compassEnabled: true,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onTap: _onTapOnMap,
        markers: _markers,
        onMapCreated: _onGoogleMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(36.8459, 10.2191),
          zoom: 1,
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30, bottom: 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 40,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.blue.shade600,
                  heroTag: 'Fbtn1',
                  label: Text(
                    'Retour',
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, bottom: 0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 40,
                child: FloatingActionButton.extended(
                  label: Text('Terminer'),
                  backgroundColor:
                      _address == null ? Colors.grey : Colors.green,
                  onPressed: () {
                    setState(() {
                      GoogleMapService.addresse = _address;
                    });
                    if (_address != null) {
                      //print(_address.addressLine);
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(Icons.done),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, bottom: 160),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.8,
                child: FloatingActionButton(
                  heroTag: 'Fbtn2',
                  onPressed: () {
                    if (_coordinates != null) {
                      convertCoordinatesToAddress(_coordinates).then((value) {
                        print("S10:" + value.addressLine);
                        setState(() {
                          _address = value;
                        });
                        Marker m = Marker(
                          markerId: MarkerId('id-1'),
                          onDragEnd: _onTapOnMap,
                          infoWindow: InfoWindow(
                            title: value.countryName,
                            snippet: value.addressLine,
                          ),
                          position: LatLng(
                              _coordinates.latitude, _coordinates.longitude),
                          draggable: true,
                        );
                        setState(() {
                          if (_markers.length > 0)
                            _markers.remove(_markers.elementAt(0));
                          _markers.add(m);

                          _googleMapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(_coordinates.latitude,
                                    _coordinates.longitude),
                                zoom: 15),
                          ))
                              .then((value) async {
                            await Future.delayed(Duration(milliseconds: 500));
                            _googleMapController
                                .showMarkerInfoWindow(MarkerId('id-1'));
                          });
                        });
                      });
                    } else {
                      _streamSubscription = Geolocator.getPositionStream(
                              distanceFilter: 10,
                              desiredAccuracy: LocationAccuracy.high)
                          .listen((Position p) {
                        setState(() {
                          print(p);
                          _position = p;
                          _coordinates = Coordinates(p.latitude, p.longitude);
                          convertCoordinatesToAddress(_coordinates)
                              .then((value) {
                            setState(() {
                              _address = value;
                            });
                            Marker m = Marker(
                              markerId: MarkerId('id-1'),
                              onDragEnd: _onTapOnMap,
                              infoWindow: InfoWindow(
                                title: _address.countryName,
                                snippet: _address.addressLine,
                              ),
                              position: LatLng(p.latitude, p.longitude),
                              draggable: true,
                            );
                            setState(() {
                              if (_markers.length > 0) {
                                _markers.remove(_markers.elementAt(0));
                                _markers.add(m);
                              } else {
                                _markers.add(m);
                              }
                            });
                            _googleMapController
                                .animateCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(_coordinates.latitude,
                                      _coordinates.longitude),
                                  zoom: 15),
                            ))
                                .then((value) async {
                              await Future.delayed(Duration(seconds: 1));
                              _googleMapController
                                  .showMarkerInfoWindow(MarkerId('id-1'));
                            });
                          });
                        });
                      });
                    }
                  },
                  child: Icon(
                    Icons.my_location,
                    color: Colors.black54,
                  ),
                  mini: true,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
