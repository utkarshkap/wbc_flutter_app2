import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/brokers_api/IIFL/encryption_client_data.dart';
import 'package:wbc_connect_app/presentations/brokers_api/IIFL/view_IIFL_holding.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class WebviewIIFL extends StatefulWidget {
  static const route = '/Webview-IIFL';
  const WebviewIIFL({Key? key}) : super(key: key);

  @override
  State<WebviewIIFL> createState() => _WebviewIIFLState();
}

class _WebviewIIFLState extends State<WebviewIIFL> {
  InAppWebViewController? webViewController;

  final TextEditingController clientIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
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
        listener: (context, state) {
          // Error handling can be added here for login failure
        },
        builder: (context, state) {
          if (state is IIFLLoginLoaded) {
            print('cookie::::${state.cookie}');
            if (state.cookie.isNotEmpty) {
              BlocProvider.of<FetchingDataBloc>(context).add(
                  LoadIIFLHoldingEvent(
                      cookie: state.cookie,
                      clientCode: clientIDController.text));

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context)
                    .pushReplacementNamed(ViewIIFLHolding.route);
              });
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              // Added Form for validation
              key: _formKey, // Assign the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(icIifl, width: 120.w, height: 20.h),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: clientIDController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: 'Client ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Validation for Client ID
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Client ID cannot be empty';
                      } else if (value.length < 4) {
                        return 'Client ID must be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Validation for Password
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value.length < 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, proceed with login
                          DateTime dateTime = DateTime.parse(ApiUser.userDob);

                          var clientCode = EncryptionClientData()
                              .encryptText(clientIDController.text);
                          var password = EncryptionClientData()
                              .encryptText(passwordController.text);
                          var dob = EncryptionClientData().encryptText(
                              DateFormat('yyyyMMdd').format(dateTime));

                          BlocProvider.of<FetchingDataBloc>(context).add(
                              LoadIIFLLoginEvent(
                                  clientCode: clientCode,
                                  password: password,
                                  dob: dob));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('LOGIN'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
