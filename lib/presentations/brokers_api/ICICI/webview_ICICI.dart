// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/get_icici_holdingData_model.dart';
import 'package:wbc_connect_app/presentations/brokers_api/ICICI/view_icici_holding.dart';
import 'package:wbc_connect_app/resources/colors.dart';
import 'package:wbc_connect_app/resources/icons.dart';

import '../../../models/get_icici_session_token_model.dart';

class WebViewICICI extends StatefulWidget {
  static const route = '/Webview-ICICI';

  const WebViewICICI({super.key});

  @override
  State<WebViewICICI> createState() => _WebViewICICIState();
}

class _WebViewICICIState extends State<WebViewICICI> {
  InAppWebViewController? webViewController;

  String? IIFLUrl;
  String? url;

  @override
  void initState() {
    IIFLUrl = "https://api.icicidirect.com/apiuser/login?api_key=$iCICIApiKey";
    apiCall();
    super.initState();
    stream_controller = StreamController<int>.broadcast();
  }

  apiCall() {
    print('-----------------------------------------');
    BlocProvider.of<FetchingDataBloc>(context).add(LoadICICISessionTokenEvent(
        sessionToken: '34256580',
        getICICISessionToken: GetIciciSessionTokenModel()));
  }

  late StreamController<int> stream_controller;

  @override
  void dispose() {
    stream_controller.close();
    super.dispose();

    print("DISPOSE------------------------------------");
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
              Navigator.of(context)
                  .pushReplacementNamed(ViewICICIHolding.route);

              // Navigator.of(context).pop();
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
                  if (finalUrl.contains("apisession")) {
                    int startIndex = finalUrl.indexOf("apisession=");
                    String requestToken = finalUrl
                        .substring(startIndex)
                        .trim()
                        .replaceAll("apisession=", '');

                    print("requestToken--->" + requestToken);
                    Navigator.of(context)
                        .pushReplacementNamed(ViewICICIHolding.route);
                    BlocProvider.of<FetchingDataBloc>(context).add(
                        LoadICICISessionTokenEvent(
                            sessionToken: requestToken,
                            getICICISessionToken: GetIciciSessionTokenModel()));
                  }
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print("consoleMessage-->$consoleMessage");
              },
            )),
            InkWell(
              onTap: () {
                BlocProvider.of<FetchingDataBloc>(context).add(
                    LoadICICIHoldingDataEvent(
                        sessionToken: 'QUI0OTMxMDA6NTc0NTkzNjg=',
                        getICICIHoldingData: GetIciciHoldingDataModel()));
              },
              child: Container(
                height: 100,
                width: 100,
                color: Colors.purple,
              ),
            )
          ]);
        },
      ),
    );
  }
}
