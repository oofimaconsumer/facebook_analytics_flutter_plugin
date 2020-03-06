import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacebookAnalyticsPlugin {
  static const MethodChannel _channel =
      const MethodChannel('facebook_analytics_plugin');

  // Public

  /// Logs a custom Facebook event with the given [name] and event [parameters]
  static Future<void> logCustomEvent(
      {@required String name, Map<String, dynamic> parameters}) async {
    if (parameters == null) {
      parameters = {};
    }
    await _channel.invokeMethod(
        'logCustomEvent', {"name": name, "parameters": parameters});
  }

  /// Logs ...
  static Future<void> logCompletedRegistration() async {
    await _channel.invokeMethod("logCompletedRegistration");
  }

  /// Logs ...
  static Future<void> logCompletedPurchaseWith({@required double amount, @required String currency}) async {
    await _channel
        .invokeMethod("logCompletedPurchase", {"amount": amount, "currency": currency});
  }

  /// ...
  static Future<void> setAndHash({
    String email,
    String firstName,
    String lastName,
    String phone,
    String dateOfBirth,
    String gender,
    String city,
    String state,
    String zip,
    String country,
  }) async {
    await _channel.invokeMethod("setUserData", {
      "parameters": _captureNonnullFrom(map: {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "city": city,
        "state": state,
        "zip": zip,
        "country": country,
      })
    });
  }

  // Private

  static Map<String, dynamic> _captureNonnullFrom(
      {@required Map<String, dynamic> map}) {
    Map<String, dynamic> captured = {};
    map.forEach((key, value) {
      if (value != null) {
        captured[key] = value;
      }
    });
    return captured;
  }
}
