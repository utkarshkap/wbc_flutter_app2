import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/resources/colors.dart';
import 'package:wbc_connect_app/resources/icons.dart';

class WebViewICICI extends StatefulWidget {
  static const route = '/Webview-ICICI';

  const WebViewICICI({super.key});

  @override
  State<WebViewICICI> createState() => _WebViewICICIState();
}

class _WebViewICICIState extends State<WebViewICICI> {
  InAppWebViewController? webViewController;

  String? IIFLUrl;

  @override
  void initState() {
    IIFLUrl =
        "https://api.icicidirect.com/apiuser/login?api_key=your_public_key";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InAppWebViewController webView;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: colorWhite,
        elevation: 6,
        shadowColor: colorTextBCBC.withOpacity(0.3),
        leadingWidth: 15.w,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(icBack, color: colorRed, width: 6.w)),
      ),
      body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(children: <Widget>[
            Expanded(
                child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(IIFLUrl!),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  String finalUrl = url.toString();
                  print("finalUrl-->$finalUrl");
                  /*if(finalUrl.contains("auth_code")){
                            Navigator.of(context).pushReplacementNamed(ViewFyersHolding.route);
                            BlocProvider.of<FetchingDataBloc>(context).add(
                                LoadFyersAccessTokenEvent(getFyersAccessToken: GetFyersAccessTokenModel())
                            );
                          }*/
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print("consoleMessage-->$consoleMessage");
              },
            ))
          ]);
        },
      ),
    );
  }
}
