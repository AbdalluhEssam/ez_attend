import 'package:ez_attend/screens/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<String> callAsyncFetch() =>
    Future.delayed(const Duration(seconds: 2), () => "hi");

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  var qrstr;

  var height, width;
    bool internetActive = false;

  checkInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      internetActive =true;
      print('YAY! Free cute dog pics!');
    } else {
      internetActive = false;
      print('No internet :( Reason:');
      print(InternetConnectionChecker().connectionStatus);
    }
    // try {
    //   var result = await InternetAddress.lookup("www.google.com");
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     return true;
    //   }
    // } on SocketException catch (_) {
    //   return false;
    // }
  }

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('EZAttend'),
          centerTitle: true,
          foregroundColor: Colors.blue,
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: internetActive == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: scanQr,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          'تسجيل الحضور',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20,),
                    Text(
                      " ........لا يوجد انترنت",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )
                  ],
                ),
              ));
  }

  Future<void> scanQr() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrstr = value;
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => WebScreen(qrstr: qrstr)));
        });
      });
    } catch (e) {
      setState(() {
        qrstr = 'unable to read this';
      });
    }
  }
}
