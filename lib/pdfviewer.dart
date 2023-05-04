import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class MyPDFViewer extends StatefulWidget {
  final String webViewURL;
  const MyPDFViewer({super.key, required this.webViewURL});
  @override
  _MyPDFViewerState createState() => _MyPDFViewerState();
}

class _MyPDFViewerState extends State<MyPDFViewer> {
  //final sampleUrl = widget.webViewURL;

  String? pdfFlePath;

  Future<String> downloadAndSavePdf(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      file.delete();
      // return file.path;
    }
    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf(String url) async {
    pdfFlePath = await downloadAndSavePdf(url);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadPdf(widget.webViewURL);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   title: Text('Plugin example app'),
          // ),
          body: Center(
            child: Column(
              children: <Widget>[
                // ElevatedButton(
                //   child: Text("Load pdf"),
                //   onPressed: (){
                //     loadPdf(widget.webViewURL);
                //   },
                // ),
                if (pdfFlePath != null)
                  Expanded(
                    child: Container(
                      child: PdfView(
                          path: pdfFlePath!, gestureNavigationEnabled: true),
                    ),
                  )
                else
                  Text("Pdf is not Loaded"),
              ],
            ),
          ),
        );
      }),
    );
  }
}
