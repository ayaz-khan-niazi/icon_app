// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:icon/pdfviewer.dart';
import 'package:icon/playground.dart';
import 'package:icon/utilities/widget_animator.dart';
import 'package:icon/web_view_container.dart';
import 'package:icon/web_view_container2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _indexofMap = 0;
  double _lat = 24.821621084127308;
  double _lng = 67.11030449419727;
  void _onButtonMapTap(double lat, double lng) {
    setState(() {
      _lat = lat;
      _lng = lng;
    });
  }

  // void _updateMapIndex(int index) {
  //   setState(() {
  //     _indexofMap = index;
  //   });
  // }

  void _onItemTapped(int index) {
    print(index);
    if (index != 4) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  launchGoogleMapDirection(lat, lng) async {
    final String googleMapslocationUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}&travelmode=driving";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
    }
  }

  // Retrieve the _loggedInUsername from SharedPreferences
  Future<String> _getLoggedInUsername() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('loggedInUsername') ?? '';
  }

  // ignore: unused_field
  LatLng _center = LatLng(24.821621084127308, 67.11030449419727);
  // ignore: unused_field
  MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Open Sans',
        // primaryColor: Colors.green,
      ),
      home: Scaffold(
        key: scaffoldKey,
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(251, 247, 10, 46),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/indus-logo.png',
                  width: 120,
                ),
                SizedBox(
                  width: 40,
                ),
                Text(
                  "ICON 2024",
                  style: TextStyle(fontWeight: FontWeight.w900),
                )
              ],
            )),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              FutureBuilder(
                // Retrieve the _loggedInUsername from SharedPreferences
                future: _getLoggedInUsername(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final loggedInUsername = snapshot.data ?? 'Please login';
                    return DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        loggedInUsername,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: const Text('Dates to Remember'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.local_offer),
                title: const Text('Registration Packages'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: const Text('Information'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner),
                title: const Text('QR Attendance'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: const Text('About Indus'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewExample2(
                            webViewURL: 'https://indushospital.org.pk')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.recommend),
                title: const Text('Endrosements'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.computer),
                title: const Text('ePosters'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.facebook),
                title: const Text('Facebook'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewExample2(
                            webViewURL: 'https://facebook.com')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.help_center),
                title: const Text('Help Line'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: const Text('Close Menu'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
          // child: _widgetOptions.elementAt(_selectedIndex),
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              SingleChildScrollView(
                child: Container(
                  // margin: EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Image.asset('assets/images/dashboard_banner.png'),
                      const SizedBox(
                        height: 5,
                      ),
                      //start of first widget
                      Container(
                        margin: EdgeInsets.all(3),
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(251, 247, 10, 46),
                          border: Border.all(
                              color: const Color.fromARGB(251, 247, 10, 46)),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(11.0),
                            topLeft: Radius.circular(11.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 2),
                              child: Text(
                                "Inaugral Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2, right: 5),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.white, size: 18),
                                  Text(
                                    "QF,NST,SMP Lahore",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          SizedBox(
                            width: 7,
                          ),
                          Icon(Icons.watch_later_outlined,
                              size: 18,
                              color: Color.fromARGB(251, 247, 10, 46)),
                          Text(
                            " Date and Time",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(251, 247, 10, 46),
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Day 1",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                              Text(
                                " - Friday, January 19, 2024",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              // Text("08:30 AM to 5 PM (GMT+5)",style: TextStyle(
                              // color: Colors.black,fontSize: 16), ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "08:30 AM to 5 PM (GMT+5)",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Column(
                      //   children: [
                      //     Row(
                      //       children: const [
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Text(
                      //           "Day 2",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w900,
                      //               color: Colors.black,
                      //               fontSize: 16),
                      //         ),
                      //         Text(
                      //           " - Friday, January 19, 2024",
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 16),
                      //         ),
                      //         // Text("08:30 AM to 5 PM (GMT+5)",style: TextStyle(
                      //         // color: Colors.black,fontSize: 16), ),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         const Text(
                      //           "08:30 AM to 5 PM (GMT+5)",
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 16),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      //end of first widget
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: EdgeInsets.all(3),
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(251, 247, 10, 46),
                          border: Border.all(
                              color: const Color.fromARGB(251, 247, 10, 46)),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(11.0),
                            topLeft: Radius.circular(11.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 2),
                              child: Text(
                                "Closing Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2, right: 5),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.white, size: 18),
                                  Text(
                                    "Marriot hotel, Karachi",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Row(
                        children: const [
                          SizedBox(
                            width: 7,
                          ),
                          Icon(Icons.watch_later_outlined,
                              size: 18,
                              color: Color.fromARGB(251, 247, 10, 46)),
                          Text(
                            " Date and Time",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(251, 247, 10, 46),
                                fontSize: 16),
                          ),
                        ],
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Day 1",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                              Text(
                                " - Friday, January 19, 2024",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              // Text("08:30 AM to 5 PM (GMT+5)",style: TextStyle(
                              // color: Colors.black,fontSize: 16), ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "08:30 AM to 5 PM (GMT+5)",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Column(
                      //   children: [
                      //     Row(
                      //       children: const [
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Text(
                      //           "Day 2",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w900,
                      //               color: Colors.black,
                      //               fontSize: 16),
                      //         ),
                      //         Text(
                      //           " - Friday, January 19, 2024",
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 16),
                      //         ),
                      //         // Text("08:30 AM to 5 PM (GMT+5)",style: TextStyle(
                      //         // color: Colors.black,fontSize: 16), ),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         const Text(
                      //           "08:30 AM to 5 PM (GMT+5)",
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 16),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPDFViewer(
                                    webViewURL:
                                        'https://event.tih.org.pk/pdf/CMEcertificate.pdf')),
                          ),
                          child: const Text(
                            'Internation/National Speakers',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                        ),
                      ),
                      //     ElevatedButton(
                      //   child: Text("Open a PDF file"),
                      //   onPressed: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MyPDFViewer(webViewURL: 'https://event.tih.org.pk/pdf/CMEcertificate.pdf')),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPDFViewer(
                                    webViewURL:
                                        'https://event.tih.org.pk/pdf/CMEcertificate.pdf')),
                          ),
                          child: const Text(
                            'ICON 2024 suppliments',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPDFViewer(
                                    webViewURL:
                                        'https://event.tih.org.pk/pdf/CMEcertificate.pdf')),
                          ),
                          child: const Text(
                            'Sponsors',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.all(3),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(251, 247, 10, 46),
                          border: Border.all(
                              color: const Color.fromARGB(251, 247, 10, 46)),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            // SizedBox(width: 10),
                            Text(
                              "Directions (click on the name to view the map)",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 3),
                        width: 500,
                        child: ElevatedButton(
                            onPressed: () {
                              // _onButtonMapTap(
                              //     24.821621084127308, 67.11030449419727);
                              _mapController.move(
                                  LatLng(24.821621084127308, 67.11030449419727),
                                  16);
                            },
                            child: Text("The Indus Hospital (TIH)"),
                            style: ButtonStyle()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 3),
                        width: 500,
                        child: ElevatedButton(
                            onPressed: () {
                              // _onButtonMapTap(
                              //     24.814982851095635, 67.11973023178312);
                              _mapController.move(
                                  LatLng(24.861036056898726, 67.0007930745633),
                                  16);
                            },
                            child: Text("Sheikh Saeed Hospital (SSMC)"),
                            style: ButtonStyle()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 3),
                        width: 500,
                        child: ElevatedButton(
                            onPressed: () {
                              //   _updateMapIndex(0);
                              //   _onButtonMapTap(
                              //       24.809627560080905, 67.12266254629961);
                              // },
                              _mapController.move(
                                  LatLng(24.809627560080905, 67.12266254629961),
                                  16);
                            },
                            child: Text("Woodcraft Building (GHD)"),
                            style: ButtonStyle()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 3),
                        width: 500,
                        child: ElevatedButton(
                            onPressed: () {
                              _mapController.move(
                                  LatLng(24.845478722892537, 67.03158251149328),
                                  16);
                            },
                            child: Text("Karachi Marriott Hotel"),
                            style: ButtonStyle()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 3),
                        width: 500,
                        child: ElevatedButton(
                            onPressed: () {
                              _mapController.move(
                                  LatLng(31.55316936355914, 74.30233008209936),
                                  16);
                            },
                            child: Text("QF,NST,SMP Lahore"),
                            style: ButtonStyle()),
                      ),
                      IndexedStack(
                        index: _indexofMap,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 350,
                            child: FlutterMap(
                              options: MapOptions(
                                center: _center,
                                zoom: 16.2,
                              ),
                              mapController: _mapController,
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(24.821621084127308,
                                          67.11030449419727),
                                      builder: (ctx) => Container(
                                          child: GestureDetector(
                                        onTap: () {
                                          launchGoogleMapDirection(
                                              24.821621084127308,
                                              67.11030449419727);
                                        },
                                        child: Icon(Icons.location_pin,
                                            size: 40,
                                            color: Colors.redAccent[700]),
                                      )),
                                    ),
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(
                                          24.861036056898726, 67.0007930745633),
                                      builder: (ctx) => Container(
                                          child: GestureDetector(
                                        onTap: () {
                                          launchGoogleMapDirection(
                                              24.861036056898726,
                                              67.0007930745633);
                                        },
                                        child: Icon(Icons.location_pin,
                                            size: 40,
                                            color: Colors.redAccent[700]),
                                      )),
                                    ),
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(24.809627560080905,
                                          67.12266254629961),
                                      builder: (ctx) => Container(
                                          child: GestureDetector(
                                        onTap: () {
                                          launchGoogleMapDirection(
                                              24.809627560080905,
                                              67.12266254629961);
                                        },
                                        child: Icon(Icons.location_pin,
                                            size: 40,
                                            color: Colors.redAccent[700]),
                                      )),
                                    ),
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(24.845478722892537,
                                          67.03158251149328),
                                      builder: (ctx) => Container(
                                          child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(ctx)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Tapped on purple FlutterLogo Marker'),
                                          ));
                                          launchGoogleMapDirection(
                                              24.845478722892537,
                                              67.03158251149328);
                                        },
                                        child: Icon(Icons.location_pin,
                                            size: 40,
                                            color: Colors.redAccent[700]),
                                      )),
                                    ),
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(
                                          31.55316936355914, 74.30233008209936),
                                      builder: (ctx) => Container(
                                          child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(ctx)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Tapped on purple FlutterLogo Marker'),
                                          ));
                                          launchGoogleMapDirection(
                                              31.55316936355914,
                                              74.30233008209936);
                                        },
                                        child: Icon(Icons.location_pin,
                                            size: 40,
                                            color: Colors.redAccent[700]),
                                      )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPDFViewer(
                                    webViewURL:
                                        'https://event.tih.org.pk/pdf/CMEcertificate.pdf')
                                // MyAnimatedList()
                                ),
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              "ICON 2024 suppliments",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.stretch,
                //   children: [
                //     Container(
                //       height: 40,
                //       alignment: Alignment.centerLeft,
                //       decoration: BoxDecoration(
                //         color: Color.fromARGB(255, 238, 238, 238),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       margin: EdgeInsets.only(left: 10, bottom: 12),
                //       child: InkWell(
                //         onTap: () => Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => MyPDFViewer(
                //                   webViewURL:
                //                       'https://event.tih.org.pk/pdf/CMEcertificate.pdf')),
                //         ),
                //         child: const Text(
                //           'ICON 2024 suppliments',
                //           style: TextStyle(color: Colors.blue, fontSize: 20),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
              Container(
                  child: WebViewExample(
                      webViewURL:
                          'https://event.tih.org.pk/Login.aspx?SmartDevice=1')),
              Container(
                  child: WebViewExample2(
                      webViewURL: 'https://indushospital.org.pk')),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Announcement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Login',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_2),
              label: 'Organizers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(250, 247, 10, 10),
          unselectedItemColor: Colors.black54,
          unselectedLabelStyle: const TextStyle(color: Colors.black45),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
