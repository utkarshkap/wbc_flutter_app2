import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wbc_connect_app/presentations/brokers_api/fyers/view_fyers_holding.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import '../../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../../core/api/api_consts.dart';
import '../../../models/get_fyers_access_token_model.dart';

class WebviewFyers extends StatefulWidget {
  static const route = '/Webview-Fyers';
  const WebviewFyers({Key? key}) : super(key: key);

  @override
  State<WebviewFyers> createState() => _WebviewFyersState();
}

class _WebviewFyersState extends State<WebviewFyers> {
  InAppWebViewController? webViewController;
  String? fyersUrl;

  @override
  void initState() {
    fyersUrl =
        "${generateAuthCodeUrl}client_id=$clientId&redirect_uri=$fyersRedirectUrl&response_type=code&state=${ApiUser.userId}";
    print("FyersURL-->$fyersUrl");
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
              initialUrlRequest: URLRequest(url: Uri.parse(fyersUrl!)),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  String finalUrl = url.toString();
                  print("finalUrl:::::${fyersUrl}");
                  if (finalUrl.contains("auth_code")) {
                    Navigator.of(context)
                        .pushReplacementNamed(ViewFyersHolding.route);
                    BlocProvider.of<FetchingDataBloc>(context).add(
                        LoadFyersAccessTokenEvent(
                            getFyersAccessToken: GetFyersAccessTokenModel()));
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
