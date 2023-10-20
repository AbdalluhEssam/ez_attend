import 'package:ez_attend/screens/readqr.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  final String? qrstr;

  const WebScreen({Key? key, this.qrstr}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<WebScreen> {
  @override
  void initState() {
    if (widget.qrstr == "") {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ScanScreen()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
// Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse( "${widget.qrstr.toString()}KEY_ID=b326b5062b2f0e69046810717534cb09"));

    return Scaffold(
      appBar: AppBar(
        title: Text('EZAttend'),
        centerTitle: true,
        foregroundColor: Colors.blue,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
