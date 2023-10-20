import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:ez_attend/screens/readqr.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EZAttend',
      home: ScanScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool resultIs = false;
  late Connectivity connectivity;
  late Stream<ConnectivityResult> connectivityStream;



  void updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      // Handle the connectivity status change here
      if (result == ConnectivityResult.none) {
        // No internet connection
        resultIs = false;
        print('No internet connection');
      } else if (result == ConnectivityResult.wifi) {
        // Connected to WiFi
        resultIs = true;
        print('Connected to WiFi');
      } else if (result == ConnectivityResult.mobile) {
        // Connected to mobile network
        resultIs = true;

        print('Connected to mobile network');
      }
    });
  }
  checkInternet() async {
    try {
      var result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          resultIs = true;
        });
      } else {
        setState(() {
          resultIs = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        resultIs = false;
      });
    }
  }

  void initState() {
    connectivity = Connectivity();
    connectivityStream = connectivity.onConnectivityChanged;
    setState(() {});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EZAttend"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: StreamBuilder<ConnectivityResult>(
            stream: connectivityStream,
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
              if (snapshot.hasData) {
                final ConnectivityResult? connectivityResult = snapshot.data;
                if (connectivityResult == ConnectivityResult.none) {
                  return Text(
                    'No internet connection',
                    style: TextStyle(fontSize: 24),
                  );
                } else if (connectivityResult == ConnectivityResult.wifi) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ScanScreen()));
                              print('Read qr code');
                            },
                            child: Text('Read QR code')),
                      ],
                    ),
                  );
                } else if (connectivityResult == ConnectivityResult.mobile) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ScanScreen()));
                              print('Read qr code');
                            },
                            child: Text('Read QR code')),
                      ],
                    ),
                  );
                }
              }
              return Text("جارى الاتصال بالانترنت");
            }));
  }
}
