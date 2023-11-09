import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/presentations/brokers_api/view_5paisa_holdings.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../core/api/api_consts.dart';
import '../../models/get_5paisa_access_token_model.dart';

class Webview5Paisa extends StatefulWidget {
  static const route = '/Webview-5Paisa';
  const Webview5Paisa({Key? key}) : super(key: key);

  @override
  State<Webview5Paisa> createState() => _Webview5PaisaState();
}

class _Webview5PaisaState extends State<Webview5Paisa> {
  InAppWebViewController? webViewController;
  String? url;

  @override
  void initState() {
    url =
        "${generateRequestTokenUrl}VendorKey=$userKey&ResponseURL=$paisaRedirectUrl&state=$userId";
    print("url-->$url");
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
              initialUrlRequest: URLRequest(url: Uri.parse(url!)),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  String finalUrl = url.toString();
                  print("finalUrl-->$finalUrl");
                  if (finalUrl.contains("RequestToken")) {
                    int startIndex = finalUrl.indexOf("RequestToken=");
                    int endIndex = finalUrl.indexOf("&", startIndex);
                    String requestToken = finalUrl
                        .substring(startIndex, endIndex)
                        .trim()
                        .replaceAll("RequestToken=", '');

                    print("requestToken--->" + requestToken);

                    Navigator.of(context)
                        .pushReplacementNamed(View5PaisaHoldings.route);
                    BlocProvider.of<FetchingDataBloc>(context)
                        .add(Load5PaisaAccessTokenEvent(
                      get5PaisaAccessToken: Get5PaisaAccessTokenModel(),
                      requestToken: requestToken,
                    ));
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
