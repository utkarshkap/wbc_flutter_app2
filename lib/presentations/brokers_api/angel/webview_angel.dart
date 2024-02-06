import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/brokers_api/angel/view_angel_holding.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class WebViewAngel extends StatefulWidget {
  static const route = '/Webview-Angel';

  const WebViewAngel({super.key});

  @override
  State<WebViewAngel> createState() => _WebViewAngelState();
}

class _WebViewAngelState extends State<WebViewAngel> {
  InAppWebViewController? webViewController;
  // ignore: non_constant_identifier_names
  String? IIFLUrl;

  @override
  void initState() {
    IIFLUrl =
        "https://smartapi.angelbroking.com/publisher-login?api_key=$angelApiKey";
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
                  if (finalUrl.contains("auth_token")) {
                    int startIndex = finalUrl.indexOf("auth_token=");
                    int endIndex = finalUrl.indexOf("&", startIndex);
                    String authToken = finalUrl
                        .substring(startIndex, endIndex)
                        .trim()
                        .replaceAll("auth_token=", '');

                    print("AUTH TOKEN :::::::${authToken}");
                    Navigator.of(context)
                        .pushReplacementNamed(ViewAngelHolding.route);

                    BlocProvider.of<FetchingDataBloc>(context).add(
                        LoadAngelHoldingsEvent(
                            getAngelHoldings: '', angelAuthToken: authToken));
                  }
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
