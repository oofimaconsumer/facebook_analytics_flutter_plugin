package com.facebook_events_plugin.facebook_analytics_plugin;

import android.os.Bundle;

import com.facebook.FacebookSdk;
import com.facebook.LoggingBehavior;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;

import java.util.Iterator;
import java.util.Map;
import java.math.BigDecimal;
import java.util.Currency;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FacebookAnalyticsPlugin implements MethodCallHandler {
  private final PluginRegistry.Registrar registrar;
  private  final AppEventsLogger appEventsLogger;

  private FacebookAnalyticsPlugin(PluginRegistry.Registrar registrar) {
    this.registrar = registrar;
    FacebookSdk.setAutoInitEnabled(true);
    FacebookSdk.fullyInitialize();
    System.out.println(FacebookSdk.isInitialized());
    appEventsLogger = AppEventsLogger.newLogger(registrar.context());
    if (BuildConfig.DEBUG) {
      FacebookSdk.setIsDebugEnabled(true);
      FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
    }
  }

  // Public

  // Overrides

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "facebook_analytics_plugin");
    channel.setMethodCallHandler(new FacebookAnalyticsPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "logCustomEvent":
        handleLogEvent(call);
        result.success(null);
        break;
      case "logCompletedRegistration":
        logCompletedRegistration();
        result.success(null);
        break;
      case "logCompletedPurchase":
        logCompletedPurchase(call);
        result.success(null);
        break;
      case "setUserData":
        setAndHash(call);
        result.success(null);
        break;
      default:
        result.notImplemented();
    }
  }

  // Private

  // Log handlers

  private void handleLogEvent(MethodCall call) {
    Map<String,Object> parameters = call.argument("parameters");
    String eventName = call.argument("name");
    if (parameters == null || parameters.isEmpty()) {
      appEventsLogger.logEvent(eventName);
    } else {
      Bundle bundleParams = createBundleFromMap(parameters);
      appEventsLogger.logEvent(eventName, bundleParams);
    }
  }

  private void logCompletedRegistration() {
    appEventsLogger.logEvent(AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION);
  }

  private void logCompletedPurchase(MethodCall call) {
    Map parameters = call.argument("parameters");
    Double amount = new Double(parameters.get("amount").toString());
    Currency currency = Currency.getInstance(parameters.get("currency").toString());
    appEventsLogger.logPurchase(BigDecimal.valueOf(amount), currency);
  }

  private void setAndHash(MethodCall call) {
    Map<String,String> parameters = call.argument("parameters");
    appEventsLogger.setUserData(parameters.get("email"), parameters.get("firstName"), parameters.get("lastName"), parameters.get("phone"), parameters.get("dateOfBirth"), parameters.get("gender"), parameters.get("city"), parameters.get("state"), parameters.get("zip"), parameters.get("country"));
  }

  // Helpers

  private Bundle createBundleFromMap(Map paramMap) {
    Bundle bundleParams = new Bundle();
    Iterator it = paramMap.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      switch (pair.getValue().getClass().getSimpleName()) {
        case  "String":
          bundleParams.putString((String)pair.getKey(), (String)pair.getValue());
          break;
        case "Integer":
          bundleParams.putInt((String) pair.getKey(), (Integer) pair.getValue());
          break;
        case "Long":
          bundleParams.putLong((String)pair.getKey(),(Long)pair.getValue());
          break;
        case "Double":
          bundleParams.putDouble((String) pair.getKey(), (Double) pair.getValue());
          break;
        case "Boolean":
          bundleParams.putBoolean((String) pair.getKey(), (Boolean) pair.getValue());
          break;
        default:
          throw new IllegalArgumentException("Unsupported value type: " + pair.getKey().getClass().getSimpleName());

      }
      it.remove();
    }
    return bundleParams;
  }
}
