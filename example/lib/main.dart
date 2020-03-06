import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facebook_analytics_plugin/facebook_analytics_plugin.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  // Public

  // Overrides

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Public

  // Overrides

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Analytics Example'),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              padding: EdgeInsets.fromLTRB(
                  16.0,
                  MediaQuery.of(context).padding.top + 16.0,
                  16.0,
                  MediaQuery.of(context).padding.bottom + 16.0),
              children: <Widget>[
                _buildButtonWith(
                  text: "Log custom event",
                  onPressed: () {
                    _logCustomEvent();
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                _buildButtonWith(
                  text: "Log completed registration",
                  onPressed: () {
                    _logCompletedRegistration();
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                _buildButtonWith(
                  text: "Set user data",
                  onPressed: () {
                    _setUserData();
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                _buildButtonWith(
                  text: "Log completed purchase",
                  onPressed: () {
                    _logCompletedPurchase();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Private

  // Builders

  Widget _buildButtonWith({
    @required String text,
    @required Function onPressed,
  }) {
    return Container(
      width: double.infinity,
      child: CupertinoButton.filled(
        child: Text(
          text,
          style: TextStyle(fontSize: 15.0),
        ),
        onPressed: onPressed,
      ),
    );
  }

  // Analytics

  void _logCustomEvent() async {
    await FacebookAnalyticsPlugin.logCustomEvent(
      name: "event_name",
      parameters: {"key": "value"},
    );
  }

  void _logCompletedRegistration() async {
    await FacebookAnalyticsPlugin.logCompletedRegistration();
  }

  void _setUserData() async {
    await FacebookAnalyticsPlugin.setAndHash(
      firstName: "Kimi-Matias",
      lastName: "Räikkönen",
      dateOfBirth: "17.10.1979",
      country: "FI",
    );
  }

  void _logCompletedPurchase() async {
    await FacebookAnalyticsPlugin.logCompletedPurchaseWith(
        amount: 100.0, currency: "RUB");
  }
}
