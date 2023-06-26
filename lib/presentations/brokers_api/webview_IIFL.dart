import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';

class WebviewIIFL extends StatefulWidget {

  static const route = '/Webview-IIFL';
  const WebviewIIFL({Key? key}) : super(key: key);

  @override
  State<WebviewIIFL> createState() => _WebviewIIFLState();
}

class _WebviewIIFLState extends State<WebviewIIFL> {

  InAppWebViewController? webViewController;
  String? IIFLUrl;

  @override
  void initState() {
    IIFLUrl="https://ttweb.indiainfoline.com/trade/Login.aspx";
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
            icon: Image.asset(icBack, color: colorRed, width: 6.w)
        ),
      ),
      body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
              children: <Widget>[
                Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(IIFLUrl!)),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          String finalUrl=url.toString();
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
                    )
                )
              ]
          );
        },
      ),
    );
  }
}