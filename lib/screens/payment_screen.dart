import 'package:elive/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class PaymentScreen extends StatefulWidget {
  final email;
  final price;
  PaymentScreen({
    this.email,
    this.price,
  });
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;
  final GlobalKey<ScaffoldState> globKeyPay = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String _loadHTML() {
      return '''
  <html>
  <body onload="document.f.submit();">
  <form id="f" name="f" method="get" action="https://elivebeautyspot.in/admin/paypal/invoice.php?email=${widget.email}&price=${widget.price}">
  <input type="hidden" name="email" value="${widget.email}"/>
  <input type="hidden" name="price" value="${widget.price}"/>
  </form>
  </body>
  </html>
  ''';
    }

    //https://paypal-testing-inprep.herokuapp.com/success?price=45&paymentId=PAYID-L7AARAY4WL67464YX728883H&token=EC-3DS88345PC817013J&PayerID=2SAVKT252CYY8
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: globKeyPay,
        appBar: AppBar(
          title: Text('Payment'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: WebView(
          onPageFinished: (page) async {
            if (page.contains('/success')) {
              print('SUCCSESS PAGE');
              showToast("You will be redirected to App shortly", Colors.green);

              await Future.delayed(Duration(seconds: 2)).then((value) {
                Navigator.pop(context, true);
                showToast("Payment Done", Colors.green);
              });

              // Navigator.pop(context);
            }
            // }
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl:
              // '',
              // 'https://google.com.pk'
              Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
        ),
      ),
    );
  }
}
